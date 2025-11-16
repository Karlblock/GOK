#!/bin/bash

# ===========================================
# GOK8S - Status Check Script
# Affiche l'état complet de l'environnement
# ===========================================

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CLUSTER_NAME="gotk8s"

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

check_docker() {
    print_header "Docker Status"
    if command -v docker &> /dev/null; then
        print_success "Docker installé: $(docker --version)"
        if docker ps &> /dev/null; then
            print_success "Docker daemon en cours d'exécution"
            echo "  Conteneurs actifs: $(docker ps -q | wc -l)"
        else
            print_error "Docker daemon non accessible"
        fi
    else
        print_error "Docker non installé"
    fi
}

check_kind() {
    print_header "kind Status"
    if command -v kind &> /dev/null; then
        print_success "kind installé: $(kind --version)"

        local clusters=$(kind get clusters 2>/dev/null)
        if [ -n "$clusters" ]; then
            echo "  Clusters kind:"
            echo "$clusters" | while read -r cluster; do
                if [ "$cluster" = "$CLUSTER_NAME" ]; then
                    echo -e "    ${GREEN}● $cluster${NC}"
                else
                    echo "    ○ $cluster"
                fi
            done
        else
            print_info "Aucun cluster kind trouvé"
        fi
    else
        print_error "kind non installé"
    fi
}

check_kubectl() {
    print_header "kubectl Status"
    if command -v kubectl &> /dev/null; then
        print_success "kubectl installé: $(kubectl version --client --short 2>/dev/null || kubectl version --client | head -n1)"
    else
        print_error "kubectl non installé"
    fi
}

check_cluster() {
    print_header "Cluster gotk8s"

    if ! kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        print_error "Cluster '${CLUSTER_NAME}' non trouvé"
        echo ""
        echo "Pour créer le cluster:"
        echo "  ./gok-deploy.sh"
        return 1
    fi

    print_success "Cluster '${CLUSTER_NAME}' existe"

    # Vérifier les nœuds
    echo ""
    echo "Nœuds du cluster:"
    kubectl get nodes 2>/dev/null || print_error "Impossible de se connecter au cluster"
}

check_gotk8s() {
    print_header "GOTK8S Deployment"

    if ! kubectl get namespace westeros &> /dev/null; then
        print_error "Namespace 'westeros' non trouvé"
        echo ""
        echo "Pour déployer GOTK8S:"
        echo "  ./gok-deploy.sh"
        return 1
    fi

    print_success "Namespace 'westeros' existe"

    echo ""
    echo "Pods dans westeros:"
    kubectl get pods -n westeros

    echo ""
    echo "Services dans westeros:"
    kubectl get svc -n westeros
}

check_services() {
    print_header "Services Accessibility"

    echo ""
    echo "Test des services exposés:"

    # Test frontend
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:30100 2>/dev/null | grep -q "200\|301\|302"; then
        print_success "Frontend accessible: http://localhost:30100"
    else
        print_error "Frontend non accessible: http://localhost:30100"
    fi

    # Test API
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:30101 2>/dev/null | grep -q "200\|301\|302"; then
        print_success "API accessible: http://localhost:30101"
    else
        print_error "API non accessible: http://localhost:30101"
    fi
}

check_disk_usage() {
    print_header "Disk Usage"

    echo ""
    echo "Images Docker gotk8s/*:"
    docker images | grep "^gotk8s/" | while read -r line; do
        echo "  $line"
    done || echo "  Aucune image gotk8s trouvée"

    echo ""
    echo "Taille totale des images gotk8s:"
    local total_size=$(docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}" | grep "^gotk8s/" | awk '{print $2}' | sed 's/MB//g; s/GB/*1024/g' | bc 2>/dev/null | awk '{sum+=$1} END {print sum}')
    if [ -n "$total_size" ] && [ "$total_size" != "0" ]; then
        echo "  ~${total_size}MB"
    else
        echo "  Calcul non disponible"
    fi

    echo ""
    echo "Espace Docker total:"
    docker system df 2>/dev/null || echo "  Non disponible"
}

show_quick_commands() {
    print_header "Quick Commands"

    echo ""
    echo "Déploiement:"
    echo "  ./gok-deploy.sh         # Créer et déployer l'environnement complet"
    echo ""
    echo "Gestion:"
    echo "  ./gok-start.sh          # Vérifier l'environnement existant"
    echo "  ./gok-status.sh         # Afficher ce rapport de statut"
    echo "  ./gok-cleanup.sh        # Supprimer complètement l'environnement"
    echo ""
    echo "Kubernetes:"
    echo "  kubectl get all -n westeros"
    echo "  kubectl logs -f deployment/the-north-api -n westeros"
    echo "  kubectl describe pod <pod-name> -n westeros"
    echo ""
}

# Main
main() {
    print_header "GOK8S - Environment Status Report"

    check_docker
    check_kind
    check_kubectl
    check_cluster
    check_gotk8s
    check_services
    check_disk_usage
    show_quick_commands

    echo ""
}

main "$@"
