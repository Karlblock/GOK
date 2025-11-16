# GOK8S - Game Of Kubernetes & Container Orchestration

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos-lightgrey.svg)

**GOK8S** est un laboratoire d'apprentissage pratique pour Kubernetes et l'orchestration de conteneurs. Inspiré par [GOAD](https://github.com/Orange-Cyberdefense/GOAD), ce projet fournit un environnement éducatif complet avec :

- **Kubernetes (K8s)** via kind (Kubernetes IN Docker)
- **Applications réelles** thème Game of Thrones
- **Déploiement rapide** : 30-60 secondes vs 20-25 minutes avec Vagrant
- **Scénarios progressifs** d'apprentissage

## GOTK8S - Game Of Thrones Kubernetes

**Nouveau !** Un environnement d'apprentissage immersif basé sur l'univers Game of Thrones avec des applications réelles pour apprendre Kubernetes.

**[Voir GOTK8S_PROJECT.md](GOTK8S_PROJECT.md)** pour l'architecture complète
**[Quick Start GOTK8S](GOTK8S_QUICKSTART.md)** pour déployer The North
**[Scénario 1: Winter is Coming](scenarios/01-winter-is-coming/README.md)** - Premier tutoriel complet

### Les Sept Royaumes (Microservices)

- **The North** 🐺 - Système de messagerie (Ravens) - [DISPONIBLE]
- **Dorne** ☀️ - Service de commerce - [EN DÉVELOPPEMENT]
- **The Reach** 🌹 - Gestion des ressources - [PLANIFIÉ]
- **The Vale** 🦅 - Authentification - [PLANIFIÉ]
- Et plus encore...

## Architecture

Le projet utilise **kind** (Kubernetes IN Docker) pour un déploiement rapide et stable :

### Cluster Kubernetes avec kind
- **1 nœud control-plane** : Orchestration du cluster
- **2 nœuds worker** : Exécution des applications
- **Réseau** : Configuration automatique par kind
- **NodePort mapping** : Accès facile aux services (30100, 30101, etc.)
- **Temps de démarrage** : 30-60 secondes ⚡

## Prérequis

### Logiciels requis

- [Docker](https://docs.docker.com/get-docker/) >= 20.10
- [kind](https://kind.sigs.k8s.io/) >= 0.20 (Kubernetes IN Docker)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.28
- Au moins 8 Go de RAM disponible
- 20 Go d'espace disque libre

### Système d'exploitation

- Linux (Ubuntu 20.04+, Debian 11+, Fedora 35+)
- macOS 11+
- Windows 10/11 avec WSL2

## Installation rapide

### Méthode 1 : Scripts automatiques (RECOMMANDÉ) ⚡

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/GOK8S.git
cd GOK8S

# 2. Déployer tout en une commande
./gok-deploy.sh

# 3. Accéder aux services
firefox http://localhost:30100  # Frontend
curl http://localhost:30101     # API
```

**Durée totale : 3-5 minutes**

Voir [QUICKSTART.md](QUICKSTART.md) pour plus de détails.

### Méthode 2 : Manuelle

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/GOK8S.git
cd GOK8S

# 2. Créer le cluster (1 control-plane + 2 workers)
cd kind
kind create cluster --config cluster-config.yaml

# 3. Vérifier le cluster
kubectl get nodes

# 4. Construire et charger les images
cd ../kingdoms
bash build-images.sh
kind load docker-image gotk8s/the-north-api:1.0 --name gotk8s
kind load docker-image gotk8s/the-north-frontend:1.0 --name gotk8s

# 5. Déployer GOTK8S
kubectl apply -f ../manifests/gotk8s/

# 6. Accéder aux services
curl http://localhost:30100  # Frontend
curl http://localhost:30101  # API
```

## Structure du projet

```
GOK8S/
├── README.md
├── LICENSE
├── .gitignore
├── kind/
│   └── cluster-config.yaml     # Configuration cluster kind (1 control-plane + 2 workers)
├── kingdoms/
│   ├── the-north/              # Application The North (Ravens messaging)
│   │   ├── api/                # Backend Node.js + Socket.IO
│   │   └── frontend/           # Frontend HTML/JS
│   ├── build-images.sh         # Construction images Docker
│   └── load-images-to-k8s.sh   # Chargement images dans kind
├── manifests/
│   └── gotk8s/                 # Manifestes Kubernetes
│       ├── 00-namespace/       # Namespace + quotas
│       ├── 01-redis/           # Redis deployment
│       ├── 02-the-north/       # API + Frontend
│       └── 03-ingress/         # Services NodePort
├── scenarios/
│   └── 01-winter-is-coming/    # Scénario 1 - Tutorial complet
├── docs/
│   ├── CHANGELOG.md            # Historique des versions
│   └── troubleshooting.md
├── GUIDE_ENSEIGNANT.md         # Guide pour enseignants
├── GUIDE_ETUDIANT.md           # Guide pour étudiants
└── GOTK8S_PROJECT.md           # Architecture complète
```

## Scénarios d'apprentissage

Le lab inclut plusieurs scénarios progressifs :

1. **Déploiement de base** : Déployer votre première application
2. **Scaling** : Augmenter/réduire le nombre de replicas
3. **Load Balancing** : Configuration de services et ingress
4. **Persistence** : Volumes et stockage persistant
5. **Networking** : Politiques réseau et CNI
6. **Monitoring** : Prometheus, Grafana
7. **CI/CD** : Pipeline avec GitLab/Jenkins

## Configuration avancée

### Personnaliser le cluster kind

Éditez le fichier [kind/cluster-config.yaml](kind/cluster-config.yaml) :

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30100
    hostPort: 30100
  - containerPort: 30101
    hostPort: 30101
- role: worker
- role: worker
- role: worker  # Ajouter un 3ème worker
```

### Utiliser une VM pré-configurée

Téléchargez la VM **GOK v1.0** (4.4GB) avec tout pré-installé :
- Ubuntu 24.04 + Docker + kind + kubectl
- Projet GOK8S complet
- Images Docker pré-chargées
- Prêt en 2 minutes après import

Voir [docs/CHANGELOG.md](docs/CHANGELOG.md) pour les détails.

## Scripts de Gestion

Le projet inclut des scripts pour faciliter la gestion :

| Script | Description | Durée |
|--------|-------------|-------|
| `./gok-deploy.sh` | Déploiement complet (cluster + apps) | 3-5 min |
| `./gok-start.sh` | Vérifier l'environnement existant | 5 sec |
| `./gok-status.sh` | Rapport d'état complet | 10 sec |
| `./gok-cleanup.sh` | Supprimer cluster et images | 30 sec |
| `./gok-learn.sh` | 🎓 CLI interactif d'apprentissage | - |

### 🎓 Apprentissage Interactif (NOUVEAU!)

```bash
./gok-learn.sh
```

Un CLI interactif pour apprendre Kubernetes de manière ludique avec :
- 📚 Tutoriels guidés (Pods, Deployments, Services)
- 🎯 Challenges pratiques
- 🏆 Game of Thrones Challenges (The Red Wedding, etc.)
- 📊 Système de progression
- 🔍 Explorateur de cluster

Voir [LEARNING_CLI.md](LEARNING_CLI.md) pour les détails.

Voir aussi [QUICKSTART.md](QUICKSTART.md) pour les autres scripts.

## Commandes utiles

```bash
# Gestion avec scripts
./gok-deploy.sh        # Créer et déployer tout
./gok-status.sh        # Voir l'état complet
./gok-cleanup.sh       # Tout supprimer

# Commandes kind
kind get clusters              # Voir les clusters
kind delete cluster --name gotk8s   # Supprimer le cluster

# Commandes kubectl
kubectl get pods -A            # Voir tous les pods
kubectl get nodes              # Voir les nœuds
kubectl get all -n westeros    # Voir les ressources GOTK8S
```

## 📚 Documentation

Voir **[docs/INDEX.md](docs/INDEX.md)** pour l'index complet de la documentation.

**Documents clés** :
- **[CHEATSHEET.md](CHEATSHEET.md)** - Commandes rapides ⚡
- **[K3D_VS_KIND.md](K3D_VS_KIND.md)** - k3d vs kind (multi-node)
- **[docs/LEARNING_CLI.md](docs/LEARNING_CLI.md)** - CLI interactif d'apprentissage
- **[docs/KUBERNETES_DASHBOARD.md](docs/KUBERNETES_DASHBOARD.md)** - Guide du Dashboard Kubernetes 📊
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Démarrage rapide

## Dépannage

- **[docs/TROUBLESHOOTING_KIND.md](docs/TROUBLESHOOTING_KIND.md)** - Problème multi-node kind
- **[docs/FIX_MULTINODE.md](docs/FIX_MULTINODE.md)** - Solutions multi-node
- **[docs/troubleshooting.md](docs/troubleshooting.md)** - Dépannage général

## Contribuer

Les contributions sont les bienvenues ! Voir [CONTRIBUTING.md](CONTRIBUTING.md).

## Avertissement

Ce laboratoire est conçu exclusivement à des fins éducatives et de test. Ne l'utilisez jamais en production ou exposé sur Internet sans sécurisation appropriée.

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Remerciements

- Inspiré par [GOAD](https://github.com/Orange-Cyberdefense/GOAD) d'Orange Cyberdefense
- Communauté Kubernetes
- Communauté Docker

## Ressources

- [Documentation Kubernetes](https://kubernetes.io/docs/)
- [Documentation kind](https://kind.sigs.k8s.io/)
- [Documentation Docker](https://docs.docker.com/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
