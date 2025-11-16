#!/bin/bash

# Script de load testing pour la démonstration
# Génère du trafic HTTP pour déclencher l'autoscaling

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
URL="${DEMO_URL:-http://localhost:30200}"
USERS=${1:-10}
DURATION=${2:-60}

echo -e "${BLUE}🔥 Démarrage du Load Testing${NC}"
echo -e "${YELLOW}URL: $URL${NC}"
echo -e "${YELLOW}Utilisateurs simulés: $USERS${NC}"
echo -e "${YELLOW}Durée: $DURATION secondes${NC}"
echo ""

# Fonction pour générer du trafic
generate_load() {
    local user_id=$1
    local end_time=$((SECONDS + DURATION))

    while [ $SECONDS -lt $end_time ]; do
        curl -s "$URL" > /dev/null 2>&1
        sleep 0.1
    done
}

# Lancer les utilisateurs simulés en parallèle
for i in $(seq 1 $USERS); do
    generate_load $i &
done

echo -e "${GREEN}✓ $USERS utilisateurs lancés${NC}"
echo -e "${YELLOW}Appuyez sur Ctrl+C pour arrêter...${NC}"

# Attendre que tous les processus se terminent
wait

echo -e "${GREEN}✓ Test terminé${NC}"
