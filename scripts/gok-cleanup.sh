#!/bin/bash

# ===========================================
# GOK8S - Cleanup Script
# Nettoie l'environnement Game Of Kubernetes
# ===========================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CLUSTER_NAME="gotk8s"

print_header() {
    echo ""
    echo -e "${YELLOW}======================================"
    echo "  $1"
    echo "======================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

main() {
    print_header "GOK8S - Cleanup"

    echo ""
    echo "Ce script va supprimer:"
    echo "  - Le cluster kind '${CLUSTER_NAME}'"
    echo "  - Les images Docker gotk8s/*"
    echo ""
    read -p "Êtes-vous sûr? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Annulé."
        exit 0
    fi

    # Supprimer le cluster
    if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        print_info "Suppression du cluster kind..."
        kind delete cluster --name "${CLUSTER_NAME}"
        print_success "Cluster supprimé"
    else
        print_info "Aucun cluster '${CLUSTER_NAME}' trouvé"
    fi

    # Supprimer les images Docker
    print_info "Suppression des images Docker gotk8s/*..."
    docker images --format "{{.Repository}}:{{.Tag}}" | grep "^gotk8s/" | xargs -r docker rmi -f || true
    print_success "Images Docker supprimées"

    print_header "Nettoyage terminé"
    echo ""
    echo "Pour recréer l'environnement:"
    echo "  ./gok-deploy.sh"
    echo ""
}

main "$@"
