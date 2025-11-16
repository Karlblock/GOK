#!/bin/bash

# ===========================================
# GOK8S - Deployment Script
# Déploie automatiquement l'environnement Game Of Kubernetes
# ===========================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="gotk8s"
CLUSTER_CONFIG="kind/cluster-config.yaml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fonctions utilitaires
print_header() {
    echo ""
    echo -e "${BLUE}======================================"
    echo "  $1"
    echo "======================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

check_dependencies() {
    print_header "Vérification des dépendances"

    local missing_deps=()

    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi

    if ! command -v kind &> /dev/null; then
        missing_deps+=("kind")
    fi

    if ! command -v kubectl &> /dev/null; then
        missing_deps+=("kubectl")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dépendances manquantes: ${missing_deps[*]}"
        echo ""
        echo "Installation requise:"
        for dep in "${missing_deps[@]}"; do
            case $dep in
                docker)
                    echo "  - Docker: https://docs.docker.com/get-docker/"
                    ;;
                kind)
                    echo "  - kind: curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64 && chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind"
                    ;;
                kubectl)
                    echo "  - kubectl: https://kubernetes.io/docs/tasks/tools/"
                    ;;
            esac
        done
        exit 1
    fi

    print_success "Toutes les dépendances sont installées"
    echo "  - Docker: $(docker --version)"
    echo "  - kind: $(kind --version)"
    echo "  - kubectl: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
}

check_existing_cluster() {
    print_header "Vérification du cluster existant"

    if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        print_info "Un cluster '${CLUSTER_NAME}' existe déjà"
        read -p "Voulez-vous le supprimer et le recréer? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Suppression du cluster existant..."
            kind delete cluster --name "${CLUSTER_NAME}"
            print_success "Cluster supprimé"
            return 0
        else
            print_info "Utilisation du cluster existant"
            return 1
        fi
    fi
    return 0
}

create_cluster() {
    print_header "Création du cluster Kubernetes"

    cd "${SCRIPT_DIR}"

    if [ ! -f "${CLUSTER_CONFIG}" ]; then
        print_error "Fichier de configuration introuvable: ${CLUSTER_CONFIG}"
        exit 1
    fi

    print_info "Création du cluster '${CLUSTER_NAME}' (single-node)..."
    echo -e "${YELLOW}  Note: Workers désactivés (problème cgroup v2). Voir TROUBLESHOOTING_KIND.md${NC}"
    kind create cluster --config "${CLUSTER_CONFIG}"

    print_success "Cluster créé avec succès"

    # Attendre que le cluster soit prêt
    print_info "Attente que le cluster soit prêt..."
    kubectl wait --for=condition=ready node --all --timeout=120s

    print_success "Cluster opérationnel"
    kubectl get nodes
}

build_images() {
    print_header "Construction des images Docker"

    cd "${SCRIPT_DIR}/kingdoms"

    if [ ! -f "build-images.sh" ]; then
        print_error "Script build-images.sh introuvable"
        exit 1
    fi

    print_info "Construction des images des royaumes..."
    bash build-images.sh

    print_success "Images construites"
}

load_images_to_kind() {
    print_header "Chargement des images dans kind"

    cd "${SCRIPT_DIR}/kingdoms"

    print_info "Chargement des images dans le cluster kind..."

    local images=(
        "gotk8s/the-north-api:1.0"
        "gotk8s/the-north-frontend:1.0"
    )

    for image in "${images[@]}"; do
        print_info "Chargement de ${image}..."
        kind load docker-image "${image}" --name "${CLUSTER_NAME}"
    done

    print_success "Images chargées dans kind"
}

deploy_gotk8s() {
    print_header "Déploiement de GOTK8S"

    cd "${SCRIPT_DIR}"

    print_info "Création du namespace Westeros..."
    kubectl apply -f manifests/gotk8s/00-namespace/

    print_info "Déploiement de Redis (The Citadel's Cache)..."
    kubectl apply -f manifests/gotk8s/01-redis/

    print_info "Attente de Redis..."
    kubectl wait --for=condition=ready pod -l app=redis -n westeros --timeout=60s || true

    print_info "Déploiement de The North..."
    kubectl apply -f manifests/gotk8s/02-the-north/

    print_info "Déploiement des services..."
    kubectl apply -f manifests/gotk8s/03-ingress/

    print_success "GOTK8S déployé"

    print_info "Attente des pods..."
    kubectl wait --for=condition=ready pod -l kingdom=the-north -n westeros --timeout=120s || true
}

show_status() {
    print_header "Statut du déploiement"

    echo ""
    echo "Pods dans le namespace westeros:"
    kubectl get pods -n westeros

    echo ""
    echo "Services:"
    kubectl get svc -n westeros
}

show_access_info() {
    print_header "Informations d'accès"

    echo ""
    echo -e "${YELLOW}URLs d'accès:${NC}"
    echo "  Frontend The North:  http://localhost:30100"
    echo "  API The North:       http://localhost:30101"
    echo ""
    echo -e "${YELLOW}Commandes utiles:${NC}"
    echo "  # Voir tous les pods"
    echo "  kubectl get all -n westeros"
    echo ""
    echo "  # Voir les logs de l'API"
    echo "  kubectl logs -f deployment/the-north-api -n westeros"
    echo ""
    echo "  # Voir les logs du frontend"
    echo "  kubectl logs -f deployment/the-north-frontend -n westeros"
    echo ""
    echo "  # Supprimer le cluster"
    echo "  kind delete cluster --name ${CLUSTER_NAME}"
    echo ""
    echo -e "${GREEN}Winter is Coming... 🐺${NC}"
    echo ""
}

# Main
main() {
    print_header "GOK8S - Game Of Kubernetes Deployment"

    check_dependencies

    local create_new=true
    if ! check_existing_cluster; then
        create_new=false
    fi

    if [ "$create_new" = true ]; then
        create_cluster
    fi

    # Demander si l'utilisateur veut (re)construire les images
    echo ""
    read -p "Construire/reconstruire les images Docker? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        build_images
        load_images_to_kind
    fi

    # Demander si l'utilisateur veut déployer GOTK8S
    echo ""
    read -p "Déployer GOTK8S dans le cluster? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        deploy_gotk8s
        show_status
    fi

    show_access_info
}

# Point d'entrée
main "$@"
