#!/bin/bash

# ===========================================
# GOK8S - Script d'accès au Kubernetes Dashboard
# ===========================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       🌐 Accès au Kubernetes Dashboard                  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}➜ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

check_dashboard() {
    if ! kubectl get namespace kubernetes-dashboard &>/dev/null; then
        print_error "Le Dashboard Kubernetes n'est pas installé"
        echo ""
        echo "Pour l'installer, relancez: ./k3d-deploy"
        echo "et choisissez 'Y' quand demandé."
        exit 1
    fi
}

get_token() {
    local token=$(kubectl get secret admin-user-token -n kubernetes-dashboard -o jsonpath='{.data.token}' 2>/dev/null | base64 -d)

    if [ -z "$token" ]; then
        print_error "Token non trouvé"
        return 1
    fi

    echo "$token"
}

main() {
    print_header

    check_dashboard

    print_success "Dashboard Kubernetes détecté"
    echo ""

    print_info "Récupération du token d'accès..."
    local token=$(get_token)

    if [ -z "$token" ]; then
        exit 1
    fi

    print_success "Token récupéré"
    echo ""

    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Instructions d'accès:${NC}"
    echo ""
    echo "1. Le proxy Kubernetes va démarrer en arrière-plan"
    echo "2. Ouvrez votre navigateur à l'URL suivante:"
    echo ""
    echo -e "${GREEN}http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/${NC}"
    echo ""
    echo "3. Choisissez 'Token' et collez le token ci-dessous:"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "$token"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    print_info "Démarrage du proxy Kubernetes..."
    echo ""
    echo -e "${CYAN}💡 Astuce:${NC} Laissez cette fenêtre ouverte"
    echo -e "${CYAN}💡 Pour arrêter:${NC} Appuyez sur Ctrl+C"
    echo ""

    # Démarrer le proxy
    kubectl proxy
}

main "$@"
