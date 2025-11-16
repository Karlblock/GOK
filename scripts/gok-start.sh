#!/bin/bash

# ===========================================
# GOK8S - Quick Start Script
# Démarre rapidement un environnement existant
# ===========================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CLUSTER_NAME="gotk8s"

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Vérifier si le cluster existe
if ! kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo -e "${YELLOW}Le cluster '${CLUSTER_NAME}' n'existe pas.${NC}"
    echo ""
    echo "Pour créer l'environnement complet:"
    echo "  ./gok-deploy.sh"
    exit 1
fi

print_info "Cluster '${CLUSTER_NAME}' détecté"

# Vérifier le contexte kubectl
print_info "Configuration de kubectl..."
kubectl cluster-info --context "kind-${CLUSTER_NAME}" > /dev/null 2>&1

# Afficher le statut
echo ""
echo -e "${BLUE}Statut du cluster:${NC}"
kubectl get nodes

echo ""
echo -e "${BLUE}Pods dans Westeros:${NC}"
kubectl get pods -n westeros 2>/dev/null || echo "Namespace 'westeros' non trouvé. Déployez GOTK8S avec: ./gok-deploy.sh"

echo ""
echo -e "${GREEN}======================================"
echo "  GOK8S - Ready"
echo "======================================${NC}"
echo ""
echo -e "${YELLOW}URLs d'accès:${NC}"
echo "  Frontend:  http://localhost:30100"
echo "  API:       http://localhost:30101"
echo ""
echo -e "${YELLOW}Commandes utiles:${NC}"
echo "  kubectl get all -n westeros"
echo "  kubectl logs -f deployment/the-north-api -n westeros"
echo ""
