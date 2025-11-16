#!/bin/bash

# ===========================================
# GOK8S - Deployment Script pour k3d
# Déploie automatiquement l'environnement Game Of Kubernetes avec k3d
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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
K3D_BIN="${HOME}/bin/k3d"

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

    if [ ! -f "${K3D_BIN}" ]; then
        missing_deps+=("k3d")
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
                k3d)
                    echo "  - k3d: mkdir -p ~/bin && curl -Lo ~/bin/k3d https://github.com/k3d-io/k3d/releases/download/v5.6.0/k3d-linux-amd64 && chmod +x ~/bin/k3d"
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
    echo "  - k3d: $(${K3D_BIN} version | head -n1)"
    echo "  - kubectl: $(kubectl version --client --short 2>/dev/null || kubectl version --client | head -n1)"
}

check_existing_cluster() {
    print_header "Vérification du cluster existant"

    if ${K3D_BIN} cluster list 2>/dev/null | grep -q "^${CLUSTER_NAME} "; then
        print_info "Un cluster '${CLUSTER_NAME}' existe déjà"
        read -p "Voulez-vous le supprimer et le recréer? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Suppression du cluster existant..."
            ${K3D_BIN} cluster delete "${CLUSTER_NAME}"
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
    print_header "Création du cluster Kubernetes avec k3d"

    cd "${SCRIPT_DIR}"

    print_info "Création du cluster '${CLUSTER_NAME}' (1 server + 2 agents)..."
    print_success "✅ k3d supporte nativement cgroup v2 - multi-node garanti!"

    ${K3D_BIN} cluster create ${CLUSTER_NAME} \
        --servers 1 \
        --agents 2 \
        -p "30100:30100@loadbalancer" \
        -p "30101:30101@loadbalancer" \
        -p "30200:30200@loadbalancer"

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

load_images_to_k3d() {
    print_header "Chargement des images dans k3d"

    cd "${SCRIPT_DIR}/kingdoms"

    print_info "Chargement des images dans le cluster k3d..."

    local images=(
        "gotk8s/the-north-api:1.0"
        "gotk8s/the-north-frontend:1.0"
    )

    for image in "${images[@]}"; do
        print_info "Chargement de ${image}..."
        ${K3D_BIN} image import "${image}" -c "${CLUSTER_NAME}"
    done

    print_success "Images chargées dans k3d"
}

deploy_dashboard() {
    print_header "Déploiement du Kubernetes Dashboard"

    print_info "Installation du Kubernetes Dashboard..."
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

    print_info "Création du ServiceAccount admin-user..."
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

    print_info "Création du ClusterRoleBinding..."
    cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

    print_info "Attente du déploiement du dashboard..."
    kubectl wait --for=condition=available deployment/kubernetes-dashboard -n kubernetes-dashboard --timeout=120s || true

    print_success "Kubernetes Dashboard déployé"

    # Créer un token pour l'accès
    print_info "Génération du token d'accès..."
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: admin-user-token
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token
EOF

    sleep 2

    echo ""
    print_success "Dashboard installé! Token d'accès:"
    echo ""
    kubectl get secret admin-user-token -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 -d
    echo ""
    echo ""
    print_info "Pour accéder au dashboard:"
    echo "  1. Lancer le proxy: kubectl proxy"
    echo "  2. Ouvrir: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
    echo "  3. Utiliser le token ci-dessus pour se connecter"
    echo ""
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
    echo "Nœuds du cluster (multi-node!):"
    kubectl get nodes

    echo ""
    echo "Pods dans le namespace westeros:"
    kubectl get pods -n westeros -o wide

    echo ""
    echo "Services:"
    kubectl get svc -n westeros
}

show_access_info() {
    print_header "Informations d'accès"

    echo ""
    echo -e "${YELLOW}URLs d'accès GOTK8S:${NC}"
    echo "  Frontend The North:  http://localhost:30100"
    echo "  API The North:       http://localhost:30101"
    echo ""

    # Vérifier si le dashboard est installé
    if kubectl get namespace kubernetes-dashboard &>/dev/null; then
        echo -e "${YELLOW}Kubernetes Dashboard:${NC}"
        echo "  1. Lancer le proxy: kubectl proxy"
        echo "  2. URL: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
        echo ""
        echo "  Token d'accès (copier/coller):"
        kubectl get secret admin-user-token -n kubernetes-dashboard -o jsonpath='{.data.token}' 2>/dev/null | base64 -d && echo ""
        echo ""
    fi

    echo -e "${YELLOW}Commandes utiles:${NC}"
    echo "  # Voir tous les pods avec leur nœud"
    echo "  kubectl get pods -n westeros -o wide"
    echo ""
    echo "  # Voir les logs de l'API"
    echo "  kubectl logs -f deployment/the-north-api -n westeros"
    echo ""
    echo "  # Accéder au Dashboard (si installé)"
    echo "  kubectl proxy"
    echo ""
    echo "  # Lister les clusters k3d"
    echo "  ${K3D_BIN} cluster list"
    echo ""
    echo "  # Supprimer le cluster"
    echo "  ${K3D_BIN} cluster delete ${CLUSTER_NAME}"
    echo ""
    echo -e "${GREEN}Multi-node cluster with k3d! 🎉🐺${NC}"
    echo ""
}

# Main
main() {
    print_header "GOK8S - k3d Multi-Node Deployment"

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
        load_images_to_k3d
    fi

    # Demander si l'utilisateur veut déployer le Dashboard
    echo ""
    read -p "Installer le Kubernetes Dashboard? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        deploy_dashboard
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
