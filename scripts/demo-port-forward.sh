#!/bin/bash

# Script de port-forward pour la démo (solution temporaire si port 30200 non mappé)

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}🔌 Port-forward pour démonstration${NC}"
echo -e "${CYAN}Port local 30200 → Service demo-webapp${NC}"
echo ""
echo -e "${YELLOW}Laissez cette fenêtre ouverte pendant la démonstration${NC}"
echo -e "${YELLOW}Appuyez sur Ctrl+C pour arrêter${NC}"
echo ""

kubectl port-forward -n demo svc/demo-webapp 30200:80
