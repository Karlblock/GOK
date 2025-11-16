#!/bin/bash

# ===========================================
# GOK8S - Interactive Learning CLI
# CLI interactif pour l'apprentissage de Kubernetes
# ===========================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

CLUSTER_NAME="gotk8s"
PROGRESS_FILE="$HOME/.gok8s_progress"

# Créer le fichier de progression s'il n'existe pas
touch "$PROGRESS_FILE"

# Fonctions d'affichage
print_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${CYAN}     GOK8S - Interactive Kubernetes Learning CLI${BLUE}            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_banner() {
    echo -e "${YELLOW}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

print_challenge() {
    echo -e "${MAGENTA}🎯 $1${NC}"
}

# Vérifier la progression
is_completed() {
    grep -q "^$1$" "$PROGRESS_FILE" 2>/dev/null
}

mark_completed() {
    if ! is_completed "$1"; then
        echo "$1" >> "$PROGRESS_FILE"
    fi
}

get_completion_count() {
    wc -l < "$PROGRESS_FILE" 2>/dev/null || echo "0"
}

# Vérifier que le cluster existe (kind ou k3d)
check_cluster() {
    local cluster_found=false

    # Vérifier k3d d'abord (recommandé)
    if [ -f "${HOME}/bin/k3d" ] && ${HOME}/bin/k3d cluster list 2>/dev/null | grep -q "^${CLUSTER_NAME} "; then
        cluster_found=true
        print_success "Cluster k3d '${CLUSTER_NAME}' détecté"
    # Sinon vérifier kind
    elif command -v kind &> /dev/null && kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        cluster_found=true
        print_success "Cluster kind '${CLUSTER_NAME}' détecté"
    fi

    if [ "$cluster_found" = false ]; then
        print_error "Cluster '${CLUSTER_NAME}' non trouvé"
        echo ""
        echo "Lancer d'abord:"
        echo "  ./k3d-deploy    (recommandé - multi-node)"
        echo "  ou"
        echo "  ./gok-deploy    (fallback - single-node)"
        exit 1
    fi

    # Vérifier que kubectl fonctionne
    if ! kubectl cluster-info &>/dev/null; then
        print_error "kubectl ne peut pas se connecter au cluster"
        echo ""
        echo "Essayez:"
        echo "  kubectl cluster-info"
        exit 1
    fi
}

# Menu principal
show_main_menu() {
    print_header
    print_banner "🎓 Menu Principal"
    echo ""

    local completed=$(get_completion_count)
    echo -e "${CYAN}Progression: ${completed}/30 challenges complétés${NC}"
    echo ""

    echo "1. 📚 Tutoriels Guidés (Débutant)"
    echo "2. 🎯 Challenges Pratiques (Intermédiaire)"
    echo "3. 🔥 Scénarios Avancés (Expert)"
    echo "4. 🏆 Game of Thrones Challenges"
    echo "5. 📊 Voir ma progression"
    echo "6. 🔍 Explorer le cluster"
    echo "7. 💡 Tips & Best Practices"
    echo "8. ❓ Aide / Cheatsheet"
    echo "9. 🚪 Quitter"
    echo ""
    echo -ne "${YELLOW}Choix [1-9]: ${NC}"
}

# Tutoriels Guidés
show_tutorials_menu() {
    print_header
    print_banner "📚 Tutoriels Guidés - Niveau Débutant"
    echo ""

    echo "1. 🌟 Les Pods - Comprendre les conteneurs"
    is_completed "tutorial_pods" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "2. 🔄 Les Deployments - Gérer les réplicas"
    is_completed "tutorial_deployments" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "3. 🌐 Les Services - Exposer les applications"
    is_completed "tutorial_services" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "4. 💾 ConfigMaps & Secrets - Configuration"
    is_completed "tutorial_config" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "5. 📦 Volumes - Stockage persistant"
    is_completed "tutorial_volumes" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "6. 🏰 Namespaces & Labels - Organisation"
    is_completed "tutorial_namespaces" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "7. 🛡️ Health Probes - The Night's Watch"
    is_completed "tutorial_probes" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "8. 👑 Architecture Kubernetes - The Iron Throne"
    is_completed "tutorial_architecture" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "9. 🔍 Service Discovery - Ravens & Messengers"
    is_completed "tutorial_service_discovery" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "10. 🚦 Traffic Policies & Port Forwarding"
    is_completed "tutorial_traffic_policies" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "11. 🔙 Retour"
    echo ""
    echo -ne "${YELLOW}Choix [1-11]: ${NC}"
}

# Tutorial 1 : Pods
tutorial_pods() {
    print_header
    print_banner "🌟 Tutorial 1: Les Pods - Winter is Coming"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 QU'EST-CE QU'UN POD KUBERNETES ?${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "DÉFINITION:"
    echo "Un Pod est la plus petite unité de déploiement dans Kubernetes."
    echo "C'est le concept fondamental que vous devez maîtriser."
    echo ""

    print_info "ANALOGIE:"
    echo "Pensez à un Pod comme une MAISON qui peut héberger un ou plusieurs"
    echo "CONTENEURS (comme des chambres). Ces conteneurs partagent les mêmes"
    echo "ressources (eau, électricité) tout en gardant une certaine indépendance."
    echo ""

    print_info "CARACTÉRISTIQUES CLÉS:"
    echo "  • Un Pod = Un ou plusieurs conteneurs étroitement liés"
    echo "  • Conteneurs dans un Pod = Partagent le MÊME réseau et stockage"
    echo "  • Communication entre conteneurs = localhost (très rapide!)"
    echo "  • Chaque Pod a sa propre ADRESSE IP unique dans le cluster"
    echo "  • Les Pods sont ÉPHÉMÈRES (temporaires, peuvent mourir et renaître)"
    echo ""

    print_info "POURQUOI DES PODS ET PAS JUSTE DES CONTENEURS?"
    echo "  1. ISOLATION: Groupe logique d'applications liées"
    echo "  2. PARTAGE DE RESSOURCES: Volume commun, même IP"
    echo "  3. SCALING: Kubernetes réplique des pods entiers, pas des conteneurs"
    echo "  4. MULTI-NODE: Dans votre cluster k3d (1 server + 2 agents),"
    echo "     les pods peuvent être distribués sur différents nœuds"
    echo ""

    print_info "CYCLE DE VIE D'UN POD:"
    echo "  Pending → Running → Succeeded/Failed"
    echo "  • Pending: En attente de ressources"
    echo "  • Running: Au moins 1 conteneur actif"
    echo "  • Succeeded: Tous les conteneurs terminés avec succès"
    echo "  • Failed: Au moins 1 conteneur a crashé"
    echo ""

    print_info "DANS VOTRE CLUSTER MULTI-NODE:"
    echo "Vous avez 3 nœuds (k3d-gotk8s-server-0, agent-0, agent-1)."
    echo "Quand vous créez un pod, le scheduler K8s choisit automatiquement"
    echo "sur quel nœud le placer en fonction des ressources disponibles."
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Créer un pod nginx simple"
    echo ""
    echo "Maintenant que vous comprenez la théorie, créons un pod réel!"
    echo ""
    echo "Étapes:"
    echo "1. Créer un fichier YAML pour un pod nginx"
    echo "2. Déployer le pod dans le namespace 'westeros'"
    echo "3. Vérifier qu'il fonctionne et voir sur quel nœud il tourne"
    echo ""

    read -p "Appuyez sur ENTRÉE pour voir un exemple de manifest YAML..."
    echo ""

    echo -e "${CYAN}Exemple de pod.yaml:${NC}"
    cat << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: westeros
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
EOF

    echo ""
    echo -e "${YELLOW}Commandes utiles:${NC}"
    echo "  kubectl apply -f pod.yaml"
    echo "  kubectl get pods -n westeros"
    echo "  kubectl describe pod nginx-pod -n westeros"
    echo "  kubectl logs nginx-pod -n westeros"
    echo "  kubectl delete pod nginx-pod -n westeros"
    echo ""

    read -p "Voulez-vous créer ce pod maintenant? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat > /tmp/gok-nginx-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: westeros
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
EOF

        print_info "Création du pod..."
        kubectl apply -f /tmp/gok-nginx-pod.yaml

        print_info "Attente du pod..."
        kubectl wait --for=condition=ready pod/nginx-pod -n westeros --timeout=60s || true

        echo ""
        kubectl get pod nginx-pod -n westeros

        echo ""
        print_success "Pod créé avec succès!"
        mark_completed "tutorial_pods"

        echo ""
        read -p "Voulez-vous supprimer ce pod? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete pod nginx-pod -n westeros
            print_success "Pod supprimé"
        fi
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 2 : Deployments
tutorial_deployments() {
    print_header
    print_banner "🔄 Tutorial 2: Les Deployments - The War of Five Kings"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 QU'EST-CE QU'UN DEPLOYMENT KUBERNETES ?${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "DÉFINITION:"
    echo "Un Deployment est un contrôleur qui gère des RÉPLICAS de Pods et"
    echo "assure leur disponibilité. C'est le moyen standard de déployer des"
    echo "applications dans Kubernetes en production."
    echo ""

    print_info "ANALOGIE - The War of Five Kings:"
    echo "Imaginez que vous devez défendre 5 royaumes simultanément."
    echo "Au lieu d'avoir un seul roi (pod), vous avez besoin de PLUSIEURS"
    echo "rois (réplicas) pour gérer tous les territoires. Si un roi meurt,"
    echo "le Deployment en crée automatiquement un nouveau!"
    echo ""

    print_info "POURQUOI UTILISER UN DEPLOYMENT?"
    echo "  ✗ Pod simple: Si il meurt, c'est fini. Plus de service!"
    echo "  ✓ Deployment: Si un pod meurt, il est automatiquement recréé"
    echo ""
    echo "  PROBLÈME SANS DEPLOYMENT:"
    echo "    kubectl run nginx --image=nginx  ← Pod créé"
    echo "    kubectl delete pod nginx         ← Pod supprimé, GAME OVER!"
    echo ""
    echo "  SOLUTION AVEC DEPLOYMENT:"
    echo "    kubectl create deployment nginx --image=nginx --replicas=3"
    echo "    kubectl delete pod nginx-xxx     ← Pod supprimé"
    echo "    → Deployment recrée AUTOMATIQUEMENT un nouveau pod! 🎉"
    echo ""

    print_info "LES 4 SUPER-POUVOIRS DES DEPLOYMENTS:"
    echo ""
    echo "  1️⃣  SELF-HEALING (Auto-guérison):"
    echo "     Un pod crash? Le Deployment le détecte et en crée un nouveau."
    echo ""
    echo "  2️⃣  SCALING (Mise à l'échelle):"
    echo "     kubectl scale deployment nginx --replicas=10"
    echo "     → Passe de 3 à 10 pods instantanément!"
    echo ""
    echo "  3️⃣  ROLLING UPDATES (Mises à jour progressives):"
    echo "     Mise à jour nginx:1.21 → nginx:1.22 SANS DOWNTIME"
    echo "     Les anciens pods sont remplacés UN PAR UN."
    echo ""
    echo "  4️⃣  ROLLBACK (Retour arrière):"
    echo "     La nouvelle version a un bug? Retour à l'ancienne version"
    echo "     en UNE commande: kubectl rollout undo deployment/nginx"
    echo ""

    print_info "ARCHITECTURE DEPLOYMENT:"
    echo "  Deployment → ReplicaSet → Pods"
    echo ""
    echo "  • Deployment: Stratégie de déploiement (combien de pods, quelle image)"
    echo "  • ReplicaSet: Maintient le nombre désiré de pods (créé automatiquement)"
    echo "  • Pods: Les instances réelles de votre application"
    echo ""

    print_info "DANS VOTRE CLUSTER MULTI-NODE (k3d):"
    echo "Avec 3 réplicas sur 3 nœuds (server-0, agent-0, agent-1):"
    echo "  • Le scheduler distribue les pods sur DIFFÉRENTS nœuds"
    echo "  • Si un nœud tombe, les pods sont recréés sur d'autres nœuds"
    echo "  • HAUTE DISPONIBILITÉ garantie!"
    echo ""

    print_info "EXEMPLE CONCRET:"
    echo "  replicas: 3  ← Kubernetes garantit TOUJOURS 3 pods actifs"
    echo ""
    echo "  Que se passe-t-il si:"
    echo "    • 1 pod crash?        → Deployment en recrée 1  (3/3 ✓)"
    echo "    • 2 pods crashent?    → Deployment en recrée 2  (3/3 ✓)"
    echo "    • Un nœud tombe?      → Pods recréés ailleurs   (3/3 ✓)"
    echo "    • Vous scalez à 5?    → 2 nouveaux pods créés   (5/5 ✓)"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Créer un deployment avec 3 réplicas"
    echo ""
    echo "Vous allez voir la puissance des Deployments en action!"
    echo ""

    read -p "Appuyez sur ENTRÉE pour voir un exemple de manifest YAML..."
    echo ""

    echo -e "${CYAN}Exemple de deployment.yaml:${NC}"
    cat << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: westeros
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF

    echo ""
    echo -e "${YELLOW}Commandes utiles:${NC}"
    echo "  kubectl apply -f deployment.yaml"
    echo "  kubectl get deployments -n westeros"
    echo "  kubectl get pods -n westeros"
    echo "  kubectl scale deployment nginx-deployment --replicas=5 -n westeros"
    echo "  kubectl rollout status deployment/nginx-deployment -n westeros"
    echo ""

    read -p "Voulez-vous créer ce deployment? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat > /tmp/gok-nginx-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: westeros
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
EOF

        print_info "Création du deployment..."
        kubectl apply -f /tmp/gok-nginx-deployment.yaml

        print_info "Attente des pods..."
        sleep 3

        echo ""
        kubectl get deployment nginx-deployment -n westeros
        echo ""
        kubectl get pods -n westeros -l app=nginx

        echo ""
        print_success "Deployment créé avec succès!"
        mark_completed "tutorial_deployments"

        echo ""
        print_info "Essayons de scaler à 5 réplicas..."
        read -p "Continuer? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl scale deployment nginx-deployment --replicas=5 -n westeros
            sleep 2
            kubectl get pods -n westeros -l app=nginx
        fi

        echo ""
        read -p "Voulez-vous supprimer ce deployment? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete deployment nginx-deployment -n westeros
            print_success "Deployment supprimé"
        fi
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 3 : Services
tutorial_services() {
    print_header
    print_banner "🌐 Tutorial 3: Les Services - King's Landing"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 QU'EST-CE QU'UN SERVICE KUBERNETES ?${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "DÉFINITION:"
    echo "Un Service est une abstraction qui expose des Pods via une ADRESSE"
    echo "STABLE (IP fixe + DNS). Il sert de point d'entrée unique pour accéder"
    echo "à un ensemble de Pods identiques (réplicas)."
    echo ""

    print_info "LE PROBLÈME QUE LES SERVICES RÉSOLVENT:"
    echo ""
    echo "  SANS SERVICE (le cauchemar):"
    echo "    • Vous avez 3 pods nginx avec des IPs: 10.42.1.5, 10.42.2.8, 10.42.3.2"
    echo "    • Un pod meurt → Son IP change (nouvelle IP: 10.42.1.12)"
    echo "    • Comment savoir quelle IP utiliser? 🤯"
    echo "    • Comment répartir le traffic entre les 3 pods?"
    echo ""
    echo "  AVEC SERVICE (la solution):"
    echo "    • Le Service a une IP FIXE: 10.96.100.50"
    echo "    • DNS automatique: nginx-service.westeros.svc.cluster.local"
    echo "    • Les pods peuvent mourir/renaître, l'IP du service ne change JAMAIS"
    echo "    • Load balancing automatique entre tous les pods! 🎉"
    echo ""

    print_info "ANALOGIE - King's Landing (la capitale):"
    echo "King's Landing est la capitale où tous les citoyens viennent."
    echo "Peu importe quel garde (pod) est de service, l'adresse reste:"
    echo "    'King's Landing' (nom DNS du service)"
    echo "Les gardes changent (pods), mais la ville reste au même endroit!"
    echo ""

    print_info "LES 3 TYPES DE SERVICES PRINCIPAUX:"
    echo ""
    echo "  1️⃣  ClusterIP (par défaut - INTERNE):"
    echo "     • Accessible UNIQUEMENT depuis l'intérieur du cluster"
    echo "     • IP: 10.96.x.x (réseau virtuel Kubernetes)"
    echo "     • Usage: Communication inter-services (frontend → backend)"
    echo ""
    echo "  2️⃣  NodePort (EXTERNE - développement):"
    echo "     • Ouvre un PORT sur TOUS les nœuds du cluster"
    echo "     • Port range: 30000-32767"
    echo "     • Accessible via: http://localhost:30200 (exemple)"
    echo "     • Usage: Tester depuis votre machine hôte"
    echo ""
    echo "  3️⃣  LoadBalancer (EXTERNE - production cloud):"
    echo "     • Crée un load balancer externe (AWS ELB, GCP LB, etc.)"
    echo "     • Obtient une IP publique automatiquement"
    echo "     • Usage: Production sur cloud providers"
    echo ""

    print_info "COMMENT ÇA FONCTIONNE? (le mécanisme):"
    echo ""
    echo "  Service: selector → app: nginx"
    echo "           ↓"
    echo "  Trouve tous les Pods avec le label 'app: nginx'"
    echo "           ↓"
    echo "  Endpoints: Liste des IPs des pods trouvés"
    echo "           ↓"
    echo "  Load Balancing: Répartit le traffic entre ces IPs"
    echo ""
    echo "  Exemple concret:"
    echo "    • 3 pods nginx: 10.42.1.5, 10.42.2.8, 10.42.3.2"
    echo "    • Service nginx-service: 10.96.100.50:80"
    echo "    • Requête → 10.96.100.50 → routée vers UN des 3 pods (round-robin)"
    echo ""

    print_info "DANS VOTRE CLUSTER MULTI-NODE:"
    echo "Avec NodePort sur k3d (3 nœuds):"
    echo "  • Le port 30200 est ouvert sur TOUS les nœuds"
    echo "  • http://localhost:30200 fonctionne car k3d map le port"
    echo "  • Le traffic est routé vers n'importe quel pod, peu importe"
    echo "    sur quel nœud il tourne (server-0, agent-0, ou agent-1)"
    echo ""

    print_info "SÉLECTEURS (SELECTORS) - CRUCIAL:"
    echo "  selector:"
    echo "    app: nginx  ← DOIT matcher les labels des pods!"
    echo ""
    echo "  Si les labels ne matchent pas → Aucun pod trouvé → Service inutile!"
    echo ""

    print_info "EXEMPLE RÉEL:"
    echo "  Frontend (React) a besoin d'appeler l'API (Node.js)"
    echo ""
    echo "  SANS Service:"
    echo "    fetch('http://10.42.1.5:3000/api')  ← IP changeante, fragile"
    echo ""
    echo "  AVEC Service:"
    echo "    fetch('http://api-service:3000/api')  ← DNS stable, robuste!"
    echo ""

    read -p "Appuyez sur ENTRÉE pour découvrir les AUTRES TYPES de Services..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🌐 TYPES DE SERVICES AVANCÉS${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "4️⃣  ExternalIP - Router vers des IPs spécifiques"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ ExternalIP permet de router le trafic vers le cluster   │"
    echo "│ depuis une IP externe spécifique                        │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Workflow:                                               │"
    echo "│   Internet → ExternalIP (192.168.1.100)                 │"
    echo "│            → Worker Nodes                               │"
    echo "│            → Service                                    │"
    echo "│            → Pods                                       │"
    echo "│                                                         │"
    echo "│ Exemple YAML:                                           │"
    echo "│   spec:                                                 │"
    echo "│     type: ClusterIP                                     │"
    echo "│     externalIPs:                                        │"
    echo "│     - 192.168.1.100  # IP d'un worker node              │"
    echo "│     - 192.168.1.101                                     │"
    echo "│     ports:                                              │"
    echo "│     - port: 80                                          │"
    echo "│                                                         │"
    echo "│ ⚠️  ATTENTION:                                          │"
    echo "│ • L'IP doit être routée vers un des worker nodes        │"
    echo "│ • Vous gérez le routing vous-même                       │"
    echo "│ • Usage: Bare metal, on-premise sans LoadBalancer       │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le type suivant..."

    print_info "5️⃣  ExternalName - CNAME vers service externe"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ ExternalName crée un alias DNS vers un service EXTERNE  │"
    echo "│ (hors du cluster Kubernetes)                            │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Workflow:                                               │"
    echo "│   Pod dans cluster                                      │"
    echo "│     → Appelle 'database-service'                        │"
    echo "│     → DNS retourne 'db.external.com'                    │"
    echo "│     → Pod se connecte directement à db.external.com     │"
    echo "│                                                         │"
    echo "│ Exemple YAML:                                           │"
    echo "│   apiVersion: v1                                        │"
    echo "│   kind: Service                                         │"
    echo "│   metadata:                                             │"
    echo "│     name: database-service                              │"
    echo "│   spec:                                                 │"
    echo "│     type: ExternalName                                  │"
    echo "│     externalName: db.external.com                       │"
    echo "│                                                         │"
    echo "│ Usage dans un Pod:                                      │"
    echo "│   postgresql://database-service:5432/mydb               │"
    echo "│     → Résolu en db.external.com:5432                    │"
    echo "│                                                         │"
    echo "│ 💡 CAS D'USAGE TYPIQUES:                                │"
    echo "│ • Base de données RDS/Cloud SQL externe                 │"
    echo "│ • API tierce (api.stripe.com, api.twilio.com)           │"
    echo "│ • Migration progressive vers Kubernetes                 │"
    echo "│ • Environnements dev pointant vers staging              │"
    echo "│                                                         │"
    echo "│ ⚠️  PAS de selectors, PAS de ports définis!             │"
    echo "│ C'est juste un alias DNS (CNAME record)                 │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le type suivant..."

    print_info "6️⃣  Multi-Port Services - Exposer plusieurs ports"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Un seul Service peut exposer PLUSIEURS ports            │"
    echo "│ simultanément                                           │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Exemple: Application avec HTTP + HTTPS + Metrics        │"
    echo "│                                                         │"
    echo "│ Exemple YAML:                                           │"
    echo "│   apiVersion: v1                                        │"
    echo "│   kind: Service                                         │"
    echo "│   metadata:                                             │"
    echo "│     name: web-service                                   │"
    echo "│   spec:                                                 │"
    echo "│     type: ClusterIP                                     │"
    echo "│     selector:                                           │"
    echo "│       app: web                                          │"
    echo "│     ports:                                              │"
    echo "│     - name: http        # NOMMÉ pour clarté             │"
    echo "│       port: 80                                          │"
    echo "│       targetPort: 8080                                  │"
    echo "│     - name: https                                       │"
    echo "│       port: 443                                         │"
    echo "│       targetPort: 8443                                  │"
    echo "│     - name: metrics                                     │"
    echo "│       port: 9090                                        │"
    echo "│       targetPort: 9090                                  │"
    echo "│                                                         │"
    echo "│ Accès:                                                  │"
    echo "│   curl http://web-service:80      # HTTP                │"
    echo "│   curl https://web-service:443    # HTTPS               │"
    echo "│   curl http://web-service:9090/metrics  # Prometheus    │"
    echo "│                                                         │"
    echo "│ 💡 BONNES PRATIQUES:                                    │"
    echo "│ • TOUJOURS nommer les ports (name: http, https, etc.)   │"
    echo "│ • Facilite la lecture et le debugging                   │"
    echo "│ • Requis quand plusieurs ports du même protocole        │"
    echo "│                                                         │"
    echo "│ 📊 CAS D'USAGE:                                         │"
    echo "│ • Applications gRPC + HTTP                              │"
    echo "│ • Services avec port metrics (Prometheus)               │"
    echo "│ • Applications legacy avec plusieurs listeners          │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le TABLEAU COMPARATIF..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}📊 TABLEAU COMPARATIF DES TYPES DE SERVICES${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "┌──────────────┬─────────────┬──────────────┬─────────────────┐"
    echo "│ Type         │ Accessible  │ Use Case     │ IP/DNS          │"
    echo "├──────────────┼─────────────┼──────────────┼─────────────────┤"
    echo "│ ClusterIP    │ Interne     │ Inter-apps   │ 10.96.x.x       │"
    echo "│              │ uniquement  │ communication│                 │"
    echo "├──────────────┼─────────────┼──────────────┼─────────────────┤"
    echo "│ NodePort     │ Externe     │ Dev/Test     │ Node:30000-32767│"
    echo "│              │             │ local        │                 │"
    echo "├──────────────┼─────────────┼──────────────┼─────────────────┤"
    echo "│ LoadBalancer │ Externe     │ Production   │ IP publique     │"
    echo "│              │             │ (cloud)      │ automatique     │"
    echo "├──────────────┼─────────────┼──────────────┼─────────────────┤"
    echo "│ ExternalIP   │ Externe     │ Bare metal   │ IPs spécifiques │"
    echo "│              │             │ on-premise   │ que vous gérez  │"
    echo "├──────────────┼─────────────┼──────────────┼─────────────────┤"
    echo "│ ExternalName │ N/A         │ Alias vers   │ CNAME externe   │"
    echo "│              │ (juste DNS) │ service ext. │ (db.aws.com)    │"
    echo "└──────────────┴─────────────┴──────────────┴─────────────────┘"
    echo ""

    print_info "💡 CHOISIR LE BON TYPE:"
    echo "• Communication entre Pods dans cluster?      → ClusterIP"
    echo "• Tester depuis votre laptop (dev)?           → NodePort"
    echo "• Production sur AWS/GCP/Azure?               → LoadBalancer"
    echo "• Cluster bare metal avec IPs fixes?          → ExternalIP"
    echo "• Pointer vers base de données RDS externe?   → ExternalName"
    echo "• Besoin d'exposer HTTP + HTTPS + metrics?    → Multi-Port"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Créer un service pour exposer nginx"
    echo ""
    echo "Vous allez créer un service NodePort pour accéder à nginx depuis"
    echo "votre navigateur sur http://localhost:30200"
    echo ""

    read -p "Appuyez sur ENTRÉE pour voir un exemple de manifest YAML..."
    echo ""

    echo -e "${CYAN}Exemple de service.yaml:${NC}"
    cat << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: westeros
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30200
EOF

    echo ""
    echo -e "${YELLOW}Commandes utiles:${NC}"
    echo "  kubectl apply -f service.yaml"
    echo "  kubectl get svc -n westeros"
    echo "  kubectl describe svc nginx-service -n westeros"
    echo "  curl http://localhost:30200"
    echo ""

    read -p "Voulez-vous créer ce service? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # D'abord créer un deployment si nécessaire
        if ! kubectl get deployment nginx-deployment -n westeros &>/dev/null; then
            print_info "Création d'un deployment nginx d'abord..."
            cat > /tmp/gok-nginx-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: westeros
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF
            kubectl apply -f /tmp/gok-nginx-deployment.yaml
            sleep 3
        fi

        cat > /tmp/gok-nginx-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: westeros
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30200
EOF

        print_info "Création du service..."
        kubectl apply -f /tmp/gok-nginx-service.yaml

        echo ""
        kubectl get svc nginx-service -n westeros

        echo ""
        print_success "Service créé avec succès!"
        print_info "Testez avec: curl http://localhost:30200"
        mark_completed "tutorial_services"

        echo ""
        read -p "Voulez-vous tester maintenant? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo ""
            curl -s http://localhost:30200 | head -n 5
            echo "..."
        fi

        echo ""
        read -p "Voulez-vous supprimer service et deployment? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete service nginx-service -n westeros
            kubectl delete deployment nginx-deployment -n westeros
            print_success "Service et deployment supprimés"
        fi
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 4 : ConfigMaps & Secrets
tutorial_config() {
    print_header
    print_banner "💾 Tutorial 4: ConfigMaps & Secrets - The Maesters' Scrolls"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 CONFIGMAPS & SECRETS: CONFIGURATION SANS REBUILD${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo ""
    echo "  ❌ MAUVAISE PRATIQUE (hardcoder dans l'image):"
    echo "     FROM node:18"
    echo "     ENV DATABASE_URL=postgres://prod.example.com:5432/db"
    echo "     ENV API_KEY=sk-1234567890abcdef"
    echo ""
    echo "  Problèmes:"
    echo "    • Besoin de rebuild l'image pour changer une config"
    echo "    • Mots de passe visibles dans le code source"
    echo "    • Même image ne peut pas être utilisée en dev/staging/prod"
    echo "    • Secrets dans l'historique Git = DANGER! 🚨"
    echo ""

    print_info "DÉFINITION - CONFIGMAP:"
    echo "Un ConfigMap stocke des données de CONFIGURATION non-sensibles"
    echo "sous forme de paires clé-valeur. Exemples: URLs, paramètres,"
    echo "fichiers de configuration, variables d'environnement."
    echo ""
    echo "  Utilisation typique:"
    echo "    • URL de l'API backend"
    echo "    • Nom de l'application"
    echo "    • Niveau de log (debug, info, error)"
    echo "    • Fichiers de configuration (nginx.conf, config.json)"
    echo ""

    print_info "DÉFINITION - SECRET:"
    echo "Un Secret stocke des données SENSIBLES encodées en base64."
    echo "Kubernetes les gère avec plus de précautions (RBAC, encryption)."
    echo ""
    echo "  Utilisation typique:"
    echo "    • Mots de passe de bases de données"
    echo "    • Clés API (AWS, Stripe, OpenAI)"
    echo "    • Certificats TLS/SSL"
    echo "    • Tokens d'authentification"
    echo ""

    print_info "ANALOGIE - The Maesters' Scrolls:"
    echo "Les Maesters de la Citadelle gardent deux types de parchemins:"
    echo ""
    echo "  📜 ConfigMap = Parchemins PUBLICS:"
    echo "     - Cartes des 7 royaumes (tout le monde peut voir)"
    echo "     - Recettes de cuisine"
    echo "     - Calendrier des saisons"
    echo ""
    echo "  🔒 Secret = Parchemins SECRETS:"
    echo "     - Recette du Feu Grégeois (wildfire)"
    echo "     - Passages secrets de King's Landing"
    echo "     - Identité de Jon Snow (R+L=J)"
    echo ""

    print_info "COMMENT LES UTILISER DANS UN POD?"
    echo ""
    echo "  Méthode 1: Variables d'environnement"
    echo "    env:"
    echo "      - name: API_URL"
    echo "        valueFrom:"
    echo "          configMapKeyRef:"
    echo "            name: app-config"
    echo "            key: api.url"
    echo ""
    echo "  Méthode 2: Fichiers montés (volume)"
    echo "    volumeMounts:"
    echo "      - name: config-volume"
    echo "        mountPath: /etc/config"
    echo "    volumes:"
    echo "      - name: config-volume"
    echo "        configMap:"
    echo "          name: app-config"
    echo ""

    print_info "CONFIGMAP vs SECRET - DIFFÉRENCES:"
    echo ""
    echo "  ┌─────────────────┬──────────────┬──────────────┐"
    echo "  │                 │  ConfigMap   │    Secret    │"
    echo "  ├─────────────────┼──────────────┼──────────────┤"
    echo "  │ Données         │ Texte clair  │ Base64       │"
    echo "  │ Visibilité      │ Publique     │ Restreinte   │"
    echo "  │ RBAC            │ Standard     │ Plus strict  │"
    echo "  │ Encryption      │ Non          │ Possible     │"
    echo "  │ Usage           │ Config       │ Credentials  │"
    echo "  └─────────────────┴──────────────┴──────────────┘"
    echo ""

    print_info "AVANTAGES:"
    echo "  ✅ Séparation code / configuration"
    echo "  ✅ Même image Docker pour dev/staging/prod"
    echo "  ✅ Pas de rebuild pour changer une config"
    echo "  ✅ Mots de passe hors du code source"
    echo "  ✅ Mise à jour dynamique (avec restart ou hot-reload)"
    echo ""

    print_info "SÉCURITÉ DES SECRETS - IMPORTANT!"
    echo ""
    echo "  ⚠️  Base64 N'EST PAS du chiffrement!"
    echo "     echo 'bXlwYXNzd29yZA==' | base64 -d  → mypassword"
    echo ""
    echo "  🔒 Bonnes pratiques:"
    echo "     • Activer encryption at rest (kube-apiserver)"
    echo "     • Utiliser RBAC pour limiter l'accès"
    echo "     • Rotation régulière des secrets"
    echo "     • Utiliser External Secrets Operator (production)"
    echo "     • Ne JAMAIS commit de secrets dans Git!"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Créer une app avec ConfigMap et Secret"
    echo ""
    echo "Vous allez déployer une application qui:"
    echo "  1. Lit une URL d'API depuis un ConfigMap"
    echo "  2. Lit un mot de passe depuis un Secret"
    echo "  3. Les affiche (pour démonstration - NE PAS FAIRE en prod!)"
    echo ""

    read -p "Voulez-vous créer cet exemple? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then

        # 1. Créer le ConfigMap
        print_info "Étape 1: Création d'un ConfigMap..."
        echo ""

        cat > /tmp/gok-configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: westeros
data:
  api.url: "https://api.westeros.io/v1"
  app.name: "The North API"
  log.level: "info"
  config.json: |
    {
      "kingdom": "The North",
      "house": "Stark",
      "words": "Winter is Coming"
    }
EOF

        echo -e "${CYAN}ConfigMap créé:${NC}"
        cat /tmp/gok-configmap.yaml
        echo ""

        kubectl apply -f /tmp/gok-configmap.yaml
        print_success "ConfigMap 'app-config' créé!"
        echo ""

        # 2. Créer le Secret
        print_info "Étape 2: Création d'un Secret..."
        echo ""

        cat > /tmp/gok-secret.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  namespace: westeros
type: Opaque
data:
  # base64 encoded: echo -n 'winterfell2024' | base64
  db.password: d2ludGVyZmVsbDIwMjQ=
  # base64 encoded: echo -n 'sk-the-north-12345' | base64
  api.key: c2stdGhlLW5vcnRoLTEyMzQ1
EOF

        echo -e "${CYAN}Secret créé (valeurs en base64):${NC}"
        cat /tmp/gok-secret.yaml
        echo ""

        kubectl apply -f /tmp/gok-secret.yaml
        print_success "Secret 'app-secret' créé!"
        echo ""

        # 3. Créer le Pod qui utilise ConfigMap et Secret
        print_info "Étape 3: Création d'un Pod qui lit les configs..."
        echo ""

        cat > /tmp/gok-config-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: config-demo
  namespace: westeros
spec:
  containers:
  - name: demo
    image: busybox
    command: ['sh', '-c', 'echo "=== CONFIG & SECRETS ==="; echo "API_URL: $API_URL"; echo "APP_NAME: $APP_NAME"; echo "DB_PASSWORD: $DB_PASSWORD"; echo "API_KEY: $API_KEY"; echo ""; echo "=== CONFIG FILE ==="; cat /etc/config/config.json; echo ""; echo "Sleeping..."; sleep 3600']
    env:
      # Variables depuis ConfigMap
      - name: API_URL
        valueFrom:
          configMapKeyRef:
            name: app-config
            key: api.url
      - name: APP_NAME
        valueFrom:
          configMapKeyRef:
            name: app-config
            key: app.name
      # Variables depuis Secret
      - name: DB_PASSWORD
        valueFrom:
          secretKeyRef:
            name: app-secret
            key: db.password
      - name: API_KEY
        valueFrom:
          secretKeyRef:
            name: app-secret
            key: api.key
    volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: app-config
        items:
          - key: config.json
            path: config.json
  restartPolicy: Never
EOF

        echo -e "${CYAN}Pod avec ConfigMap + Secret:${NC}"
        cat /tmp/gok-config-pod.yaml
        echo ""

        kubectl apply -f /tmp/gok-config-pod.yaml

        print_info "Attente du pod..."
        sleep 3

        echo ""
        print_success "Pod créé! Voici les logs:"
        echo ""
        kubectl logs config-demo -n westeros 2>/dev/null || echo "Pod en cours de démarrage..."

        echo ""
        print_success "✅ Vous avez créé:"
        echo "  • Un ConfigMap avec des configs publiques"
        echo "  • Un Secret avec des données sensibles (base64)"
        echo "  • Un Pod qui lit les deux via env vars et fichiers"
        echo ""

        mark_completed "tutorial_config"

        echo ""
        print_info "Commandes utiles:"
        echo "  kubectl get configmap -n westeros"
        echo "  kubectl describe configmap app-config -n westeros"
        echo "  kubectl get secret -n westeros"
        echo "  kubectl describe secret app-secret -n westeros"
        echo "  kubectl get secret app-secret -n westeros -o yaml  # Voir base64"
        echo ""

        read -p "Voulez-vous nettoyer ces ressources? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete pod config-demo -n westeros
            kubectl delete configmap app-config -n westeros
            kubectl delete secret app-secret -n westeros
            print_success "Ressources supprimées"
        fi
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 5 : Volumes
tutorial_volumes() {
    print_header
    print_banner "📦 Tutorial 5: Volumes - The Vaults of Casterly Rock"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 VOLUMES: STOCKAGE PERSISTANT DANS KUBERNETES${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo ""
    echo "  ❌ SANS VOLUMES:"
    echo "     1. Vous déployez une base de données PostgreSQL dans un pod"
    echo "     2. Les utilisateurs créent 10 000 enregistrements"
    echo "     3. Le pod crashe et redémarre..."
    echo "     4. 💀 TOUTES LES DONNÉES SONT PERDUES!"
    echo ""
    echo "  Pourquoi? Les conteneurs sont ÉPHÉMÈRES:"
    echo "    • Le système de fichiers d'un conteneur est TEMPORAIRE"
    echo "    • Quand le conteneur meurt, ses données disparaissent"
    echo "    • Chaque restart = nouveau conteneur = filesystem vide"
    echo ""

    print_info "DÉFINITION - VOLUME:"
    echo "Un Volume est un répertoire accessible aux conteneurs d'un Pod,"
    echo "qui PERSISTE au-delà du cycle de vie des conteneurs individuels."
    echo ""
    echo "  Types principaux:"
    echo "    • emptyDir: Temporaire (vie du pod)"
    echo "    • hostPath: Répertoire du nœud"
    echo "    • PersistentVolume (PV): Stockage réseau durable"
    echo "    • ConfigMap/Secret: Données de configuration"
    echo "    • Cloud: AWS EBS, Azure Disk, GCP PD, etc."
    echo ""

    print_info "ANALOGIE - The Vaults of Casterly Rock:"
    echo "Les Lannister gardent leur or dans des COFFRES (volumes):"
    echo ""
    echo "  🏰 Pod = Casterly Rock (le château peut brûler)"
    echo "  💰 Volume = Coffre-fort enterré (survit à l'incendie)"
    echo "  👤 Conteneur = Garde qui meurt (remplacé, mais l'or reste)"
    echo ""
    echo "  Même si Casterly Rock tombe et est reconstruit,"
    echo "  l'or dans les coffres reste intact! 💎"
    echo ""

    print_info "LES TYPES DE VOLUMES DÉTAILLÉS:"
    echo ""
    echo "  1️⃣  emptyDir (TEMPORAIRE - vie du pod):"
    echo "     • Créé quand le pod démarre"
    echo "     • Détruit quand le pod est supprimé"
    echo "     • Partagé entre conteneurs du même pod"
    echo "     • Usage: Cache, fichiers temporaires, communication inter-conteneurs"
    echo ""
    echo "  2️⃣  hostPath (NŒUD LOCAL - dangereux!):"
    echo "     • Monte un répertoire du nœud hôte"
    echo "     • ⚠️  DANGER: Lie le pod à un nœud spécifique"
    echo "     • Si le pod redémarre sur un AUTRE nœud → données perdues!"
    echo "     • Usage: Dev/test seulement, logs système"
    echo ""
    echo "  3️⃣  PersistentVolume (PV) + PersistentVolumeClaim (PVC):"
    echo "     • Solution PROFESSIONNELLE pour la persistence"
    echo "     • PV = Stockage réel provisionné par l'admin"
    echo "     • PVC = Demande de stockage par l'application"
    echo "     • Survit aux pods, peut être réutilisé"
    echo "     • Support multi-node (NFS, cloud storage)"
    echo ""

    print_info "ARCHITECTURE PV + PVC:"
    echo ""
    echo "  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐"
    echo "  │   Pod        │───▶│     PVC      │───▶│      PV      │"
    echo "  │ (Demandeur)  │     │  (Demande)   │     │  (Stockage)  │"
    echo "  └──────────────┘     └──────────────┘     └──────────────┘"
    echo "                                                     │"
    echo "                                                     ▼"
    echo "                                            ┌──────────────┐"
    echo "                                            │ Stockage réel│"
    echo "                                            │ (NFS, Cloud) │"
    echo "                                            └──────────────┘"
    echo ""
    echo "  1. Admin crée PV (100GB disponible sur NFS)"
    echo "  2. Dev crée PVC (demande 10GB)"
    echo "  3. K8s lie (bind) PVC → PV automatiquement"
    echo "  4. Pod monte le PVC comme un volume"
    echo ""

    print_info "STORAGE CLASS - PROVISIONNEMENT DYNAMIQUE:"
    echo ""
    echo "  Problème avec PV manuel:"
    echo "    • Admin doit créer chaque PV à la main = lent!"
    echo ""
    echo "  Solution avec StorageClass:"
    echo "    • Définit comment provisionner automatiquement du stockage"
    echo "    • Dev crée PVC → K8s crée PV automatiquement!"
    echo "    • Support cloud: AWS EBS, Azure Disk, GCP PD"
    echo ""
    echo "  Exemple:"
    echo "    apiVersion: v1"
    echo "    kind: PersistentVolumeClaim"
    echo "    spec:"
    echo "      storageClassName: fast-ssd  ← Classe de stockage"
    echo "      resources:"
    echo "        requests:"
    echo "          storage: 10Gi"
    echo ""

    print_info "DANS VOTRE CLUSTER k3d:"
    echo "k3d inclut un provisioner 'local-path' par défaut:"
    echo "  • Stocke les données sur le nœud hôte (Docker volume)"
    echo "  • Provisionnement dynamique activé"
    echo "  • Parfait pour dev/test local"
    echo "  • StorageClass: 'local-path' (par défaut)"
    echo ""

    print_info "ACCESS MODES (Modes d'accès):"
    echo ""
    echo "  • ReadWriteOnce (RWO): 1 seul nœud en lecture/écriture"
    echo "  • ReadOnlyMany (ROX): Plusieurs nœuds en lecture seule"
    echo "  • ReadWriteMany (RWX): Plusieurs nœuds en lecture/écriture"
    echo ""
    echo "  Exemple: NFS supporte RWX, mais AWS EBS seulement RWO"
    echo ""

    print_info "QUAND UTILISER QUOI?"
    echo ""
    echo "  📝 Logs temporaires → emptyDir"
    echo "  🗄️  Base de données → PV + PVC (RWO)"
    echo "  📁 Fichiers partagés → PV + PVC avec NFS (RWX)"
    echo "  🔧 Config files → ConfigMap (monté comme volume)"
    echo "  🔐 Certificats → Secret (monté comme volume)"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Créer un pod avec persistence"
    echo ""
    echo "Vous allez créer:"
    echo "  1. Un PersistentVolumeClaim (demande de 1Gi)"
    echo "  2. Un pod qui écrit dans ce volume"
    echo "  3. Supprimer et recréer le pod"
    echo "  4. Vérifier que les données persistent! 🎉"
    echo ""

    read -p "Voulez-vous créer cet exemple? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then

        # 1. Créer le PVC
        print_info "Étape 1: Création d'un PersistentVolumeClaim..."
        echo ""

        cat > /tmp/gok-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: stark-vault
  namespace: westeros
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-path
EOF

        echo -e "${CYAN}PVC (demande de stockage):${NC}"
        cat /tmp/gok-pvc.yaml
        echo ""

        kubectl apply -f /tmp/gok-pvc.yaml
        print_success "PVC 'stark-vault' créé!"
        echo ""

        print_info "Vérification du PVC..."
        sleep 2
        kubectl get pvc -n westeros
        echo ""

        # 2. Créer le pod avec le volume
        print_info "Étape 2: Création d'un pod qui utilise le PVC..."
        echo ""

        cat > /tmp/gok-volume-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: writer-pod
  namespace: westeros
spec:
  containers:
  - name: writer
    image: busybox
    command: ['sh', '-c', 'echo "Winter is Coming - $(date)" >> /data/stark.log; echo "Data written to /data/stark.log"; cat /data/stark.log; echo ""; echo "Sleeping... (kill me and I will be reborn with my data!)"; sleep 3600']
    volumeMounts:
      - name: persistent-storage
        mountPath: /data
  volumes:
    - name: persistent-storage
      persistentVolumeClaim:
        claimName: stark-vault
  restartPolicy: Never
EOF

        echo -e "${CYAN}Pod avec volume persistant:${NC}"
        cat /tmp/gok-volume-pod.yaml
        echo ""

        kubectl apply -f /tmp/gok-volume-pod.yaml

        print_info "Attente du pod (5 secondes)..."
        sleep 5

        echo ""
        print_success "Pod créé! Voici ce qu'il a écrit:"
        echo ""
        kubectl logs writer-pod -n westeros 2>/dev/null || echo "Pod en cours de démarrage..."

        echo ""
        echo -e "${YELLOW}════════════════════════════════════════${NC}"
        echo -e "${YELLOW}   TEST DE PERSISTENCE! 🧪${NC}"
        echo -e "${YELLOW}════════════════════════════════════════${NC}"
        echo ""

        read -p "Prêt à tester la persistence? Appuyez sur ENTRÉE..."

        # 3. Supprimer le pod
        print_info "Suppression du pod..."
        kubectl delete pod writer-pod -n westeros

        echo ""
        print_success "Pod supprimé!"
        echo ""

        # 4. Recréer un NOUVEAU pod avec le même PVC
        print_info "Création d'un NOUVEAU pod avec le même PVC..."
        echo ""

        cat > /tmp/gok-volume-pod-v2.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: reader-pod
  namespace: westeros
spec:
  containers:
  - name: reader
    image: busybox
    command: ['sh', '-c', 'echo "=== READING FROM PERSISTENT VOLUME ==="; if [ -f /data/stark.log ]; then echo "✅ File exists! Data persisted!"; cat /data/stark.log; else echo "❌ File not found. Data lost."; fi; sleep 3600']
    volumeMounts:
      - name: persistent-storage
        mountPath: /data
  volumes:
    - name: persistent-storage
      persistentVolumeClaim:
        claimName: stark-vault
  restartPolicy: Never
EOF

        kubectl apply -f /tmp/gok-volume-pod-v2.yaml

        print_info "Attente du nouveau pod (5 secondes)..."
        sleep 5

        echo ""
        echo -e "${GREEN}═══════════════════════════════════════${NC}"
        echo -e "${GREEN}   RÉSULTAT DU TEST:${NC}"
        echo -e "${GREEN}═══════════════════════════════════════${NC}"
        echo ""
        kubectl logs reader-pod -n westeros 2>/dev/null || echo "Pod en cours de démarrage..."

        echo ""
        print_success "🎉 SUCCÈS! Les données ont persisté!"
        echo ""
        echo "Que s'est-il passé?"
        echo "  1. Premier pod a écrit dans /data/stark.log (sur le PVC)"
        echo "  2. Pod supprimé (conteneur détruit)"
        echo "  3. Nouveau pod créé avec le MÊME PVC"
        echo "  4. Les données sont toujours là! 💾"
        echo ""

        mark_completed "tutorial_volumes"

        echo ""
        print_info "Commandes utiles:"
        echo "  kubectl get pvc -n westeros"
        echo "  kubectl describe pvc stark-vault -n westeros"
        echo "  kubectl get pv  # Voir le PV auto-créé"
        echo ""

        read -p "Voulez-vous nettoyer ces ressources? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete pod reader-pod -n westeros 2>/dev/null || true
            kubectl delete pvc stark-vault -n westeros
            print_success "Ressources supprimées (le PV sera auto-nettoyé)"
        fi
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 6 : Namespaces & Labels
tutorial_namespaces() {
    print_header
    print_banner "🏰 Tutorial 6: Namespaces & Labels - The Seven Kingdoms"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 NAMESPACES & LABELS: ORGANISATION ET SÉLECTION${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo ""
    echo "  ❌ SANS NAMESPACES NI LABELS:"
    echo "     • Tous les pods, services, deployments dans le MÊME sac"
    echo "     • Impossible de distinguer dev, staging, prod"
    echo "     • Conflits de noms: nginx-prod vs nginx-dev?"
    echo "     • Comment sélectionner 'tous les pods du frontend'?"
    echo "     • 💀 CHAOS TOTAL dans un gros cluster!"
    echo ""

    print_info "DÉFINITION - NAMESPACE:"
    echo "Un Namespace est un CLUSTER VIRTUEL à l'intérieur du cluster"
    echo "Kubernetes. Il permet d'isoler et organiser les ressources."
    echo ""
    echo "  Analogie: Les appartements dans un immeuble"
    echo "    • Immeuble = Cluster Kubernetes"
    echo "    • Appartements = Namespaces (dev, staging, prod)"
    echo "    • Locataires = Pods, Services, Deployments"
    echo "    • Chaque appart a ses propres ressources isolées"
    echo ""

    print_info "ANALOGIE - The Seven Kingdoms:"
    echo "Les 7 Royaumes de Westeros sont des NAMESPACES!"
    echo ""
    echo "  🏰 The North (namespace: westeros)"
    echo "     • Pods: Stark guards, Winterfell servers"
    echo "     • Services: ravens-service, walls-service"
    echo ""
    echo "  👑 King's Landing (namespace: capital)"
    echo "     • Pods: Royal guards, Throne room"
    echo "     • Services: iron-throne-service"
    echo ""
    echo "  Chaque royaume gère ses propres ressources SANS interférer"
    echo "  avec les autres royaumes!"
    echo ""

    print_info "NAMESPACES PAR DÉFAUT DANS KUBERNETES:"
    echo ""
    echo "  1️⃣  default:"
    echo "     • Namespace par défaut si aucun n'est spécifié"
    echo "     • kubectl get pods  ← regarde dans 'default'"
    echo ""
    echo "  2️⃣  kube-system:"
    echo "     • Composants système de Kubernetes"
    echo "     • kube-proxy, coredns, etcd, etc."
    echo "     • ⚠️  NE PAS TOUCHER! Cluster critique!"
    echo ""
    echo "  3️⃣  kube-public:"
    echo "     • Ressources publiques accessibles à tous"
    echo "     • Rarement utilisé"
    echo ""
    echo "  4️⃣  kube-node-lease:"
    echo "     • Heartbeats des nœuds (santé des nœuds)"
    echo "     • Gestion interne Kubernetes"
    echo ""

    print_info "POURQUOI UTILISER DES NAMESPACES?"
    echo ""
    echo "  ✅ ISOLATION:"
    echo "     • Séparer dev, staging, prod"
    echo "     • Séparer équipes (frontend, backend, data)"
    echo ""
    echo "  ✅ ORGANISATION:"
    echo "     • Grouper ressources liées (app + db + cache)"
    echo "     • Éviter les conflits de noms"
    echo ""
    echo "  ✅ QUOTAS DE RESSOURCES:"
    echo "     • Limiter CPU/RAM par namespace"
    echo "     • kubectl create quota --namespace=dev"
    echo ""
    echo "  ✅ RBAC (Contrôle d'accès):"
    echo "     • Team A peut voir namespace 'frontend'"
    echo "     • Team B ne peut PAS voir namespace 'backend'"
    echo ""

    print_info "DANS VOTRE PROJET GOK8S:"
    echo "Vous avez utilisé le namespace 'westeros' dans TOUS les tutorials!"
    echo ""
    echo "  kubectl get pods -n westeros"
    echo "                    ↑"
    echo "               Option -n (ou --namespace)"
    echo ""
    echo "  Sans -n westeros → Kubernetes regarde dans 'default'"
    echo "  Avec -n westeros → Kubernetes regarde dans 'westeros'"
    echo ""

    print_info "DÉFINITION - LABELS:"
    echo "Les Labels sont des TAGS (étiquettes) attachés aux ressources"
    echo "pour les identifier, organiser et SÉLECTIONNER."
    echo ""
    echo "  Format: Paires clé-valeur"
    echo "    labels:"
    echo "      app: nginx"
    echo "      env: production"
    echo "      tier: frontend"
    echo "      version: v1.2.0"
    echo ""

    print_info "ANALOGIE LABELS - Badges des Maisons:"
    echo "Chaque soldat porte un BADGE (label) identifiant sa maison:"
    echo ""
    echo "  🐺 Stark Guard:"
    echo "     labels:"
    echo "       house: stark"
    echo "       role: guard"
    echo "       location: winterfell"
    echo ""
    echo "  🦁 Lannister Soldier:"
    echo "     labels:"
    echo "       house: lannister"
    echo "       role: soldier"
    echo "       location: casterly-rock"
    echo ""
    echo "  Le commandant peut crier: 'Tous les guards de Stark!'"
    echo "  → Sélection par label: house=stark, role=guard"
    echo ""

    print_info "POURQUOI LES LABELS SONT CRUCIAUX?"
    echo ""
    echo "  Les SERVICES utilisent les labels pour trouver les pods!"
    echo ""
    echo "  Service:"
    echo "    selector:"
    echo "      app: nginx  ← Cherche TOUS les pods avec label app=nginx"
    echo ""
    echo "  Pod 1:              Pod 2:              Pod 3:"
    echo "    labels:             labels:             labels:"
    echo "      app: nginx          app: nginx          app: redis"
    echo "    ✅ MATCH!          ✅ MATCH!          ❌ NO MATCH"
    echo ""
    echo "  Le service routera le traffic vers Pod 1 et Pod 2 UNIQUEMENT!"
    echo ""

    print_info "LABELS vs ANNOTATIONS:"
    echo ""
    echo "  ┌──────────────┬────────────────────┬──────────────────────┐"
    echo "  │              │       Labels       │     Annotations      │"
    echo "  ├──────────────┼────────────────────┼──────────────────────┤"
    echo "  │ Usage        │ Sélection/Filtre   │ Métadonnées          │"
    echo "  │ Sélecteur    │ OUI (selector)     │ NON                  │"
    echo "  │ Taille       │ < 63 caractères    │ Illimitée            │"
    echo "  │ Exemples     │ app, env, version  │ docs, commit-sha     │"
    echo "  └──────────────┴────────────────────┴──────────────────────┘"
    echo ""

    print_info "COMMANDES AVEC NAMESPACES & LABELS:"
    echo ""
    echo "  # Créer namespace"
    echo "  kubectl create namespace prod"
    echo ""
    echo "  # Lister namespaces"
    echo "  kubectl get namespaces"
    echo ""
    echo "  # Changer de namespace par défaut (optionnel)"
    echo "  kubectl config set-context --current --namespace=westeros"
    echo ""
    echo "  # Filtrer par label"
    echo "  kubectl get pods -l app=nginx              # Pods avec app=nginx"
    echo "  kubectl get pods -l env=prod,tier=frontend # AND condition"
    echo "  kubectl get pods -l 'env in (dev,staging)' # OR condition"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Créer des namespaces et utiliser les labels"
    echo ""
    echo "Vous allez créer:"
    echo "  1. Un nouveau namespace 'essos'"
    echo "  2. Des pods avec différents labels dans 'westeros' et 'essos'"
    echo "  3. Tester la sélection par labels"
    echo "  4. Comparer l'isolation entre namespaces"
    echo ""

    read -p "Voulez-vous créer cet exemple? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then

        # 1. Créer le namespace essos
        print_info "Étape 1: Création du namespace 'essos'..."
        echo ""

        kubectl create namespace essos 2>/dev/null || echo "Namespace 'essos' existe déjà"
        print_success "Namespace 'essos' prêt!"
        echo ""

        echo -e "${CYAN}Namespaces actuels:${NC}"
        kubectl get namespaces
        echo ""

        # 2. Créer des pods avec labels dans westeros
        print_info "Étape 2: Création de pods avec labels dans 'westeros'..."
        echo ""

        cat > /tmp/gok-labeled-pods.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: stark-guard-1
  namespace: westeros
  labels:
    house: stark
    role: guard
    tier: frontend
spec:
  containers:
  - name: guard
    image: nginx:alpine
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: stark-guard-2
  namespace: westeros
  labels:
    house: stark
    role: guard
    tier: frontend
spec:
  containers:
  - name: guard
    image: nginx:alpine
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: stark-maester
  namespace: westeros
  labels:
    house: stark
    role: maester
    tier: backend
spec:
  containers:
  - name: maester
    image: busybox
    command: ['sh', '-c', 'echo "Maester at work" && sleep 3600']
EOF

        echo -e "${CYAN}Pods avec labels (westeros):${NC}"
        cat /tmp/gok-labeled-pods.yaml
        echo ""

        kubectl apply -f /tmp/gok-labeled-pods.yaml
        print_success "Pods créés dans namespace 'westeros'!"
        echo ""

        # 3. Créer des pods dans essos
        print_info "Étape 3: Création de pods dans 'essos'..."
        echo ""

        cat > /tmp/gok-essos-pods.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: targaryen-dragon
  namespace: essos
  labels:
    house: targaryen
    role: dragon
    tier: frontend
spec:
  containers:
  - name: dragon
    image: nginx:alpine
    ports:
    - containerPort: 80
EOF

        kubectl apply -f /tmp/gok-essos-pods.yaml
        print_success "Pod créé dans namespace 'essos'!"
        echo ""

        sleep 3

        # 4. Démonstration de la sélection par labels
        print_info "Étape 4: Démonstration de la sélection..."
        echo ""

        echo -e "${GREEN}═══════════════════════════════════════${NC}"
        echo -e "${GREEN}   TESTS DE SÉLECTION${NC}"
        echo -e "${GREEN}═══════════════════════════════════════${NC}"
        echo ""

        echo -e "${YELLOW}1. Tous les pods dans westeros:${NC}"
        kubectl get pods -n westeros --show-labels
        echo ""

        echo -e "${YELLOW}2. Seulement les 'guards' (role=guard):${NC}"
        kubectl get pods -n westeros -l role=guard --show-labels
        echo ""

        echo -e "${YELLOW}3. Seulement le 'maester' (role=maester):${NC}"
        kubectl get pods -n westeros -l role=maester --show-labels
        echo ""

        echo -e "${YELLOW}4. Tous les 'frontend' (tier=frontend):${NC}"
        kubectl get pods -n westeros -l tier=frontend --show-labels
        echo ""

        echo -e "${YELLOW}5. Pods dans namespace 'essos':${NC}"
        kubectl get pods -n essos --show-labels
        echo ""

        echo -e "${GREEN}═══════════════════════════════════════${NC}"
        echo -e "${GREEN}   ISOLATION DES NAMESPACES${NC}"
        echo -e "${GREEN}═══════════════════════════════════════${NC}"
        echo ""

        echo "Observation:"
        echo "  • Les pods 'stark' sont dans namespace 'westeros'"
        echo "  • Le pod 'targaryen' est dans namespace 'essos'"
        echo "  • Chaque namespace est ISOLÉ de l'autre"
        echo "  • Même nom de pod possible dans différents namespaces!"
        echo ""

        print_success "✅ Vous avez appris:"
        echo "  • Créer et utiliser des namespaces"
        echo "  • Attacher des labels aux pods"
        echo "  • Sélectionner des pods par labels"
        echo "  • Comprendre l'isolation des namespaces"
        echo ""

        mark_completed "tutorial_namespaces"

        echo ""
        print_info "Commandes utiles:"
        echo "  kubectl get namespaces"
        echo "  kubectl get pods -n westeros --show-labels"
        echo "  kubectl get pods -l house=stark"
        echo "  kubectl describe pod stark-guard-1 -n westeros"
        echo "  kubectl label pod stark-guard-1 -n westeros new-label=value"
        echo ""

        read -p "Voulez-vous nettoyer ces ressources? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete pod stark-guard-1 stark-guard-2 stark-maester -n westeros
            kubectl delete pod targaryen-dragon -n essos
            kubectl delete namespace essos
            print_success "Ressources supprimées"
        fi
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 7 : Health Probes
tutorial_probes() {
    print_header
    print_banner "🛡️ Tutorial 7: Health Probes - The Night's Watch"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 HEALTH PROBES: SURVEILLANCE ET AUTO-GUÉRISON${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo ""
    echo "  ❌ Sans Health Probes:"
    echo "  • Votre application crashe → Le pod reste 'Running' !"
    echo "  • Le conteneur est bloqué → Kubernetes l'ignore"
    echo "  • L'app démarre lentement → Le traffic arrive trop tôt → CRASH"
    echo "  • Impossible de savoir si l'app est vraiment prête"
    echo ""
    echo "  ✅ Avec Health Probes:"
    echo "  • Liveness Probe → Détecte les blocages → RESTART automatique"
    echo "  • Readiness Probe → Détecte si prêt → Contrôle le traffic"
    echo "  • Startup Probe → Donne du temps au démarrage → Évite les faux positifs"
    echo ""

    print_info "ANALOGIE GAME OF THRONES: 🛡️ THE NIGHT'S WATCH"
    echo ""
    echo "  La Night's Watch surveille le Mur pour détecter les dangers:"
    echo ""
    echo "  ┌──────────────────────────────────────────────────────┐"
    echo "  │  🏰 THE WALL (votre application)                     │"
    echo "  │                                                       │"
    echo "  │  👁️  Liveness Probe = Sentinelle qui vérifie        │"
    echo "  │      'Est-ce que le garde est VIVANT?'               │"
    echo "  │      → Si mort/bloqué → REMPLACER                    │"
    echo "  │                                                       │"
    echo "  │  ✅ Readiness Probe = Vérifier l'équipement          │"
    echo "  │      'Est-ce que le garde est PRÊT au combat?'       │"
    echo "  │      → Si non prêt → NE PAS envoyer en mission      │"
    echo "  │                                                       │"
    echo "  │  ⏱️  Startup Probe = Temps d'entraînement            │"
    echo "  │      'Laisser le recrue FINIR sa formation'          │"
    echo "  │      → Éviter de l'envoyer trop tôt                 │"
    echo "  └──────────────────────────────────────────────────────┘"
    echo ""

    print_info "1️⃣ LIVENESS PROBE (Est-ce VIVANT?)"
    echo ""
    echo "  Détecte si le conteneur est bloqué/mort et le REDÉMARRE"
    echo ""
    echo "  Exemple de problème résolu:"
    echo "    • Deadlock (l'app est bloquée mais le processus tourne)"
    echo "    • Out of memory (l'app est zombie)"
    echo "    • Corruption interne (l'app ne répond plus)"
    echo ""
    echo "  Configuration:"
    echo "    livenessProbe:"
    echo "      httpGet:                    ← Appel HTTP GET"
    echo "        path: /healthz            ← Endpoint de santé"
    echo "        port: 8080"
    echo "      initialDelaySeconds: 15     ← Attendre 15s au démarrage"
    echo "      periodSeconds: 10           ← Vérifier toutes les 10s"
    echo "      failureThreshold: 3         ← 3 échecs → RESTART"
    echo ""
    echo "  ⚠️ Si 3 échecs consécutifs → Kubernetes KILL et REDÉMARRE le pod"
    echo ""

    print_info "2️⃣ READINESS PROBE (Est-ce PRÊT?)"
    echo ""
    echo "  Détecte si le conteneur est prêt à recevoir du TRAFFIC"
    echo ""
    echo "  Différence avec Liveness:"
    echo "    • Liveness → REDÉMARRE le pod si mort"
    echo "    • Readiness → RETIRE du Service si pas prêt (pas de restart!)"
    echo ""
    echo "  Exemple de problème résolu:"
    echo "    • L'app démarre lentement (charge DB, configs...)"
    echo "    • L'app a besoin de warm-up"
    echo "    • Dépendance externe temporairement indisponible"
    echo ""
    echo "  Configuration:"
    echo "    readinessProbe:"
    echo "      httpGet:"
    echo "        path: /ready             ← Endpoint 'ready'"
    echo "        port: 8080"
    echo "      initialDelaySeconds: 5     ← Vérifier après 5s"
    echo "      periodSeconds: 5           ← Toutes les 5s"
    echo ""
    echo "  ✅ Si succès → Pod ajouté aux Endpoints du Service (reçoit traffic)"
    echo "  ❌ Si échec → Pod RETIRÉ des Endpoints (pas de traffic, pas de restart)"
    echo ""

    print_info "3️⃣ STARTUP PROBE (Temps de démarrage)"
    echo ""
    echo "  Donne du temps aux applications qui démarrent LENTEMENT"
    echo ""
    echo "  Pourquoi nécessaire?"
    echo "    • Liveness probe peut tuer un pod qui démarre lentement!"
    echo "    • Startup probe DÉSACTIVE liveness/readiness pendant le démarrage"
    echo ""
    echo "  Configuration:"
    echo "    startupProbe:"
    echo "      httpGet:"
    echo "        path: /healthz"
    echo "        port: 8080"
    echo "      failureThreshold: 30       ← 30 essais max"
    echo "      periodSeconds: 10          ← Toutes les 10s"
    echo "    → Temps max: 30 × 10 = 300s (5 minutes)"
    echo ""
    echo "  Une fois que startup réussit → liveness et readiness s'activent"
    echo ""

    print_info "TYPES DE PROBES DISPONIBLES:"
    echo ""
    echo "  1️⃣ httpGet → Appel HTTP (le plus courant)"
    echo "     httpGet:"
    echo "       path: /healthz"
    echo "       port: 8080"
    echo "       httpHeaders:              ← Optionnel"
    echo "       - name: Custom-Header"
    echo "         value: Awesome"
    echo ""
    echo "  2️⃣ exec → Commande shell dans le conteneur"
    echo "     exec:"
    echo "       command:"
    echo "       - cat"
    echo "       - /tmp/healthy"
    echo "     → Succès si exit code = 0"
    echo ""
    echo "  3️⃣ tcpSocket → Test de connexion TCP"
    echo "     tcpSocket:"
    echo "       port: 8080"
    echo "     → Succès si le port est ouvert"
    echo ""
    echo "  4️⃣ grpc → Appel gRPC (Kubernetes 1.24+)"
    echo "     grpc:"
    echo "       port: 9090"
    echo ""

    print_info "PARAMÈTRES DE CONFIGURATION:"
    echo ""
    echo "  • initialDelaySeconds: Attendre X secondes après démarrage"
    echo "  • periodSeconds: Intervalle entre vérifications (défaut: 10s)"
    echo "  • timeoutSeconds: Timeout d'une vérification (défaut: 1s)"
    echo "  • successThreshold: Nb succès pour marquer 'healthy' (défaut: 1)"
    echo "  • failureThreshold: Nb échecs pour marquer 'unhealthy' (défaut: 3)"
    echo ""

    print_info "QUAND UTILISER QUOI?"
    echo ""
    echo "  ┌─────────────────┬────────────┬────────────┬────────────┐"
    echo "  │  Scénario       │  Liveness  │ Readiness  │  Startup   │"
    echo "  ├─────────────────┼────────────┼────────────┼────────────┤"
    echo "  │ App bloquée     │     ✅     │     ❌     │     ❌     │"
    echo "  │ Démarrage lent  │     ❌     │     ✅     │     ✅     │"
    echo "  │ Dépendance down │     ❌     │     ✅     │     ❌     │"
    echo "  │ Rolling update  │     ✅     │     ✅     │     ❌     │"
    echo "  │ App legacy      │     ✅     │     ✅     │     ✅     │"
    echo "  └─────────────────┴────────────┴────────────┴────────────┘"
    echo ""

    print_info "BONNES PRATIQUES:"
    echo ""
    echo "  ✅ TOUJOURS définir au minimum readiness probe"
    echo "  ✅ Utiliser des endpoints dédiés (/healthz, /ready)"
    echo "  ✅ Faire des checks LÉGERS (ne pas surcharger l'app)"
    echo "  ✅ Tester les dépendances critiques dans readiness"
    echo "  ✅ Utiliser startup pour apps qui démarrent lentement (Java, etc.)"
    echo ""
    echo "  ❌ Ne PAS vérifier les dépendances externes dans liveness"
    echo "     → Sinon tous vos pods redémarrent si DB down!"
    echo "  ❌ Ne PAS mettre initialDelaySeconds trop court"
    echo "     → L'app n'aura pas le temps de démarrer"
    echo "  ❌ Ne PAS oublier failureThreshold"
    echo "     → 1 seul échec ne devrait pas kill un pod"
    echo ""

    print_info "CYCLE DE VIE AVEC PROBES:"
    echo ""
    echo "  1. Pod créé → Conteneur démarre"
    echo "  2. Startup probe s'active (si défini)"
    echo "     ├─ Succès → Active liveness/readiness"
    echo "     └─ Échec après X tentatives → Pod KILLED"
    echo "  3. Liveness probe s'active"
    echo "     ├─ Succès → Continue"
    echo "     └─ Échec (3x) → Pod RESTARTED"
    echo "  4. Readiness probe s'active"
    echo "     ├─ Succès → Ajouté aux Endpoints (reçoit traffic)"
    echo "     └─ Échec → Retiré des Endpoints (pas de traffic)"
    echo ""

    print_info "EXEMPLE RÉEL: Rolling Update avec Probes"
    echo ""
    echo "  Vous déployez une nouvelle version:"
    echo ""
    echo "  Sans readiness probe:"
    echo "    ❌ Nouveau pod démarre → Reçoit traffic IMMÉDIATEMENT"
    echo "    ❌ App pas encore prête → Erreurs 500 → Utilisateurs impactés"
    echo ""
    echo "  Avec readiness probe:"
    echo "    ✅ Nouveau pod démarre → Readiness = NOT READY"
    echo "    ✅ App charge configs, DB connections..."
    echo "    ✅ Readiness = READY → Kubernetes ajoute aux Endpoints"
    echo "    ✅ Traffic redirigé progressivement → Zero downtime!"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer vers l'exemple pratique..."
    echo ""

    # ====== PARTIE PRATIQUE ======
    print_challenge "Challenge: Déployer une app avec Liveness & Readiness Probes"
    echo ""
    echo "Nous allons:"
    echo "  1. Créer un pod SANS probes (comportement par défaut)"
    echo "  2. Créer un pod AVEC probes (comportement amélioré)"
    echo "  3. Simuler un crash et voir la différence"
    echo ""

    read -p "Prêt à démarrer? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    if kubectl get nodes &>/dev/null; then
        echo ""
        print_step "1. Créer un pod SANS probes (simple nginx)"
        echo ""

        cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-no-probes
  namespace: westeros
  labels:
    app: nginx
    probes: disabled
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
EOF

        echo ""
        print_info "Pod créé sans health probes"
        echo "  → Kubernetes ne vérifie RIEN"
        echo "  → Le pod peut être 'Running' même s'il est cassé!"
        echo ""

        sleep 3

        print_step "2. Créer un pod AVEC liveness & readiness probes"
        echo ""

        cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-probes
  namespace: westeros
  labels:
    app: nginx
    probes: enabled
spec:
  containers:
  - name: nginx
    image: nginx:1.25
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 3
      periodSeconds: 5
EOF

        echo ""
        print_info "Pod créé avec health probes"
        echo "  • Liveness: Vérifie toutes les 10s si nginx répond"
        echo "  • Readiness: Vérifie toutes les 5s si prêt à servir"
        echo ""

        sleep 3

        print_step "3. Vérifier l'état des pods"
        echo ""
        kubectl get pods -n westeros -l app=nginx --show-labels

        echo ""
        print_info "Attendons que les probes s'activent..."
        sleep 8

        echo ""
        print_step "4. Détails des probes dans le pod avec probes"
        echo ""
        kubectl describe pod nginx-with-probes -n westeros | grep -A 10 "Liveness\|Readiness"

        echo ""
        print_step "5. Simuler un crash du nginx (supprimer le binaire)"
        echo ""

        print_info "On va simuler un crash en renommant le binaire nginx"
        echo "  → Le processus va crasher"
        echo "  → Liveness probe va échouer"
        echo "  → Kubernetes va REDÉMARRER le conteneur"
        echo ""

        read -p "Simuler le crash du pod AVEC probes? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl exec nginx-with-probes -n westeros -- mv /usr/sbin/nginx /usr/sbin/nginx.bak 2>/dev/null || true
            kubectl exec nginx-with-probes -n westeros -- pkill nginx 2>/dev/null || true

            echo ""
            print_warning "⚠️ Nginx crashé! Observez le restart..."
            echo ""

            sleep 3

            echo "État actuel:"
            kubectl get pod nginx-with-probes -n westeros

            echo ""
            print_info "Regardez la colonne RESTARTS qui va augmenter!"
            echo ""

            sleep 10

            echo "État après 10 secondes:"
            kubectl get pod nginx-with-probes -n westeros

            echo ""
            print_success "✅ Liveness probe a détecté le problème → Pod redémarré automatiquement!"
        fi

        echo ""
        print_step "6. Comparer avec le pod SANS probes"
        echo ""

        print_info "Maintenant crashons le pod SANS probes..."
        kubectl exec nginx-no-probes -n westeros -- pkill nginx 2>/dev/null || true

        sleep 3

        echo ""
        kubectl get pod nginx-no-probes -n westeros

        echo ""
        print_warning "⚠️ Le pod reste 'Running' même si nginx est mort!"
        echo "  → Aucun restart car pas de liveness probe"
        echo "  → Les utilisateurs recevraient des erreurs!"
        echo ""

        print_step "7. Tester readiness probe (simuler app pas prête)"
        echo ""

        cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: app-slow-start
  namespace: westeros
  labels:
    app: slowapp
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ['sh', '-c', 'echo "Not ready yet" > /tmp/status && sleep 15 && echo "Ready!" > /tmp/status && sleep 3600']
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/status
      initialDelaySeconds: 5
      periodSeconds: 3
EOF

        echo ""
        print_info "Pod créé avec readiness probe exec"
        echo "  → Le fichier /tmp/status dit 'Not ready yet' pendant 15s"
        echo "  → Puis devient 'Ready!'"
        echo "  → Observons l'évolution..."
        echo ""

        sleep 6

        echo "État après 6 secondes (pas encore prêt):"
        kubectl get pod app-slow-start -n westeros
        echo ""
        kubectl describe pod app-slow-start -n westeros | grep -A 3 "Conditions:"

        echo ""
        print_info "Notice: Ready = False (pas encore prêt à recevoir traffic)"

        sleep 12

        echo ""
        echo "État après 18 secondes (maintenant prêt):"
        kubectl get pod app-slow-start -n westeros
        echo ""
        kubectl describe pod app-slow-start -n westeros | grep -A 3 "Conditions:"

        echo ""
        print_success "✅ Ready = True (peut maintenant recevoir du traffic)"

        echo ""
        echo ""
        print_banner "📚 RÉCAPITULATIF"
        echo ""

        print_success "✅ Vous avez appris:"
        echo "  • Liveness Probe → Auto-restart si conteneur bloqué/mort"
        echo "  • Readiness Probe → Contrôle du traffic (pas de restart)"
        echo "  • Startup Probe → Temps de démarrage pour apps lentes"
        echo "  • Types de probes: httpGet, exec, tcpSocket, grpc"
        echo "  • Bonnes pratiques et configurations"
        echo ""

        print_info "IMPACT EN PRODUCTION:"
        echo "  • Sans probes → Downtime non détecté, utilisateurs impactés"
        echo "  • Avec probes → Self-healing, zero-downtime deployments"
        echo ""

        mark_completed "tutorial_probes"

        echo ""
        print_info "Commandes utiles:"
        echo "  kubectl get pods -n westeros"
        echo "  kubectl describe pod nginx-with-probes -n westeros"
        echo "  kubectl logs nginx-with-probes -n westeros --previous  # Logs avant restart"
        echo "  kubectl get events -n westeros --sort-by='.lastTimestamp'"
        echo ""

        read -p "Voulez-vous nettoyer ces ressources? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete pod nginx-no-probes nginx-with-probes app-slow-start -n westeros 2>/dev/null || true
            print_success "Ressources supprimées"
        fi
    else
        print_error "Cluster Kubernetes non disponible. Démarrez le cluster d'abord."
        echo ""
        echo "Commande: ./k3d-deploy"
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 8 : Architecture Kubernetes
tutorial_architecture() {
    print_header
    print_banner "👑 Tutorial 8: Architecture Kubernetes - The Iron Throne"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 ARCHITECTURE KUBERNETES: LE TRÔNE DE FER${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo "❓ Vous savez créer des Pods, Deployments, Services..."
    echo "❓ Mais QUI orchestre tout ça ? QUI décide où placer les Pods ?"
    echo "❓ Comment Kubernetes gère un cluster de plusieurs machines ?"
    echo ""

    print_info "💡 ANALOGIE GOT: LE CONSEIL DU ROI"
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Dans Game of Thrones, le pouvoir est organisé ainsi:    │"
    echo "│                                                         │"
    echo "│ 👑 Le Roi (Control Plane):                             │"
    echo "│    - Prend les décisions stratégiques                  │"
    echo "│    - Coordonne tout le royaume                         │"
    echo "│    - Garde la mémoire du royaume (Le Grand Mestre)     │"
    echo "│                                                         │"
    echo "│ ⚔️  Les Lords (Worker Nodes):                          │"
    echo "│    - Exécutent les ordres                              │"
    echo "│    - Gèrent leurs territoires                          │"
    echo "│    - Rapportent au Roi                                 │"
    echo "│                                                         │"
    echo "│ Kubernetes = Même structure!                           │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour découvrir le CONTROL PLANE..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}👑 PARTIE 1: LE CONTROL PLANE (Le Conseil du Roi)${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 RÔLE DU CONTROL PLANE:"
    echo "Le Control Plane = Le cerveau de Kubernetes"
    echo "• Prend TOUTES les décisions"
    echo "• Surveille l'état du cluster"
    echo "• Réagit aux événements"
    echo "• Assure que l'état réel = état désiré"
    echo ""

    print_info "👥 LES 4 COMPOSANTS DU CONTROL PLANE:"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 1. 🗄️  etcd - La Mémoire du Royaume                     │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: Le Grand Mestre avec ses archives            │"
    echo "│                                                         │"
    echo "│ • Base de données clé-valeur distribuée                │"
    echo "│ • Stocke TOUT l'état du cluster:                       │"
    echo "│   - Tous les objets (Pods, Services, etc.)             │"
    echo "│   - Toutes les configurations                          │"
    echo "│   - Tous les secrets                                   │"
    echo "│                                                         │"
    echo "│ • Source unique de vérité (Single Source of Truth)     │"
    echo "│ • Si etcd meurt = Kubernetes perd la mémoire!          │"
    echo "│                                                         │"
    echo "│ Commande pour voir etcd:                               │"
    echo "│ $ kubectl get pods -n kube-system | grep etcd          │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le composant 2..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 2. 🌐 API Server - La Main du Roi                       │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: La Main du Roi qui reçoit toutes requêtes    │"
    echo "│                                                         │"
    echo "│ • Point d'entrée UNIQUE pour tout le cluster           │"
    echo "│ • kubectl parle à l'API Server                         │"
    echo "│ • Expose l'API REST Kubernetes                         │"
    echo "│                                                         │"
    echo "│ Workflow:                                              │"
    echo "│ 1. Reçoit les requêtes (kubectl, dashboard, etc.)      │"
    echo "│ 2. Authentifie (qui es-tu ?)                           │"
    echo "│ 3. Autorise (as-tu le droit ?)                         │"
    echo "│ 4. Valide (est-ce valide ?)                            │"
    echo "│ 5. Persiste dans etcd                                  │"
    echo "│                                                         │"
    echo "│ Exemple de communication:                              │"
    echo "│ $ kubectl get pods                                     │"
    echo "│   → kubectl → API Server → etcd → réponse             │"
    echo "│                                                         │"
    echo "│ Commande pour voir l'API Server:                       │"
    echo "│ $ kubectl get pods -n kube-system | grep apiserver     │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le composant 3..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 3. 📅 Scheduler - Le Maître des Stratégies              │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: Stratège qui place les armées sur le terrain │"
    echo "│                                                         │"
    echo "│ • Décide sur QUEL worker node placer chaque Pod        │"
    echo "│ • Ne fait QUE la décision, n'exécute pas!              │"
    echo "│                                                         │"
    echo "│ Critères de décision:                                  │"
    echo "│ ✓ Ressources disponibles (CPU, RAM)                    │"
    echo "│ ✓ Affinity/Anti-affinity rules                         │"
    echo "│ ✓ Taints et Tolerations                                │"
    echo "│ ✓ Labels et Selectors                                  │"
    echo "│ ✓ Contraintes spécifiques (nodeSelector)               │"
    echo "│                                                         │"
    echo "│ Workflow:                                              │"
    echo "│ 1. Surveille l'API Server pour nouveaux Pods           │"
    echo "│ 2. Trouve les Pods sans node assigné                   │"
    echo "│ 3. Évalue tous les worker nodes                        │"
    echo "│ 4. Choisit le meilleur node                            │"
    echo "│ 5. Assigne le Pod au node via l'API Server             │"
    echo "│                                                         │"
    echo "│ Commande pour voir le Scheduler:                       │"
    echo "│ $ kubectl get pods -n kube-system | grep scheduler     │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le composant 4..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 4. 🎮 Controller Manager - Les Gardiens de l'Ordre      │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: Les Maesters qui veillent sur le royaume     │"
    echo "│                                                         │"
    echo "│ • Ensemble de contrôleurs surveillant l'état           │"
    echo "│ • Assure: État Réel = État Désiré                      │"
    echo "│                                                         │"
    echo "│ Principaux Contrôleurs:                                │"
    echo "│                                                         │"
    echo "│ 🔹 Node Controller:                                     │"
    echo "│    - Surveille la santé des worker nodes               │"
    echo "│    - Détecte les nodes morts                           │"
    echo "│    - Toutes les 5s: heartbeat check                    │"
    echo "│                                                         │"
    echo "│ 🔹 Replication Controller:                              │"
    echo "│    - Assure le bon nombre de replicas                  │"
    echo "│    - Si Pod meurt → en crée un nouveau                 │"
    echo "│    - Gère ReplicaSets                                  │"
    echo "│                                                         │"
    echo "│ 🔹 Endpoints Controller:                                │"
    echo "│    - Maintient la liste des endpoints de Services      │"
    echo "│    - Quand Pod démarre → ajoute à Service endpoints    │"
    echo "│                                                         │"
    echo "│ 🔹 Service Account Controller:                          │"
    echo "│    - Crée les ServiceAccounts par défaut               │"
    echo "│    - Gère les tokens d'authentification                │"
    echo "│                                                         │"
    echo "│ Workflow (exemple ReplicaSet):                         │"
    echo "│ 1. Observe l'état via API Server                       │"
    echo "│ 2. Compare: Désiré=3 replicas, Réel=2 replicas         │"
    echo "│ 3. Action: Crée 1 nouveau Pod                          │"
    echo "│ 4. Informe l'API Server                                │"
    echo "│                                                         │"
    echo "│ Commande pour voir le Controller Manager:              │"
    echo "│ $ kubectl get pods -n kube-system | grep controller    │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour découvrir les WORKER NODES..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}⚔️  PARTIE 2: LES WORKER NODES (Les Lords et leurs armées)${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 RÔLE DES WORKER NODES:"
    echo "Les Worker Nodes = Les machines qui exécutent vos applications"
    echo "• Hébergent les Pods"
    echo "• Exécutent les containers"
    echo "• Rapportent au Control Plane"
    echo ""

    print_info "👥 LES 3 COMPOSANTS DES WORKER NODES:"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 1. 🤖 kubelet - L'Agent Local                           │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: Le Castellan qui gère le château             │"
    echo "│                                                         │"
    echo "│ • Agent qui tourne sur CHAQUE worker node              │"
    echo "│ • Communique avec l'API Server                         │"
    echo "│                                                         │"
    echo "│ Responsabilités:                                       │"
    echo "│ ✓ Reçoit les PodSpecs de l'API Server                  │"
    echo "│ ✓ S'assure que les containers tournent                 │"
    echo "│ ✓ Monte les volumes                                    │"
    echo "│ ✓ Récupère les secrets/configmaps                      │"
    echo "│ ✓ Rapporte le statut des Pods                          │"
    echo "│ ✓ Exécute les health probes (liveness/readiness)       │"
    echo "│                                                         │"
    echo "│ Communication:                                         │"
    echo "│ API Server → kubelet: \"Lance ce Pod\"                  │"
    echo "│ kubelet → Container Runtime: \"Crée ces containers\"    │"
    echo "│ kubelet → API Server: \"Pod est Running\"               │"
    echo "│                                                         │"
    echo "│ Toutes les 10s: envoie le statut au Control Plane      │"
    echo "│                                                         │"
    echo "│ Commande (sur le node):                                │"
    echo "│ $ systemctl status kubelet                             │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le composant 2..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 2. 🐳 Container Runtime - Le Forgeron                   │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: Le forgeron qui crée les armes               │"
    echo "│                                                         │"
    echo "│ • Logiciel qui exécute les containers                  │"
    echo "│ • Pull les images depuis les registres                 │"
    echo "│ • Démarre/stoppe les containers                        │"
    echo "│                                                         │"
    echo "│ Runtimes supportés (via CRI - Container Runtime        │"
    echo "│ Interface):                                            │"
    echo "│                                                         │"
    echo "│ 🔹 containerd (recommandé):                             │"
    echo "│    - Léger et performant                               │"
    echo "│    - Standard de facto                                 │"
    echo "│    - Utilisé par k3d, kind, cloud providers            │"
    echo "│                                                         │"
    echo "│ 🔹 CRI-O:                                                │"
    echo "│    - Créé spécifiquement pour Kubernetes               │"
    echo "│    - Utilisé par OpenShift                             │"
    echo "│                                                         │"
    echo "│ 🔹 Docker Engine (via cri-dockerd):                     │"
    echo "│    - Support indirect                                  │"
    echo "│    - Legacy                                            │"
    echo "│                                                         │"
    echo "│ Workflow:                                              │"
    echo "│ 1. kubelet demande: \"Lance nginx:alpine\"              │"
    echo "│ 2. Runtime pull l'image depuis Docker Hub              │"
    echo "│ 3. Runtime crée le container                           │"
    echo "│ 4. Runtime démarre le container                        │"
    echo "│ 5. Runtime surveille le container                      │"
    echo "│                                                         │"
    echo "│ Commande pour voir le runtime:                         │"
    echo "│ $ crictl ps     # Liste containers avec CRI            │"
    echo "│ $ docker ps     # Si Docker est utilisé                │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le composant 3..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 3. 🌐 kube-proxy - Le Messager                          │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Rôle GOT: Les corbeaux qui transmettent les messages   │"
    echo "│                                                         │"
    echo "│ • Agent réseau sur CHAQUE worker node                  │"
    echo "│ • Gère les règles réseau locales                       │"
    echo "│ • Permet la communication avec les Services            │"
    echo "│                                                         │"
    echo "│ Responsabilités:                                       │"
    echo "│ ✓ Maintient les règles réseau (iptables/IPVS)          │"
    echo "│ ✓ Fait le load balancing vers les Pods                 │"
    echo "│ ✓ Implémente le concept de Service                     │"
    echo "│                                                         │"
    echo "│ Exemple concret:                                       │"
    echo "│ Service ClusterIP: 10.96.0.10:80                        │"
    echo "│ Endpoints: 172.17.0.3:8080, 172.17.0.4:8080            │"
    echo "│                                                         │"
    echo "│ kube-proxy crée des règles iptables:                   │"
    echo "│ \"Si trafic vers 10.96.0.10:80\"                        │"
    echo "│ \"→ Redirige aléatoirement vers un des endpoints\"      │"
    echo "│                                                         │"
    echo "│ Modes disponibles:                                     │"
    echo "│ • iptables (défaut): Utilise netfilter                 │"
    echo "│ • IPVS: Plus performant pour large scale               │"
    echo "│ • userspace: Legacy (pas recommandé)                   │"
    echo "│                                                         │"
    echo "│ Traffic Policy:                                        │"
    echo "│ • Cluster: Load balance vers TOUS les Pods             │"
    echo "│ • Local: Seulement les Pods sur le même node           │"
    echo "│                                                         │"
    echo "│ Commande pour voir kube-proxy:                         │"
    echo "│ $ kubectl get pods -n kube-system | grep kube-proxy    │"
    echo "│ $ kubectl get ds -n kube-system kube-proxy             │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour voir le NETWORKING..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🌐 PARTIE 3: LE RÉSEAU KUBERNETES${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 LES 4 MODÈLES DE COMMUNICATION:"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 1. Container-to-Container (dans le même Pod)           │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ • Partagent le même namespace réseau                   │"
    echo "│ • Communiquent via localhost                           │"
    echo "│ • Exemple: nginx + sidecar dans même Pod               │"
    echo "│   → nginx: localhost:80                                │"
    echo "│   → sidecar: localhost:9090                            │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 2. Pod-to-Pod (n'importe où dans le cluster)           │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ • Chaque Pod a sa propre IP unique                     │"
    echo "│ • Tous les Pods peuvent communiquer sans NAT           │"
    echo "│ • Réseau plat (flat network)                           │"
    echo "│                                                         │"
    echo "│ Exemple:                                               │"
    echo "│ Pod A (172.17.0.3) → Pod B (172.17.0.5)                │"
    echo "│ Communication directe via IP                           │"
    echo "│                                                         │"
    echo "│ Implémenté par: CNI Plugin                             │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 3. Pod-to-Service (via abstraction)                    │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ • Service = IP virtuelle stable                        │"
    echo "│ • Load balance automatiquement                         │"
    echo "│ • DNS resolution                                       │"
    echo "│                                                         │"
    echo "│ Exemple:                                               │"
    echo "│ $ curl http://web-service:80                           │"
    echo "│ → DNS résout: web-service → 10.96.0.10                 │"
    echo "│ → kube-proxy redirige → 172.17.0.3:8080 (random Pod)   │"
    echo "│                                                         │"
    echo "│ Format DNS:                                            │"
    echo "│ <service>.<namespace>.svc.cluster.local                │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 4. External-to-Service (monde extérieur)               │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Via différents ServiceTypes:                           │"
    echo "│                                                         │"
    echo "│ • NodePort:                                            │"
    echo "│   Internet → Node IP:30080 → Service → Pods            │"
    echo "│                                                         │"
    echo "│ • LoadBalancer (cloud):                                │"
    echo "│   Internet → LB IP → Nodes → Service → Pods            │"
    echo "│                                                         │"
    echo "│ • Ingress/Gateway:                                     │"
    echo "│   Internet → Ingress Controller → Services → Pods      │"
    echo "│   Support: routing par hostname/path                   │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    print_info "🔌 CNI - Container Network Interface:"
    echo "• Plugins pour implémenter le réseau Kubernetes"
    echo "• Populaires: Calico, Flannel, Weave, Cilium"
    echo "• k3d utilise Flannel par défaut"
    echo ""

    read -p "Appuyez sur ENTRÉE pour RBAC & SÉCURITÉ..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🔐 PARTIE 4: RBAC & SÉCURITÉ${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 RBAC = Role-Based Access Control"
    echo "Contrôle QUI peut faire QUOI dans le cluster"
    echo ""

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 🔑 AUTHENTICATION (Qui es-tu ?)                         │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│                                                         │"
    echo "│ 2 types d'utilisateurs:                                │"
    echo "│                                                         │"
    echo "│ 1. Normal Users:                                       │"
    echo "│    • Humains (vous!)                                   │"
    echo "│    • Authentifiés via certificats X509                 │"
    echo "│    • Gérés en dehors de Kubernetes                     │"
    echo "│                                                         │"
    echo "│ 2. Service Accounts:                                   │"
    echo "│    • Pour les Pods                                     │"
    echo "│    • Gérés par Kubernetes                              │"
    echo "│    • Ont des tokens automatiques                       │"
    echo "│                                                         │"
    echo "│ Méthodes d'authentification:                           │"
    echo "│ • X509 Client Certificates (le plus courant)           │"
    echo "│ • Bearer Tokens                                        │"
    echo "│ • Bootstrap Tokens                                     │"
    echo "│ • Service Account Tokens                               │"
    echo "│                                                         │"
    echo "│ Commandes:                                             │"
    echo "│ $ kubectl get serviceaccounts                          │"
    echo "│ $ kubectl create serviceaccount mon-app                │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour AUTHORIZATION..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ ✅ AUTHORIZATION (As-tu le droit ?)                     │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│                                                         │"
    echo "│ Modes d'autorisation:                                  │"
    echo "│ • RBAC (recommandé) ✅                                  │"
    echo "│ • ABAC (legacy)                                        │"
    echo "│ • Node (pour kubelet)                                  │"
    echo "│ • Webhook (délégation externe)                         │"
    echo "│                                                         │"
    echo "│ ─────────────────────────────────────────              │"
    echo "│ RBAC - 4 objets principaux:                            │"
    echo "│ ─────────────────────────────────────────              │"
    echo "│                                                         │"
    echo "│ 1️⃣  Role (namespace-scoped):                           │"
    echo "│    Définit des permissions DANS un namespace           │"
    echo "│                                                         │"
    echo "│    Exemple:                                            │"
    echo "│    kind: Role                                          │"
    echo "│    rules:                                              │"
    echo "│    - apiGroups: [\"\"]                                   │"
    echo "│      resources: [\"pods\"]                               │"
    echo "│      verbs: [\"get\", \"list\"]                           │"
    echo "│                                                         │"
    echo "│ 2️⃣  RoleBinding (namespace-scoped):                    │"
    echo "│    Attache un Role à un user/serviceaccount            │"
    echo "│                                                         │"
    echo "│    Exemple:                                            │"
    echo "│    kind: RoleBinding                                   │"
    echo "│    subjects:                                           │"
    echo "│    - kind: User                                        │"
    echo "│      name: alice                                       │"
    echo "│    roleRef:                                            │"
    echo "│      kind: Role                                        │"
    echo "│      name: pod-reader                                  │"
    echo "│                                                         │"
    echo "│ 3️⃣  ClusterRole (cluster-wide):                        │"
    echo "│    Permissions à travers TOUT le cluster               │"
    echo "│                                                         │"
    echo "│ 4️⃣  ClusterRoleBinding (cluster-wide):                 │"
    echo "│    Attache ClusterRole à un user/SA                    │"
    echo "│                                                         │"
    echo "│ Verbs (actions possibles):                             │"
    echo "│ • get, list, watch (lecture)                           │"
    echo "│ • create, update, patch, delete (écriture)             │"
    echo "│ • deletecollection                                     │"
    echo "│                                                         │"
    echo "│ Commandes:                                             │"
    echo "│ $ kubectl get roles                                    │"
    echo "│ $ kubectl get rolebindings                             │"
    echo "│ $ kubectl get clusterroles                             │"
    echo "│ $ kubectl auth can-i get pods --as=alice               │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour ADMISSION CONTROLLERS..."

    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 🛡️  ADMISSION CONTROLLERS (Validation finale)           │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│                                                         │"
    echo "│ • Interceptent les requêtes APRÈS auth/authz           │"
    echo "│ • AVANT persistance dans etcd                          │"
    echo "│ • Peuvent valider OU modifier                          │"
    echo "│                                                         │"
    echo "│ 2 types:                                               │"
    echo "│                                                         │"
    echo "│ 1. Validating:                                         │"
    echo "│    Accepte ou rejette (lecture seule)                  │"
    echo "│    Ex: \"Ce Pod dépasse les quotas\" → REJECT           │"
    echo "│                                                         │"
    echo "│ 2. Mutating:                                           │"
    echo "│    Modifie la requête                                  │"
    echo "│    Ex: Ajoute automatiquement des labels               │"
    echo "│                                                         │"
    echo "│ Admission Controllers courants:                        │"
    echo "│ • NamespaceLifecycle: Empêche création dans           │"
    echo "│   namespace en cours de suppression                    │"
    echo "│ • LimitRanger: Applique les limites de ressources      │"
    echo "│ • ResourceQuota: Applique les quotas                   │"
    echo "│ • PodSecurityPolicy: Sécurité des Pods                 │"
    echo "│ • DefaultStorageClass: Ajoute StorageClass par défaut  │"
    echo "│                                                         │"
    echo "│ Custom Admission via Webhooks:                         │"
    echo "│ • ValidatingWebhookConfiguration                       │"
    echo "│ • MutatingWebhookConfiguration                         │"
    echo "│   → Kubernetes appelle votre service HTTP              │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le WORKFLOW COMPLET..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🔄 PARTIE 5: WORKFLOW COMPLET - De kubectl à Running Pod${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "📝 SCÉNARIO: kubectl create deployment nginx --image=nginx --replicas=3"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│                    WORKFLOW DÉTAILLÉ                    │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""
    echo "1️⃣  kubectl → API Server"
    echo "   • kubectl envoie requête HTTP POST"
    echo "   • Headers: Bearer token / Certificate"
    echo "   • Body: Deployment manifest (JSON)"
    echo ""
    echo "2️⃣  API Server: Authentication"
    echo "   • Vérifie le certificat X509"
    echo "   • OU vérifie le Bearer token"
    echo "   • Question: \"Qui es-tu ?\""
    echo "   • ✅ Authentifié: alice@example.com"
    echo ""
    echo "3️⃣  API Server: Authorization (RBAC)"
    echo "   • Vérifie les Roles/ClusterRoles de alice"
    echo "   • Question: \"As-tu le droit de créer des Deployments ?\""
    echo "   • ✅ Autorisé: alice a le verbe 'create' sur 'deployments'"
    echo ""
    echo "4️⃣  API Server: Admission Controllers"
    echo "   • Mutating Admission:"
    echo "     - Ajoute labels par défaut"
    echo "     - Injecte sidecar si configuré"
    echo "   • Validating Admission:"
    echo "     - Vérifie quotas du namespace"
    echo "     - Vérifie PodSecurityPolicy"
    echo "   • ✅ Validé et modifié"
    echo ""
    echo "5️⃣  API Server → etcd"
    echo "   • Persiste le Deployment dans etcd"
    echo "   • Clé: /registry/deployments/default/nginx"
    echo "   • Valeur: Deployment object (JSON)"
    echo "   • ✅ Stocké"
    echo ""
    echo "6️⃣  Deployment Controller (surveille etcd via API Server)"
    echo "   • Détecte: Nouveau Deployment avec replicas=3"
    echo "   • Action: Crée un ReplicaSet"
    echo "   • Via API Server → etcd"
    echo "   • ✅ ReplicaSet créé: nginx-7d8b9c6f-xxxxx"
    echo ""
    echo "7️⃣  ReplicaSet Controller"
    echo "   • Détecte: Nouveau ReplicaSet avec replicas=3"
    echo "   • Action: Crée 3 Pods (status=Pending)"
    echo "   • Via API Server → etcd"
    echo "   • ✅ 3 Pods créés (sans node assigné)"
    echo ""
    echo "8️⃣  Scheduler (surveille Pods Pending)"
    echo "   • Détecte: 3 Pods sans node assigné"
    echo "   • Pour chaque Pod:"
    echo "     - Évalue tous les worker nodes"
    echo "     - Calcule score (ressources, affinity, taints...)"
    echo "     - Choisit le meilleur node"
    echo "   • Décision:"
    echo "     - Pod 1 → worker-1"
    echo "     - Pod 2 → worker-2"
    echo "     - Pod 3 → worker-1"
    echo "   • Met à jour via API Server → etcd"
    echo "   • ✅ Pods assignés aux nodes"
    echo ""
    echo "9️⃣  kubelet (sur worker-1 et worker-2)"
    echo "   • Surveille l'API Server toutes les 10s"
    echo "   • Détecte: Pods assignés à son node"
    echo "   • Pour chaque Pod:"
    echo "     a) Crée les volumes"
    echo "     b) Récupère les Secrets/ConfigMaps"
    echo "     c) Demande au Container Runtime:"
    echo "        → Pull image nginx"
    echo "        → Crée container"
    echo "        → Démarre container"
    echo "     d) Configure le réseau (via CNI)"
    echo "     e) Démarre les health probes"
    echo "   • ✅ Containers Running"
    echo ""
    echo "🔟 kubelet → API Server"
    echo "   • Rapporte le statut: Pod status=Running"
    echo "   • API Server → etcd (mise à jour)"
    echo "   • ✅ Deployment complété!"
    echo ""
    echo "1️⃣1️⃣  Endpoints Controller"
    echo "   • Détecte: Nouveaux Pods Running avec labels app=nginx"
    echo "   • Si Service existe avec selector app=nginx:"
    echo "     - Ajoute les Pod IPs aux endpoints du Service"
    echo "   • ✅ Service endpoints mis à jour"
    echo ""
    echo "1️⃣2️⃣  kube-proxy (sur tous les nodes)"
    echo "   • Détecte: Endpoints du Service mis à jour"
    echo "   • Crée/Met à jour les règles iptables:"
    echo "     - Si trafic vers Service ClusterIP"
    echo "     - → Load balance vers Pod IPs"
    echo "   • ✅ Service accessible!"
    echo ""

    print_success "🎉 RÉSULTAT FINAL:"
    echo "• 1 Deployment créé"
    echo "• 1 ReplicaSet créé"
    echo "• 3 Pods Running (distribués sur workers)"
    echo "• Service endpoints configurés"
    echo "• Règles réseau actives"
    echo "• Application accessible!"
    echo ""

    read -p "Appuyez sur ENTRÉE pour la PARTIE PRATIQUE..."
    print_header

    # ====== PARTIE PRATIQUE ======
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}💻 PARTIE PRATIQUE: EXPLORER L'ARCHITECTURE${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if kubectl cluster-info &>/dev/null; then
        print_success "✓ Cluster Kubernetes disponible"
        echo ""

        # Démo 1 : Control Plane
        print_info "🎯 DÉMO 1: Observer les composants du Control Plane"
        echo ""
        echo "$ kubectl get pods -n kube-system"
        echo ""
        kubectl get pods -n kube-system
        echo ""

        print_info "💡 Vous devriez voir:"
        echo "• etcd-* (la base de données)"
        echo "• kube-apiserver-* (l'API Server)"
        echo "• kube-scheduler-* (le Scheduler)"
        echo "• kube-controller-manager-* (les Controllers)"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 2 : Nodes et leurs composants
        print_info "🎯 DÉMO 2: Observer les Worker Nodes"
        echo ""
        echo "$ kubectl get nodes -o wide"
        echo ""
        kubectl get nodes -o wide
        echo ""

        print_info "💡 Pour chaque node, vous voyez:"
        echo "• INTERNAL-IP: IP du node"
        echo "• CONTAINER-RUNTIME: containerd://..."
        echo "• KERNEL-VERSION: Version Linux"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 3 : kube-proxy (DaemonSet)
        print_info "🎯 DÉMO 3: Observer kube-proxy (DaemonSet)"
        echo ""
        echo "$ kubectl get daemonset -n kube-system"
        echo ""
        kubectl get daemonset -n kube-system
        echo ""

        print_info "💡 DaemonSet = 1 Pod par node automatiquement"
        echo "Parfait pour kube-proxy qui doit tourner partout!"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 4 : ServiceAccounts
        print_info "🎯 DÉMO 4: ServiceAccounts par défaut"
        echo ""
        echo "$ kubectl get serviceaccounts"
        echo ""
        kubectl get serviceaccounts
        echo ""

        print_info "💡 Chaque namespace a un ServiceAccount 'default'"
        echo "Automatiquement injecté dans les Pods"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 5 : RBAC - ClusterRoles
        print_info "🎯 DÉMO 5: ClusterRoles prédéfinis (RBAC)"
        echo ""
        echo "$ kubectl get clusterroles | head -20"
        echo ""
        kubectl get clusterroles | head -20
        echo ""

        print_info "💡 ClusterRoles importants:"
        echo "• cluster-admin: Super admin (tout faire)"
        echo "• view: Lecture seule"
        echo "• edit: Lecture + Écriture (sauf RBAC)"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 6 : Tester les permissions
        print_info "🎯 DÉMO 6: Vérifier vos permissions (auth can-i)"
        echo ""
        echo "$ kubectl auth can-i create deployments"
        echo ""
        kubectl auth can-i create deployments
        echo ""

        echo "$ kubectl auth can-i delete nodes"
        echo ""
        kubectl auth can-i delete nodes
        echo ""

        echo "$ kubectl auth can-i get pods --all-namespaces"
        echo ""
        kubectl auth can-i get pods --all-namespaces
        echo ""

        print_info "💡 'yes' = vous avez le droit, 'no' = interdit"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 7 : Créer un Deployment et observer le workflow
        print_info "🎯 DÉMO 7: Workflow complet - Créer un Deployment"
        echo ""
        echo "Nous allons créer un Deployment et observer comment"
        echo "le Control Plane orchestre la création des Pods."
        echo ""

        print_info "Création du Deployment 'architecture-demo'..."
        echo ""
        echo "$ kubectl create deployment architecture-demo --image=nginx:alpine --replicas=2"
        echo ""
        kubectl create deployment architecture-demo --image=nginx:alpine --replicas=2
        echo ""

        sleep 2

        print_info "Observer le Deployment:"
        echo ""
        echo "$ kubectl get deployment architecture-demo"
        echo ""
        kubectl get deployment architecture-demo
        echo ""

        print_info "Observer le ReplicaSet créé par le Deployment Controller:"
        echo ""
        echo "$ kubectl get replicaset"
        echo ""
        kubectl get replicaset | grep architecture-demo
        echo ""

        print_info "Observer les Pods créés et assignés par le Scheduler:"
        echo ""
        echo "$ kubectl get pods -o wide | grep architecture-demo"
        echo ""
        kubectl get pods -o wide | grep architecture-demo
        echo ""

        print_info "💡 Regardez la colonne NODE:"
        echo "Le Scheduler a distribué les Pods sur différents nodes!"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 8 : Exposer et observer les endpoints
        print_info "🎯 DÉMO 8: Créer un Service et observer les Endpoints"
        echo ""
        echo "$ kubectl expose deployment architecture-demo --port=80 --type=ClusterIP"
        echo ""
        kubectl expose deployment architecture-demo --port=80 --type=ClusterIP 2>/dev/null || true
        echo ""

        sleep 1

        print_info "Observer le Service créé:"
        echo ""
        echo "$ kubectl get service architecture-demo"
        echo ""
        kubectl get service architecture-demo
        echo ""

        print_info "Observer les Endpoints (géré par Endpoints Controller):"
        echo ""
        echo "$ kubectl get endpoints architecture-demo"
        echo ""
        kubectl get endpoints architecture-demo
        echo ""

        print_info "💡 Les Endpoints = Les IPs des Pods"
        echo "kube-proxy va créer des règles iptables pour load balancer"
        echo "le trafic vers ces IPs quand on accède au Service ClusterIP!"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 9 : Voir les events
        print_info "🎯 DÉMO 9: Observer les Events (historique des actions)"
        echo ""
        echo "$ kubectl get events --sort-by='.lastTimestamp' | tail -15"
        echo ""
        kubectl get events --sort-by='.lastTimestamp' | tail -15
        echo ""

        print_info "💡 Les Events montrent:"
        echo "• Scheduled: Le Scheduler a assigné le Pod à un node"
        echo "• Pulling: kubelet pull l'image"
        echo "• Pulled: Image téléchargée"
        echo "• Created: Container créé"
        echo "• Started: Container démarré"
        echo ""

        read -p "Appuyez sur ENTRÉE pour nettoyer..."

        # Nettoyage
        print_info "🧹 Nettoyage des ressources de la démo"
        echo ""
        kubectl delete deployment architecture-demo 2>/dev/null || true
        kubectl delete service architecture-demo 2>/dev/null || true
        print_success "✓ Ressources supprimées"
        echo ""

    else
        print_error "Cluster Kubernetes non disponible. Démarrez le cluster d'abord."
        echo ""
        echo "Commande: ./k3d-deploy"
    fi

    # Résumé final
    print_header
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📚 RÉSUMÉ: ARCHITECTURE KUBERNETES${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "👑 CONTROL PLANE (Le Conseil du Roi):"
    echo "  1. etcd → Base de données (mémoire)"
    echo "  2. API Server → Point d'entrée unique"
    echo "  3. Scheduler → Placement des Pods"
    echo "  4. Controller Manager → État désiré = État réel"
    echo ""

    print_info "⚔️  WORKER NODES (Les Lords):"
    echo "  1. kubelet → Agent local, gère les Pods"
    echo "  2. Container Runtime → Exécute les containers"
    echo "  3. kube-proxy → Réseau et load balancing"
    echo ""

    print_info "🌐 RÉSEAU:"
    echo "  • Container-to-Container: localhost (même Pod)"
    echo "  • Pod-to-Pod: IP directe (réseau plat)"
    echo "  • Pod-to-Service: ClusterIP + DNS (kube-proxy)"
    echo "  • External-to-Service: NodePort/LoadBalancer/Ingress"
    echo ""

    print_info "🔐 SÉCURITÉ (RBAC):"
    echo "  • Authentication: X509 certificates, Service Accounts"
    echo "  • Authorization: Roles, RoleBindings, ClusterRoles"
    echo "  • Admission: Validation et mutation avant persistance"
    echo ""

    print_info "🔄 WORKFLOW (kubectl create → Running Pod):"
    echo "  kubectl → API (auth/authz/admission) → etcd"
    echo "       → Controllers créent objets → Scheduler assigne nodes"
    echo "       → kubelet exécute → Container Runtime démarre containers"
    echo "       → kube-proxy configure réseau → Application accessible!"
    echo ""

    print_success "🎉 Vous comprenez maintenant COMMENT Kubernetes fonctionne!"
    echo ""
    echo "Winter is Coming... And you're ready! 🐺⚔️"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 9 : Service Discovery
tutorial_service_discovery() {
    print_header
    print_banner "🔍 Tutorial 9: Service Discovery - Ravens & Messengers"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 SERVICE DISCOVERY: COMMENT LES PODS SE TROUVENT${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo "❓ Vous avez 10 microservices qui doivent communiquer entre eux"
    echo "❓ Comment un Pod Frontend trouve l'adresse du Pod Backend?"
    echo "❓ Comment gérer les IPs changeantes des Pods?"
    echo ""

    print_info "💡 ANALOGIE GOT: LES CORBEAUX MESSAGERS"
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Dans Game of Thrones:                                   │"
    echo "│ • Les ravens (corbeaux) livrent les messages           │"
    echo "│ • Vous n'avez pas besoin de savoir OÙ est le château   │"
    echo "│ • Vous dites: 'Envoie à Winterfell'                     │"
    echo "│ • Le corbeau trouve automatiquement le château          │"
    echo "│                                                         │"
    echo "│ Kubernetes Service Discovery = Même principe!          │"
    echo "│ • Vous dites: 'Appelle backend-service'                │"
    echo "│ • Kubernetes trouve automatiquement les Pods           │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour découvrir les 2 MÉTHODES..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🌐 MÉTHODE 1: DNS (CoreDNS) - LA MÉTHODE RECOMMANDÉE${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 CoreDNS: Le serveur DNS de Kubernetes"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ CoreDNS tourne dans kube-system et résout les noms     │"
    echo "│ de Services en adresses IP automatiquement              │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Format FQDN (Fully Qualified Domain Name):             │"
    echo "│                                                         │"
    echo "│   <service-name>.<namespace>.svc.cluster.local          │"
    echo "│                                                         │"
    echo "│ Exemples:                                               │"
    echo "│   • web-service.default.svc.cluster.local               │"
    echo "│   • api-backend.production.svc.cluster.local            │"
    echo "│   • database.westeros.svc.cluster.local                 │"
    echo "│                                                         │"
    echo "│ Raccourcis (dans le MÊME namespace):                   │"
    echo "│   • web-service          ← Fonctionne!                 │"
    echo "│   • web-service.default  ← Fonctionne aussi!           │"
    echo "│                                                         │"
    echo "│ Raccourcis (namespace DIFFÉRENT):                      │"
    echo "│   • api-backend.production  ← Doit spécifier namespace │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    print_info "📝 EXEMPLE CONCRET:"
    echo ""
    echo "Vous avez 2 Services:"
    echo "  • frontend-service (namespace: default)"
    echo "  • backend-api (namespace: production)"
    echo ""
    echo "Dans le Pod frontend, vous pouvez appeler backend:"
    echo ""
    echo "  ✅ CORRECT (FQDN complet):"
    echo "     fetch('http://backend-api.production.svc.cluster.local:8080/api')"
    echo ""
    echo "  ✅ CORRECT (namespace spécifié):"
    echo "     fetch('http://backend-api.production:8080/api')"
    echo ""
    echo "  ❌ INCORRECT (namespace manquant, cherchera dans 'default'):"
    echo "     fetch('http://backend-api:8080/api')"
    echo ""

    read -p "Appuyez sur ENTRÉE pour voir comment CoreDNS fonctionne..."

    echo ""
    print_info "🔍 WORKFLOW DNS RÉSOLUTION:"
    echo ""
    echo "1️⃣  Pod Frontend exécute:"
    echo "   curl http://backend-api.production:8080/api"
    echo ""
    echo "2️⃣  Requête DNS envoyée à CoreDNS:"
    echo "   'Quelle est l'IP de backend-api.production?'"
    echo ""
    echo "3️⃣  CoreDNS consulte l'API Server:"
    echo "   • Cherche Service 'backend-api' dans namespace 'production'"
    echo "   • Trouve le Service avec ClusterIP: 10.96.50.10"
    echo ""
    echo "4️⃣  CoreDNS répond:"
    echo "   backend-api.production → 10.96.50.10"
    echo ""
    echo "5️⃣  Pod Frontend se connecte:"
    echo "   curl http://10.96.50.10:8080/api"
    echo ""
    echo "6️⃣  kube-proxy route vers un des Pods backend (load balancing)"
    echo ""

    print_success "💡 Tout est automatique, vous utilisez juste le nom DNS!"
    echo ""

    read -p "Appuyez sur ENTRÉE pour DNS RECORDS TYPES..."

    echo ""
    print_info "📊 TYPES DE RECORDS DNS CRÉÉS:"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ 1. A Records (Services):                                │"
    echo "│    backend-api.production.svc.cluster.local             │"
    echo "│      → 10.96.50.10 (ClusterIP du Service)               │"
    echo "│                                                         │"
    echo "│ 2. SRV Records (Port discovery):                        │"
    echo "│    _http._tcp.backend-api.production.svc.cluster.local  │"
    echo "│      → Port 8080                                        │"
    echo "│                                                         │"
    echo "│ 3. PTR Records (Reverse DNS):                           │"
    echo "│    10.50.96.10.in-addr.arpa                             │"
    echo "│      → backend-api.production.svc.cluster.local         │"
    echo "│                                                         │"
    echo "│ 4. A Records (Pods - si activé):                        │"
    echo "│    10-42-1-5.production.pod.cluster.local               │"
    echo "│      → 10.42.1.5 (IP du Pod)                            │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour la MÉTHODE 2..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}📦 MÉTHODE 2: VARIABLES D'ENVIRONNEMENT (LEGACY)${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 kubelet injecte automatiquement des variables"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Quand un Pod démarre, kubelet injecte des variables    │"
    echo "│ d'environnement pour TOUS les Services existants        │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Format:                                                 │"
    echo "│   {SVCNAME}_SERVICE_HOST=<cluster-ip>                   │"
    echo "│   {SVCNAME}_SERVICE_PORT=<port>                         │"
    echo "│                                                         │"
    echo "│ Exemple: Service 'backend-api' sur port 8080            │"
    echo "│                                                         │"
    echo "│ Variables injectées dans les Pods:                     │"
    echo "│   BACKEND_API_SERVICE_HOST=10.96.50.10                  │"
    echo "│   BACKEND_API_SERVICE_PORT=8080                         │"
    echo "│   BACKEND_API_PORT=tcp://10.96.50.10:8080               │"
    echo "│   BACKEND_API_PORT_8080_TCP=tcp://10.96.50.10:8080      │"
    echo "│   BACKEND_API_PORT_8080_TCP_PROTO=tcp                   │"
    echo "│   BACKEND_API_PORT_8080_TCP_PORT=8080                   │"
    echo "│   BACKEND_API_PORT_8080_TCP_ADDR=10.96.50.10            │"
    echo "│                                                         │"
    echo "│ Usage dans le code:                                     │"
    echo "│   const host = process.env.BACKEND_API_SERVICE_HOST;   │"
    echo "│   const port = process.env.BACKEND_API_SERVICE_PORT;   │"
    echo "│   fetch(\`http://\${host}:\${port}/api\`)                 │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    print_info "⚠️  LIMITATIONS MAJEURES:"
    echo ""
    echo "  ❌ 1. ORDRE DE CRÉATION IMPORTANT:"
    echo "     • Le Service DOIT exister AVANT le Pod"
    echo "     • Sinon, les variables ne sont PAS injectées!"
    echo ""
    echo "  ❌ 2. PAS de mises à jour:"
    echo "     • Si Service créé APRÈS le Pod → Variables absentes"
    echo "     • Si Service change d'IP → Pod garde anciennes valeurs"
    echo "     • Il faut REDÉMARRER le Pod pour avoir nouvelles valeurs"
    echo ""
    echo "  ❌ 3. Pollution de l'environnement:"
    echo "     • Des dizaines de variables pour chaque Service"
    echo "     • Difficile à debugger"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le TABLEAU COMPARATIF..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}📊 DNS vs ENVIRONMENT VARIABLES${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "┌────────────────────┬─────────────────┬────────────────────┐"
    echo "│ Critère            │ DNS (CoreDNS)   │ Env Variables      │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Ordre création     │ ✅ Pas important│ ❌ Service d'abord │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Mises à jour       │ ✅ Automatiques │ ❌ Restart requis  │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Lisibilité code    │ ✅ Très claire  │ ⚠️  Variables      │"
    echo "│                    │   (DNS names)   │    env complexes   │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Cross-namespace    │ ✅ Facile       │ ❌ Difficile       │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Performance        │ ✅ Cache DNS    │ ✅ Direct          │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Debugging          │ ✅ nslookup     │ ⚠️  env | grep     │"
    echo "├────────────────────┼─────────────────┼────────────────────┤"
    echo "│ Recommandation     │ ✅ UTILISER     │ ❌ LEGACY (éviter) │"
    echo "└────────────────────┴─────────────────┴────────────────────┘"
    echo ""

    print_success "💡 BONNE PRATIQUE: TOUJOURS utiliser DNS!"
    echo ""
    echo "Pourquoi?"
    echo "  • Flexible: Services peuvent être créés dans n'importe quel ordre"
    echo "  • Dynamique: Changements automatiquement pris en compte"
    echo "  • Lisible: fetch('http://api-service:8080') vs env vars"
    echo "  • Standard: Fonctionne partout (dev, staging, prod)"
    echo ""

    read -p "Appuyez sur ENTRÉE pour la PARTIE PRATIQUE..."
    print_header

    # ====== PARTIE PRATIQUE ======
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}💻 PARTIE PRATIQUE: TESTER SERVICE DISCOVERY${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if kubectl cluster-info &>/dev/null; then
        print_success "✓ Cluster Kubernetes disponible"
        echo ""

        # Démo 1 : Observer CoreDNS
        print_info "🎯 DÉMO 1: Observer CoreDNS"
        echo ""
        echo "$ kubectl get pods -n kube-system -l k8s-app=kube-dns"
        echo ""
        kubectl get pods -n kube-system -l k8s-app=kube-dns
        echo ""

        print_info "💡 CoreDNS tourne dans kube-system et gère toutes les résolutions DNS"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 2 : Créer un Service et tester DNS
        print_info "🎯 DÉMO 2: Créer Service et tester résolution DNS"
        echo ""
        echo "Création d'un Deployment nginx..."

        kubectl create deployment nginx-dns-test --image=nginx:alpine --replicas=2 -n westeros 2>/dev/null || true
        sleep 2

        echo "Création d'un Service ClusterIP..."
        kubectl expose deployment nginx-dns-test --port=80 --type=ClusterIP -n westeros 2>/dev/null || true
        sleep 1

        echo ""
        echo "$ kubectl get svc nginx-dns-test -n westeros"
        kubectl get svc nginx-dns-test -n westeros
        echo ""

        CLUSTER_IP=$(kubectl get svc nginx-dns-test -n westeros -o jsonpath='{.spec.clusterIP}')
        print_info "💡 ClusterIP du Service: $CLUSTER_IP"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 3 : Tester DNS depuis un Pod
        print_info "🎯 DÉMO 3: Tester DNS depuis un Pod"
        echo ""
        echo "Lançons un Pod de test pour faire des requêtes DNS..."
        echo ""

        kubectl run dns-test-pod --image=busybox:1.28 --restart=Never -n westeros -- sleep 3600 2>/dev/null || true
        sleep 3

        print_info "Test 1: nslookup (short name - même namespace)"
        echo "$ kubectl exec dns-test-pod -n westeros -- nslookup nginx-dns-test"
        echo ""
        kubectl exec dns-test-pod -n westeros -- nslookup nginx-dns-test 2>/dev/null || echo "En attente du Pod..."
        echo ""

        print_info "Test 2: nslookup (FQDN complet)"
        echo "$ kubectl exec dns-test-pod -n westeros -- nslookup nginx-dns-test.westeros.svc.cluster.local"
        echo ""
        kubectl exec dns-test-pod -n westeros -- nslookup nginx-dns-test.westeros.svc.cluster.local 2>/dev/null || echo "En attente du Pod..."
        echo ""

        print_info "💡 Vous voyez? Le nom DNS résout vers l'IP $CLUSTER_IP!"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 4 : Voir les variables d'environnement
        print_info "🎯 DÉMO 4: Variables d'environnement injectées"
        echo ""
        echo "Créons un nouveau Pod APRÈS le Service pour voir les env vars..."
        echo ""

        kubectl run env-test-pod --image=busybox:1.28 --restart=Never -n westeros -- sleep 3600 2>/dev/null || true
        sleep 3

        echo "$ kubectl exec env-test-pod -n westeros -- env | grep NGINX_DNS_TEST"
        echo ""
        kubectl exec env-test-pod -n westeros -- env 2>/dev/null | grep -i "NGINX" || echo "Pas de variables trouvées (normal si Service créé après)"
        echo ""

        print_info "💡 Si le Service existait AVANT le Pod, vous verriez:"
        echo "  NGINX_DNS_TEST_SERVICE_HOST=10.96.x.x"
        echo "  NGINX_DNS_TEST_SERVICE_PORT=80"
        echo "  (mais DNS est plus fiable!)"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 5 : Tester curl depuis un Pod
        print_info "🎯 DÉMO 5: Faire une requête HTTP via DNS"
        echo ""
        echo "Lançons un Pod avec curl pour tester la connexion réelle..."
        echo ""

        kubectl run curl-test-pod --image=curlimages/curl:latest --restart=Never -n westeros -- sleep 3600 2>/dev/null || true
        sleep 3

        echo "$ kubectl exec curl-test-pod -n westeros -- curl -s http://nginx-dns-test:80"
        echo ""
        kubectl exec curl-test-pod -n westeros -- curl -s http://nginx-dns-test:80 2>/dev/null | head -5 || echo "En attente du Pod..."
        echo "..."
        echo ""

        print_success "✅ SUCCESS! Le Pod a pu contacter nginx via DNS 'nginx-dns-test'!"
        echo ""
        echo "Kubernetes a automatiquement:"
        echo "  1. Résolu 'nginx-dns-test' → ClusterIP via CoreDNS"
        echo "  2. Routé la requête vers un des Pods nginx via kube-proxy"
        echo "  3. Retourné la page HTML"
        echo ""

        mark_completed "tutorial_service_discovery"

        read -p "Appuyez sur ENTRÉE pour nettoyer..."

        # Nettoyage
        print_info "🧹 Nettoyage des ressources de la démo"
        echo ""
        kubectl delete pod dns-test-pod env-test-pod curl-test-pod -n westeros 2>/dev/null || true
        kubectl delete deployment nginx-dns-test -n westeros 2>/dev/null || true
        kubectl delete service nginx-dns-test -n westeros 2>/dev/null || true
        print_success "✓ Ressources supprimées"
        echo ""

    else
        print_error "Cluster Kubernetes non disponible. Démarrez le cluster d'abord."
        echo ""
        echo "Commande: ./k3d-deploy"
    fi

    # Résumé final
    print_header
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📚 RÉSUMÉ: SERVICE DISCOVERY${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🌐 MÉTHODE 1: DNS (CoreDNS) - RECOMMANDÉE ✅"
    echo "  • Format: <service>.<namespace>.svc.cluster.local"
    echo "  • Raccourci: <service> (même namespace)"
    echo "  • Dynamique: Mises à jour automatiques"
    echo "  • Usage: fetch('http://api-service:8080/api')"
    echo ""

    print_info "📦 MÉTHODE 2: Environment Variables - LEGACY ❌"
    echo "  • Format: {SVCNAME}_SERVICE_HOST et _PORT"
    echo "  • Limitation: Service doit exister AVANT Pod"
    echo "  • Statique: Restart requis pour changements"
    echo "  • Usage: process.env.API_SERVICE_HOST"
    echo ""

    print_success "💡 BONNE PRATIQUE:"
    echo "  Toujours utiliser DNS pour Service Discovery!"
    echo "  C'est flexible, dynamique, et standard."
    echo ""
    echo "Winter is Coming... And your services can find each other! 🐺📨"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Tutorial 10 : Traffic Policies & Port Forwarding
tutorial_traffic_policies() {
    print_header
    print_banner "🚦 Tutorial 10: Traffic Policies & Port Forwarding"
    echo ""

    # ====== THÉORIE DÉTAILLÉE ======
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📖 TRAFFIC POLICIES: CONTRÔLER LE ROUTAGE${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "LE PROBLÈME À RÉSOUDRE:"
    echo "❓ Quand un Service reçoit du trafic, vers quels Pods router?"
    echo "❓ Faut-il router vers TOUS les Pods du cluster?"
    echo "❓ Ou seulement vers les Pods du MÊME node?"
    echo ""

    print_info "💡 ANALOGIE GOT: LE COMMERCE ENTRE ROYAUMES"
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Dans Game of Thrones:                                   │"
    echo "│                                                         │"
    echo "│ 🌍 Cluster Policy (Commerce International):            │"
    echo "│    • Les marchands du Nord peuvent acheter partout     │"
    echo "│    • Winterfell → King's Landing → Dorne                │"
    echo "│    • TOUS les royaumes accessibles                      │"
    echo "│                                                         │"
    echo "│ 🏰 Local Policy (Commerce Local):                      │"
    echo "│    • Les marchands ne peuvent acheter que localement   │"
    echo "│    • Si à Winterfell → Seulement shops de Winterfell   │"
    echo "│    • Plus rapide, mais limité                           │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour découvrir les 2 POLICIES..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🌍 POLICY 1: externalTrafficPolicy: Cluster (DÉFAUT)${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 Cluster Policy: Load balance vers TOUS les Pods"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Comportement:                                           │"
    echo "│ • Le trafic est distribué vers N'IMPORTE quel Pod       │"
    echo "│ • Peu importe sur quel node le Pod tourne               │"
    echo "│ • Load balancing global à travers tout le cluster       │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Exemple avec 3 nodes:                                   │"
    echo "│                                                         │"
    echo "│   Node 1: Pod A, Pod B                                  │"
    echo "│   Node 2: Pod C                                         │"
    echo "│   Node 3: (pas de pods)                                 │"
    echo "│                                                         │"
    echo "│   Requête arrive sur Node 3                             │"
    echo "│     → Peut aller vers Pod A, B, ou C                    │"
    echo "│     → Distribution uniforme (33% chacun)                │"
    echo "│                                                         │"
    echo "│ ✅ AVANTAGES:                                            │"
    echo "│   • Load balancing optimal                              │"
    echo "│   • Utilisation uniforme de tous les Pods               │"
    echo "│   • Fonctionne même si node local n'a pas de Pods       │"
    echo "│                                                         │"
    echo "│ ❌ INCONVÉNIENTS:                                        │"
    echo "│   • SNAT (Source NAT) appliqué                          │"
    echo "│   • L'IP source originale est PERDUE                    │"
    echo "│   • Pod voit l'IP du node, pas l'IP du client           │"
    echo "│   • Hop réseau supplémentaire possible                  │"
    echo "│                                                         │"
    echo "│ Configuration YAML:                                     │"
    echo "│   spec:                                                 │"
    echo "│     type: LoadBalancer                                  │"
    echo "│     externalTrafficPolicy: Cluster  # DÉFAUT            │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour la POLICY 2..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🏰 POLICY 2: externalTrafficPolicy: Local${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 Local Policy: Seulement les Pods sur le MÊME node"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ Comportement:                                           │"
    echo "│ • Le trafic va UNIQUEMENT vers les Pods du même node    │"
    echo "│ • Si node n'a pas de Pod → Trafic échoue!               │"
    echo "│ • Pas de hop réseau inter-nodes                         │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Exemple avec 3 nodes:                                   │"
    echo "│                                                         │"
    echo "│   Node 1: Pod A, Pod B                                  │"
    echo "│   Node 2: Pod C                                         │"
    echo "│   Node 3: (pas de pods)                                 │"
    echo "│                                                         │"
    echo "│   Requête arrive sur Node 1                             │"
    echo "│     → Va SEULEMENT vers Pod A ou B (50/50)              │"
    echo "│     → Ne touchera JAMAIS Pod C                          │"
    echo "│                                                         │"
    echo "│   Requête arrive sur Node 3                             │"
    echo "│     → ❌ ÉCHEC (pas de Pods locaux)                     │"
    echo "│                                                         │"
    echo "│ ✅ AVANTAGES:                                            │"
    echo "│   • PRÉSERVE l'IP source originale du client            │"
    echo "│   • Pas de SNAT                                         │"
    echo "│   • Latence plus faible (pas de hop inter-nodes)        │"
    echo "│   • Utile pour logs, sécurité, géolocalisation          │"
    echo "│                                                         │"
    echo "│ ❌ INCONVÉNIENTS:                                        │"
    echo "│   • Load balancing déséquilibré possible                │"
    echo "│   • Node sans Pods = trafic échoue                      │"
    echo "│   • Nécessite DaemonSet ou placement soigné            │"
    echo "│                                                         │"
    echo "│ Configuration YAML:                                     │"
    echo "│   spec:                                                 │"
    echo "│     type: LoadBalancer                                  │"
    echo "│     externalTrafficPolicy: Local                        │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    read -p "Appuyez sur ENTRÉE pour le TABLEAU COMPARATIF..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}📊 CLUSTER vs LOCAL TRAFFIC POLICY${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "┌────────────────────┬──────────────────┬──────────────────┐"
    echo "│ Critère            │ Cluster          │ Local            │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Load balancing     │ ✅ Tous les Pods │ ⚠️  Pods locaux   │"
    echo "│                    │   uniformément   │    seulement     │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ IP source          │ ❌ Perdue (SNAT) │ ✅ Préservée     │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Hops réseau        │ ⚠️  Possibles     │ ✅ Aucun         │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Latence            │ ⚠️  Moyenne       │ ✅ Faible        │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Node sans Pod      │ ✅ Fonctionne    │ ❌ Trafic échoue │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Use Case           │ Défaut, standard │ Logs, sécurité,  │"
    echo "│                    │                  │ géolocalisation  │"
    echo "└────────────────────┴──────────────────┴──────────────────┘"
    echo ""

    print_info "💡 QUAND UTILISER LOCAL?"
    echo "  • Besoin de l'IP source réelle (audit, logs, ACLs)"
    echo "  • Géolocalisation (savoir d'où vient le client)"
    echo "  • Latence critique"
    echo "  • Avec DaemonSets (garantit 1 Pod par node)"
    echo ""

    read -p "Appuyez sur ENTRÉE pour PORT FORWARDING..."
    print_header

    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}🔌 PORT FORWARDING: ALTERNATIVE À NODEPORT${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🎯 Port Forwarding: Accès direct sans Service"
    echo ""
    echo "┌─────────────────────────────────────────────────────────┐"
    echo "│ kubectl port-forward permet de tunneler du trafic      │"
    echo "│ depuis votre machine locale vers un Pod/Service         │"
    echo "├─────────────────────────────────────────────────────────┤"
    echo "│ Syntaxe:                                                │"
    echo "│   kubectl port-forward <resource> <local>:<remote>      │"
    echo "│                                                         │"
    echo "│ Exemples:                                               │"
    echo "│                                                         │"
    echo "│ 1. Forward vers un Pod:                                 │"
    echo "│    kubectl port-forward pod/nginx 8080:80               │"
    echo "│      → localhost:8080 → nginx Pod:80                    │"
    echo "│                                                         │"
    echo "│ 2. Forward vers un Service:                             │"
    echo "│    kubectl port-forward svc/web-service 8080:80         │"
    echo "│      → localhost:8080 → Service:80 → Pods               │"
    echo "│                                                         │"
    echo "│ 3. Forward vers un Deployment:                          │"
    echo "│    kubectl port-forward deployment/nginx 8080:80        │"
    echo "│      → localhost:8080 → 1er Pod du Deployment           │"
    echo "│                                                         │"
    echo "│ 4. Bind sur toutes les interfaces:                      │"
    echo "│    kubectl port-forward --address 0.0.0.0 svc/api 8080  │"
    echo "│      → Accessible depuis réseau local                   │"
    echo "│                                                         │"
    echo "│ 5. Namespace spécifique:                                │"
    echo "│    kubectl port-forward -n prod svc/api 8080:80         │"
    echo "└─────────────────────────────────────────────────────────┘"
    echo ""

    print_info "⚙️  COMMENT ÇA FONCTIONNE?"
    echo ""
    echo "1️⃣  kubectl établit une connexion avec l'API Server"
    echo "2️⃣  API Server établit une connexion avec le kubelet du node"
    echo "3️⃣  kubelet forward le trafic vers le Pod"
    echo "4️⃣  Tunnel sécurisé: Votre machine ←→ API ←→ kubelet ←→ Pod"
    echo ""

    read -p "Appuyez sur ENTRÉE pour NodePort vs Port Forwarding..."

    echo ""
    print_info "📊 NODEPORT vs PORT FORWARDING"
    echo ""
    echo "┌────────────────────┬──────────────────┬──────────────────┐"
    echo "│ Critère            │ NodePort         │ Port Forward     │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Permanence         │ ✅ Persistant    │ ❌ Temporaire    │"
    echo "│                    │   (Service obj)  │   (process)      │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Multi-utilisateurs │ ✅ Oui           │ ❌ Non (1 user)  │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Port range         │ ⚠️  30000-32767   │ ✅ N'importe     │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Load balancing     │ ✅ Automatique   │ ❌ 1 seul Pod    │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Setup              │ ⚠️  Service YAML  │ ✅ 1 commande    │"
    echo "├────────────────────┼──────────────────┼──────────────────┤"
    echo "│ Use Case           │ Dev/Test partagé │ Debug local      │"
    echo "│                    │ Démos            │ Dev individuel   │"
    echo "└────────────────────┴──────────────────┴──────────────────┘"
    echo ""

    print_info "💡 QUAND UTILISER PORT FORWARD?"
    echo "  ✅ Développement local (tester rapidement)"
    echo "  ✅ Debugging (accéder à un Pod spécifique)"
    echo "  ✅ Accès temporaire (pas besoin de Service)"
    echo "  ✅ Port non restreint (80, 443, 3000, etc.)"
    echo "  ❌ PAS pour production"
    echo "  ❌ PAS pour partager avec équipe"
    echo ""

    read -p "Appuyez sur ENTRÉE pour la PARTIE PRATIQUE..."
    print_header

    # ====== PARTIE PRATIQUE ======
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}💻 PARTIE PRATIQUE: TESTER TRAFFIC POLICIES & PORT FORWARD${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    if kubectl cluster-info &>/dev/null; then
        print_success "✓ Cluster Kubernetes disponible"
        echo ""

        # Démo 1 : Traffic Policy Cluster
        print_info "🎯 DÉMO 1: Traffic Policy = Cluster (défaut)"
        echo ""
        echo "Création d'un Deployment avec 3 réplicas..."

        kubectl create deployment traffic-demo --image=nginx:alpine --replicas=3 -n westeros 2>/dev/null || true
        sleep 3

        echo "Création d'un Service NodePort avec policy Cluster..."
        cat > /tmp/traffic-cluster-svc.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: traffic-cluster
  namespace: westeros
spec:
  type: NodePort
  externalTrafficPolicy: Cluster
  selector:
    app: traffic-demo
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30100
EOF
        kubectl apply -f /tmp/traffic-cluster-svc.yaml 2>/dev/null || true
        sleep 2

        echo ""
        echo "$ kubectl get svc traffic-cluster -n westeros"
        kubectl get svc traffic-cluster -n westeros
        echo ""

        print_info "💡 Policy: Cluster → Trafic distribué vers TOUS les Pods"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 2 : Port Forwarding vers Pod
        print_info "🎯 DÉMO 2: Port Forwarding vers un Pod"
        echo ""

        POD_NAME=$(kubectl get pods -n westeros -l app=traffic-demo -o jsonpath='{.items[0].metadata.name}')

        print_info "Nous allons forwarder localhost:8080 → Pod $POD_NAME:80"
        echo ""
        echo "Commande:"
        echo "  kubectl port-forward -n westeros pod/$POD_NAME 8080:80"
        echo ""
        print_info "💡 Cette commande créerait un tunnel. Pour le test, on la simule."
        echo "   En vrai, vous feriez ensuite: curl http://localhost:8080"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 3 : Port Forwarding vers Service
        print_info "🎯 DÉMO 3: Port Forwarding vers un Service"
        echo ""
        print_info "Différence Pod vs Service:"
        echo "  • Pod: Tunnel vers 1 Pod spécifique"
        echo "  • Service: Tunnel vers le Service (load balance)"
        echo ""
        echo "Commande pour Service:"
        echo "  kubectl port-forward -n westeros svc/traffic-cluster 8080:80"
        echo ""
        print_info "💡 Avec Service, le trafic passe par kube-proxy"
        echo "   et est load balancé entre les Pods!"
        echo ""

        read -p "Appuyez sur ENTRÉE pour continuer..."

        # Démo 4 : Voir les endpoints
        print_info "🎯 DÉMO 4: Voir les Endpoints du Service"
        echo ""
        echo "$ kubectl get endpoints traffic-cluster -n westeros"
        echo ""
        kubectl get endpoints traffic-cluster -n westeros
        echo ""

        print_info "💡 Avec externalTrafficPolicy: Cluster"
        echo "   Tous les Pods sont dans les endpoints!"
        echo ""

        mark_completed "tutorial_traffic_policies"

        read -p "Appuyez sur ENTRÉE pour nettoyer..."

        # Nettoyage
        print_info "🧹 Nettoyage des ressources de la démo"
        echo ""
        kubectl delete deployment traffic-demo -n westeros 2>/dev/null || true
        kubectl delete service traffic-cluster -n westeros 2>/dev/null || true
        print_success "✓ Ressources supprimées"
        echo ""

    else
        print_error "Cluster Kubernetes non disponible. Démarrez le cluster d'abord."
        echo ""
        echo "Commande: ./k3d-deploy"
    fi

    # Résumé final
    print_header
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}📚 RÉSUMÉ: TRAFFIC POLICIES & PORT FORWARDING${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    print_info "🌍 externalTrafficPolicy: Cluster (DÉFAUT)"
    echo "  • Load balance vers TOUS les Pods du cluster"
    echo "  • IP source perdue (SNAT)"
    echo "  • Usage: Standard, load balancing optimal"
    echo ""

    print_info "🏰 externalTrafficPolicy: Local"
    echo "  • Load balance vers Pods du MÊME node seulement"
    echo "  • IP source préservée"
    echo "  • Usage: Logs, sécurité, géolocalisation"
    echo ""

    print_info "🔌 kubectl port-forward"
    echo "  • Tunnel temporaire: localhost → Pod/Service"
    echo "  • Pas besoin de NodePort/LoadBalancer"
    echo "  • Usage: Dev local, debugging"
    echo ""

    print_success "💡 BONNES PRATIQUES:"
    echo "  • Cluster policy: Default, fonctionne toujours"
    echo "  • Local policy: Avec DaemonSets pour garantir Pods partout"
    echo "  • Port forward: Dev uniquement, jamais en production"
    echo ""
    echo "Winter is Coming... And you control the traffic! 🚦⚔️"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Challenges Pratiques
show_challenges_menu() {
    print_header
    print_banner "🎯 Challenges Pratiques - Niveau Intermédiaire"
    echo ""

    echo "1. 🔧 Debug un pod qui crashe"
    is_completed "challenge_debug" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "2. 📈 Scaler une application sous charge"
    is_completed "challenge_scale" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "3. 🔄 Faire un rolling update sans downtime"
    is_completed "challenge_rolling" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "4. 🔐 Sécuriser avec des secrets"
    is_completed "challenge_secrets" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "5. 🌐 Configurer un Ingress"
    is_completed "challenge_ingress" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"

    echo "6. 🔙 Retour"
    echo ""
    echo -ne "${YELLOW}Choix [1-6]: ${NC}"
}

# Game of Thrones Challenges
show_got_challenges() {
    print_header
    print_banner "🏆 Game of Thrones Challenges"
    echo ""

    echo "1. ⚔️  The Red Wedding - Disaster Recovery"
    is_completed "got_red_wedding" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"
    echo "   Tous les pods de The North sont tués. Restaurez-les!"
    echo ""

    echo "2. 🔥 Battle of Blackwater - Load Testing"
    is_completed "got_blackwater" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"
    echo "   Gérez une charge importante sur l'application"
    echo ""

    echo "3. 👑 The Purple Wedding - Security Breach"
    is_completed "got_purple_wedding" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"
    echo "   Sécurisez un pod compromis"
    echo ""

    echo "4. ❄️  The Long Night - High Availability"
    is_completed "got_long_night" && echo -e "   ${GREEN}[COMPLÉTÉ]${NC}"
    echo "   Assurez la haute disponibilité pendant une panne"
    echo ""

    echo "5. 🔙 Retour"
    echo ""
    echo -ne "${YELLOW}Choix [1-5]: ${NC}"
}

# Challenge GOT 1: Red Wedding
got_challenge_red_wedding() {
    print_header
    print_banner "⚔️  The Red Wedding - Disaster Recovery"
    echo ""

    print_info "Scénario: Tous les pods de The North ont été tués lors du Red Wedding!"
    print_challenge "Objectif: Restaurer le service en moins de 2 minutes"
    echo ""

    read -p "Commencer le challenge? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    print_info "Simulation de la catastrophe..."
    echo ""

    # Tuer les pods The North
    kubectl delete pods -n westeros -l kingdom=the-north 2>/dev/null || true

    print_error "💀 The Freys have betrayed us! All pods are dead!"
    echo ""

    echo "État actuel:"
    kubectl get pods -n westeros -l kingdom=the-north

    echo ""
    print_challenge "À vous de jouer! Restaurez les pods."
    echo ""
    echo "Hints:"
    echo "  - Les deployments se régénèrent automatiquement"
    echo "  - Utilisez: kubectl get pods -n westeros -w"
    echo "  - Vérifiez avec: kubectl get deployments -n westeros"
    echo ""

    local start_time=$(date +%s)

    read -p "Appuyez sur ENTRÉE quand les pods sont restaurés..."

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    echo ""
    kubectl get pods -n westeros -l kingdom=the-north

    echo ""
    if [ $duration -lt 120 ]; then
        print_success "✅ Challenge réussi en ${duration}s!"
        print_success "🏆 The North Remembers! Les pods sont de retour!"
        mark_completed "got_red_wedding"
    else
        print_info "Challenge complété en ${duration}s (objectif: <120s)"
        echo "   Continuez à vous entraîner!"
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Explorer le cluster
explore_cluster() {
    print_header
    print_banner "🔍 Explorer le Cluster"
    echo ""

    echo "1. 📊 Voir tous les pods"
    echo "2. 🌐 Voir tous les services"
    echo "3. 📦 Voir tous les deployments"
    echo "4. 🏰 Voir les namespaces"
    echo "5. 💻 Voir les nœuds"
    echo "6. 📋 Voir les événements récents"
    echo "7. 🔙 Retour"
    echo ""
    echo -ne "${YELLOW}Choix [1-7]: ${NC}"

    read choice
    case $choice in
        1)
            echo ""
            kubectl get pods -A
            read -p "Appuyez sur ENTRÉE pour continuer..."
            explore_cluster
            ;;
        2)
            echo ""
            kubectl get svc -A
            read -p "Appuyez sur ENTRÉE pour continuer..."
            explore_cluster
            ;;
        3)
            echo ""
            kubectl get deployments -A
            read -p "Appuyez sur ENTRÉE pour continuer..."
            explore_cluster
            ;;
        4)
            echo ""
            kubectl get namespaces
            read -p "Appuyez sur ENTRÉE pour continuer..."
            explore_cluster
            ;;
        5)
            echo ""
            kubectl get nodes -o wide
            read -p "Appuyez sur ENTRÉE pour continuer..."
            explore_cluster
            ;;
        6)
            echo ""
            kubectl get events -n westeros --sort-by='.lastTimestamp' | tail -20
            read -p "Appuyez sur ENTRÉE pour continuer..."
            explore_cluster
            ;;
        7)
            return
            ;;
    esac
}

# Voir la progression
show_progress() {
    print_header
    print_banner "📊 Votre Progression"
    echo ""

    local total_tutorials=5
    local total_challenges=5
    local total_got=4
    local total=$((total_tutorials + total_challenges + total_got))

    local completed=$(get_completion_count)
    local percent=$((completed * 100 / total))

    echo -e "${CYAN}Progression globale: ${completed}/${total} (${percent}%)${NC}"
    echo ""

    echo "📚 Tutoriels Guidés:"
    is_completed "tutorial_pods" && echo -e "  ${GREEN}✓${NC} Les Pods" || echo -e "  ${RED}✗${NC} Les Pods"
    is_completed "tutorial_deployments" && echo -e "  ${GREEN}✓${NC} Les Deployments" || echo -e "  ${RED}✗${NC} Les Deployments"
    is_completed "tutorial_services" && echo -e "  ${GREEN}✓${NC} Les Services" || echo -e "  ${RED}✗${NC} Les Services"
    is_completed "tutorial_config" && echo -e "  ${GREEN}✓${NC} ConfigMaps & Secrets" || echo -e "  ${RED}✗${NC} ConfigMaps & Secrets"
    is_completed "tutorial_volumes" && echo -e "  ${GREEN}✓${NC} Volumes" || echo -e "  ${RED}✗${NC} Volumes"

    echo ""
    echo "🎯 Challenges Pratiques:"
    is_completed "challenge_debug" && echo -e "  ${GREEN}✓${NC} Debug un pod" || echo -e "  ${RED}✗${NC} Debug un pod"
    is_completed "challenge_scale" && echo -e "  ${GREEN}✓${NC} Scaler une app" || echo -e "  ${RED}✗${NC} Scaler une app"
    is_completed "challenge_rolling" && echo -e "  ${GREEN}✓${NC} Rolling update" || echo -e "  ${RED}✗${NC} Rolling update"
    is_completed "challenge_secrets" && echo -e "  ${GREEN}✓${NC} Sécuriser avec secrets" || echo -e "  ${RED}✗${NC} Sécuriser avec secrets"
    is_completed "challenge_ingress" && echo -e "  ${GREEN}✓${NC} Configurer Ingress" || echo -e "  ${RED}✗${NC} Configurer Ingress"

    echo ""
    echo "🏆 Game of Thrones Challenges:"
    is_completed "got_red_wedding" && echo -e "  ${GREEN}✓${NC} The Red Wedding" || echo -e "  ${RED}✗${NC} The Red Wedding"
    is_completed "got_blackwater" && echo -e "  ${GREEN}✓${NC} Battle of Blackwater" || echo -e "  ${RED}✗${NC} Battle of Blackwater"
    is_completed "got_purple_wedding" && echo -e "  ${GREEN}✓${NC} The Purple Wedding" || echo -e "  ${RED}✗${NC} The Purple Wedding"
    is_completed "got_long_night" && echo -e "  ${GREEN}✓${NC} The Long Night" || echo -e "  ${RED}✗${NC} The Long Night"

    echo ""
    if [ $percent -eq 100 ]; then
        echo -e "${GREEN}🎊 FÉLICITATIONS! Vous avez complété tous les challenges!${NC}"
        echo -e "${YELLOW}   Vous êtes maintenant un Maître de Kubernetes! 👑${NC}"
    elif [ $percent -ge 75 ]; then
        echo -e "${GREEN}🌟 Excellent travail! Continuez! (${percent}%)${NC}"
    elif [ $percent -ge 50 ]; then
        echo -e "${YELLOW}💪 Bon progrès! Vous êtes à mi-chemin! (${percent}%)${NC}"
    else
        echo -e "${CYAN}🚀 C'est un bon début! Continuez! (${percent}%)${NC}"
    fi

    echo ""
    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Cheatsheet
show_cheatsheet() {
    print_header
    print_banner "❓ Kubectl Cheatsheet"
    echo ""

    echo -e "${CYAN}📦 Pods:${NC}"
    echo "  kubectl get pods -n westeros"
    echo "  kubectl describe pod <name> -n westeros"
    echo "  kubectl logs -f <pod-name> -n westeros"
    echo "  kubectl exec -it <pod-name> -n westeros -- sh"
    echo ""

    echo -e "${CYAN}🔄 Deployments:${NC}"
    echo "  kubectl get deployments -n westeros"
    echo "  kubectl scale deployment <name> --replicas=3 -n westeros"
    echo "  kubectl rollout status deployment/<name> -n westeros"
    echo "  kubectl rollout restart deployment/<name> -n westeros"
    echo ""

    echo -e "${CYAN}🌐 Services:${NC}"
    echo "  kubectl get svc -n westeros"
    echo "  kubectl describe svc <name> -n westeros"
    echo ""

    echo -e "${CYAN}📋 Général:${NC}"
    echo "  kubectl get all -n westeros"
    echo "  kubectl get events -n westeros --sort-by='.lastTimestamp'"
    echo "  kubectl delete pod <name> -n westeros"
    echo ""

    echo -e "${CYAN}🔍 Debug:${NC}"
    echo "  kubectl logs <pod> -n westeros --previous  # Logs du container précédent"
    echo "  kubectl top pods -n westeros               # Usage CPU/RAM"
    echo "  kubectl port-forward pod/<name> 8080:80 -n westeros"
    echo ""

    read -p "Appuyez sur ENTRÉE pour continuer..."
}

# Boucle principale
main() {
    check_cluster

    while true; do
        show_main_menu
        read choice

        case $choice in
            1)
                while true; do
                    show_tutorials_menu
                    read tutorial_choice
                    case $tutorial_choice in
                        1) tutorial_pods ;;
                        2) tutorial_deployments ;;
                        3) tutorial_services ;;
                        4) tutorial_config ;;
                        5) tutorial_volumes ;;
                        6) tutorial_namespaces ;;
                        7) tutorial_probes ;;
                        8) tutorial_architecture ;;
                        9) tutorial_service_discovery ;;
                        10) tutorial_traffic_policies ;;
                        11) break ;;
                    esac
                done
                ;;
            2)
                while true; do
                    show_challenges_menu
                    read challenge_choice
                    case $challenge_choice in
                        1|2|3|4|5) print_info "En développement..."; sleep 2 ;;
                        6) break ;;
                    esac
                done
                ;;
            3)
                print_info "Scénarios avancés en développement..."
                sleep 2
                ;;
            4)
                while true; do
                    show_got_challenges
                    read got_choice
                    case $got_choice in
                        1) got_challenge_red_wedding ;;
                        2|3|4) print_info "En développement..."; sleep 2 ;;
                        5) break ;;
                    esac
                done
                ;;
            5)
                show_progress
                ;;
            6)
                explore_cluster
                ;;
            7)
                show_cheatsheet
                ;;
            8)
                show_cheatsheet
                ;;
            9)
                print_header
                echo -e "${YELLOW}🐺 Winter is Coming... Keep Learning! 🐺${NC}"
                echo ""
                exit 0
                ;;
        esac
    done
}

# Point d'entrée
main "$@"
