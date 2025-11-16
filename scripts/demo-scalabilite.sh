#!/bin/bash

# ===========================================
# GOK8S - Démonstration Scalabilité & Cycle de Vie
# ===========================================

# Note: pas de set -e pour permettre une meilleure gestion des erreurs

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

print_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     🎬 Démonstration Scalabilité Kubernetes              ║${NC}"
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

show_menu() {
    print_header
    echo -e "${YELLOW}Choisissez un scénario de démonstration:${NC}"
    echo ""
    echo "  1. 🎬 Démonstration complète automatique"
    echo "  2. 📦 Déploiement initial seulement"
    echo "  3. 📈 Simulation montée en charge (10 users)"
    echo "  4. 🔥 Simulation montée en charge (50 users)"
    echo "  5. 💥 Simulation montée en charge (100 users)"
    echo "  6. 🚀 Stress test (500 users)"
    echo "  7. 📊 Voir état actuel du cluster"
    echo "  8. 🧹 Nettoyer la démonstration"
    echo "  9. 🌐 Ouvrir le Dashboard Kubernetes"
    echo "  0. 🚪 Quitter"
    echo ""
    echo -ne "${YELLOW}Choix [0-9]: ${NC}"
}

setup_port_forward() {
    # Vérifier si le port 30200 est déjà accessible
    if ! curl -s --connect-timeout 2 http://localhost:30200 > /dev/null 2>&1; then
        print_warning "Port 30200 non mappé - Configuration du port-forward..."

        # Tuer les anciens port-forward sur ce port
        pkill -f "port-forward.*demo-webapp" 2>/dev/null || true
        sleep 1

        # Lancer le port-forward en arrière-plan
        kubectl port-forward -n demo svc/demo-webapp 30200:80 > /tmp/demo-pf.log 2>&1 &
        local pf_pid=$!

        # Attendre que le port-forward soit prêt (max 10 tentatives)
        local attempts=0
        local max_attempts=10
        while [ $attempts -lt $max_attempts ]; do
            sleep 1
            if curl -s --connect-timeout 1 http://localhost:30200 > /dev/null 2>&1; then
                print_success "Port-forward configuré (PID: $pf_pid)"
                echo "$pf_pid" > /tmp/demo-portforward.pid
                return 0
            fi
            attempts=$((attempts + 1))
        done

        print_error "Échec du port-forward après ${max_attempts} tentatives"
        cat /tmp/demo-pf.log 2>/dev/null || true
        return 1
    else
        print_success "Port 30200 déjà accessible"
    fi
}

deploy_demo_app() {
    print_header
    echo -e "${CYAN}📦 Phase 1: Déploiement de l'application de démonstration${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    print_info "Déploiement du namespace et de l'application..."
    local deploy_output=$(kubectl apply -f "$PROJECT_DIR/manifests/demo/demo-deployment.yaml" 2>&1)
    if [ $? -eq 0 ]; then
        print_success "Application déployée"
    else
        print_error "Erreur lors du déploiement"
        echo "$deploy_output"
        return 1
    fi

    print_info "Attente du démarrage des pods..."
    if kubectl wait --for=condition=ready pod -l app=demo-webapp -n demo --timeout=60s > /dev/null 2>&1; then
        print_success "Application prête"
    else
        print_warning "Timeout - vérification manuelle requise"
        kubectl get pods -n demo
    fi

    print_info "Vérification du metrics-server (requis pour HPA)..."
    if ! kubectl get deployment metrics-server -n kube-system > /dev/null 2>&1; then
        print_info "Installation du metrics-server..."
        kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml > /dev/null 2>&1 || true
        kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' > /dev/null 2>&1 || true
        sleep 10
        print_success "Metrics-server installé"
    else
        print_success "Metrics-server déjà installé"
    fi

    print_info "Configuration de l'auto-scaling (HPA)..."
    kubectl apply -f "$PROJECT_DIR/manifests/demo/demo-hpa.yaml" > /dev/null 2>&1
    sleep 5
    print_success "HPA configuré (min: 1, max: 10 replicas)"

    echo ""

    # Configurer le port-forward si nécessaire
    setup_port_forward

    echo ""
    show_cluster_state
}

show_cluster_state() {
    echo -e "${CYAN}📊 État actuel du cluster:${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Récupérer les informations
    local replicas=$(kubectl get deployment demo-webapp -n demo -o jsonpath='{.status.replicas}' 2>/dev/null || echo "0")
    local ready=$(kubectl get deployment demo-webapp -n demo -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")

    echo -e "${YELLOW}Replicas:${NC} $ready/$replicas prêts"
    echo ""

    # Afficher les pods et leur distribution
    echo -e "${YELLOW}Distribution des pods:${NC}"
    kubectl get pods -n demo -o wide --no-headers 2>/dev/null | while read line; do
        local pod_name=$(echo $line | awk '{print $1}')
        local status=$(echo $line | awk '{print $3}')
        local node=$(echo $line | awk '{print $7}')

        if [ "$status" = "Running" ]; then
            echo -e "  ${GREEN}[▓]${NC} $pod_name → $node"
        else
            echo -e "  ${YELLOW}[░]${NC} $pod_name → $node ($status)"
        fi
    done

    echo ""

    # Afficher HPA si disponible
    if kubectl get hpa demo-webapp-hpa -n demo > /dev/null 2>&1; then
        echo -e "${YELLOW}Autoscaling (HPA):${NC}"
        kubectl get hpa demo-webapp-hpa -n demo --no-headers 2>/dev/null | while read line; do
            local min=$(echo $line | awk '{print $4}')
            local max=$(echo $line | awk '{print $5}')
            local current=$(echo $line | awk '{print $6}')
            echo -e "  Min: $min | Max: $max | Actuel: $current"
        done
        echo ""
    fi

    # Vérifier si le port 30200 est accessible
    if curl -s --connect-timeout 2 http://localhost:30200 > /dev/null 2>&1; then
        echo -e "${YELLOW}URL d'accès:${NC} http://localhost:30200"
    else
        echo -e "${YELLOW}URL d'accès:${NC} via kubectl port-forward"
        echo -e "${RED}⚠ Port 30200 non mappé dans k3d${NC}"
        echo -e "${CYAN}💡 Recréez le cluster avec: ./k3d-deploy${NC}"
        echo -e "${CYAN}   (le port 30200 a été ajouté à la config)${NC}"
    fi
    echo ""
}

run_load_test() {
    local users=$1
    local duration=${2:-60}

    # Vérifier que l'application est déployée
    if ! kubectl get namespace demo > /dev/null 2>&1; then
        print_header
        print_error "L'application de démonstration n'est pas déployée"
        echo ""
        print_info "Déployez d'abord l'application avec l'option 2 (Déploiement initial)"
        echo ""
        read -p "Voulez-vous la déployer maintenant? [o/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[OoYy]$ ]]; then
            deploy_demo_app
            echo ""
            print_success "Application déployée! Lancement du test..."
            sleep 2
        else
            return 0
        fi
    fi

    print_header
    echo -e "${CYAN}🔥 Simulation de montée en charge${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Utilisateurs simulés:${NC} $users"
    echo -e "${YELLOW}Durée:${NC} $duration secondes"
    echo -e "${YELLOW}URL cible:${NC} http://localhost:30200"
    echo ""

    print_info "Démarrage de la simulation..."
    echo ""

    # Lancer le load test en arrière-plan
    "$SCRIPT_DIR/demo-load-test.sh" $users $duration > /dev/null 2>&1 &
    local load_pid=$!

    # Monitorer en temps réel
    local elapsed=0
    while kill -0 $load_pid 2>/dev/null; do
        clear
        print_header
        echo -e "${CYAN}🔥 Simulation en cours...${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${YELLOW}👥 Utilisateurs:${NC} $users"
        echo -e "${YELLOW}⏱️  Temps écoulé:${NC} ${elapsed}s / ${duration}s"

        # Barre de progression
        local progress=$((elapsed * 100 / duration))
        local bar_length=50
        local filled=$((progress * bar_length / 100))
        local empty=$((bar_length - filled))
        echo -ne "${YELLOW}📊 Progression:${NC} ["
        printf '%*s' "$filled" '' | tr ' ' '▓'
        printf '%*s' "$empty" '' | tr ' ' '░'
        echo "] ${progress}%"
        echo ""

        show_cluster_state

        echo -e "${GREEN}💡 Astuce:${NC} Ouvrez le Dashboard Kubernetes dans un autre terminal"
        echo -e "   pour voir la visualisation graphique: ${CYAN}./dashboard-access${NC}"

        sleep 3
        elapsed=$((elapsed + 3))
    done

    wait $load_pid

    echo ""
    print_success "Simulation terminée"
    echo ""

    print_info "État final du cluster:"
    show_cluster_state

    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

full_demo() {
    print_header
    echo -e "${MAGENTA}🎬 DÉMONSTRATION COMPLÈTE DU CYCLE DE VIE${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    print_warning "Cette démonstration va:"
    echo "  1. Déployer une application de test"
    echo "  2. Configurer l'autoscaling (HPA)"
    echo "  3. Simuler une montée en charge progressive"
    echo "  4. Montrer le scaling automatique"
    echo "  5. Revenir à l'état initial"
    echo ""
    read -p "Continuer? [o/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
        return
    fi

    # Phase 1: Déploiement
    deploy_demo_app
    sleep 3

    # Phase 2: Charge légère
    print_info "Phase 2: Charge légère (10 utilisateurs)..."
    run_load_test 10 30

    # Phase 3: Charge moyenne
    print_info "Phase 3: Charge moyenne (50 utilisateurs)..."
    run_load_test 50 45

    # Phase 4: Charge importante
    print_info "Phase 4: Charge importante (100 utilisateurs)..."
    run_load_test 100 60

    # Phase 5: Retour au calme
    print_header
    echo -e "${GREEN}🎉 Démonstration terminée !${NC}"
    echo ""
    print_success "Vous avez vu:"
    echo "  ✓ Déploiement automatique"
    echo "  ✓ Scaling horizontal (1 → 10 pods)"
    echo "  ✓ Distribution multi-node"
    echo "  ✓ Load balancing automatique"
    echo "  ✓ Self-healing (Kubernetes recrée les pods)"
    echo ""

    show_cluster_state

    echo ""
    read -p "Appuyez sur Entrée pour revenir au menu..."
}

cleanup() {
    print_header
    echo -e "${YELLOW}🧹 Nettoyage de la démonstration${NC}"
    echo ""

    print_info "Suppression de l'application de démo..."
    kubectl delete namespace demo --ignore-not-found=true > /dev/null 2>&1
    print_success "Démonstration nettoyée"

    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

open_dashboard() {
    print_header
    echo -e "${CYAN}🌐 Ouverture du Dashboard Kubernetes${NC}"
    echo ""

    if [ -e "$PROJECT_DIR/dashboard-access" ] || [ -L "$PROJECT_DIR/dashboard-access" ]; then
        "$PROJECT_DIR/dashboard-access"
    else
        print_error "Script dashboard-access introuvable"
        echo ""
        print_info "Commandes manuelles:"
        echo "  kubectl proxy"
        echo "  Puis ouvrez: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
    fi

    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
}

# Main loop
main() {
    while true; do
        show_menu
        read choice

        case $choice in
            1)
                full_demo
                ;;
            2)
                deploy_demo_app
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)
                run_load_test 10
                ;;
            4)
                run_load_test 50
                ;;
            5)
                run_load_test 100
                ;;
            6)
                run_load_test 500
                ;;
            7)
                print_header
                show_cluster_state
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            8)
                cleanup
                ;;
            9)
                open_dashboard
                ;;
            0)
                print_header
                echo -e "${GREEN}Au revoir ! Winter is Coming... 🐺${NC}"
                echo ""
                exit 0
                ;;
            *)
                print_error "Choix invalide"
                sleep 2
                ;;
        esac
    done
}

# Point d'entrée
main "$@"
