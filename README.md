# GOK8S - Game Of Kubernetes & Container Orchestration

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos-lightgrey.svg)

**GOK8S** est un laboratoire d'apprentissage pratique pour Kubernetes et l'orchestration de conteneurs. Inspiré par [GOAD](https://github.com/Orange-Cyberdefense/GOAD), ce projet fournit un environnement éducatif complet avec :

- **Kubernetes (K8s)** via k3d (k3s in docker) - Multi-node fonctionnel
- **Applications réelles** thème Game of Thrones
- **Déploiement rapide** : 2-3 minutes pour un cluster complet
- **Scénarios progressifs** d'apprentissage
- **CLI interactif** pour apprendre de manière ludique

> **📖 Nouveau ?** Commencez par [START_HERE.md](START_HERE.md) pour un démarrage ultra-rapide !

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

Le projet utilise **k3d** (k3s in docker) pour un déploiement rapide et multi-node stable :

### Cluster Kubernetes avec k3d
- **1 nœud server** : Control-plane léger (k3s)
- **2 nœuds agent** : Workers pour exécuter les applications
- **Multi-node fonctionnel** : Compatible cgroup v2
- **Réseau** : Configuration automatique avec NodePort mapping
- **Ports exposés** : 30100 (Frontend), 30101 (API)
- **Temps de démarrage** : 2-3 minutes ⚡

> **Note** : kind était utilisé précédemment mais rencontrait des problèmes multi-node avec cgroup v2. Voir [K3D_VS_KIND.md](K3D_VS_KIND.md) pour plus de détails.

## Prérequis

### Logiciels requis

- [Docker](https://docs.docker.com/get-docker/) >= 20.10
- [k3d](https://k3d.io/) >= 5.6.0 (k3s in docker)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.28
- Au moins 4 Go de RAM disponible (k3s est plus léger que k8s)
- 10 Go d'espace disque libre

> **Installation k3d** :
> ```bash
> mkdir -p ~/bin
> curl -Lo ~/bin/k3d https://github.com/k3d-io/k3d/releases/download/v5.6.0/k3d-linux-amd64
> chmod +x ~/bin/k3d
> ```

### Système d'exploitation

- Linux (Ubuntu 20.04+, Debian 11+, Fedora 35+)
- macOS 11+
- Windows 10/11 avec WSL2

## Installation rapide

### Méthode 1 : Démarrage Ultra-Rapide (RECOMMANDÉ) ⚡

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/GOK8S.git
cd GOK8S

# 2. Déployer le cluster multi-node avec k3d
./k3d-deploy

# 3. Lancer le CLI d'apprentissage interactif
./gok-learn
```

**Durée totale : 2-3 minutes**

> **📖 Pour plus de détails** : Voir [START_HERE.md](START_HERE.md)

### Méthode 2 : Manuelle avec k3d

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/GOK8S.git
cd GOK8S

# 2. Créer le cluster k3d (1 server + 2 agents)
k3d cluster create gotk8s \
  --servers 1 \
  --agents 2 \
  --port "30100:30100@server:0" \
  --port "30101:30101@server:0"

# 3. Vérifier le cluster
kubectl get nodes

# 4. Construire et charger les images
cd kingdoms
bash build-images.sh
k3d image import gotk8s/the-north-api:1.0 -c gotk8s
k3d image import gotk8s/the-north-frontend:1.0 -c gotk8s

# 5. Déployer GOTK8S
kubectl apply -f ../manifests/gotk8s/

# 6. Accéder aux services
curl http://localhost:30100  # Frontend
curl http://localhost:30101  # API
```

## Structure du projet

```
GOK8S/
├── START_HERE.md               # 🎯 Point d'entrée - Commencez ici !
├── README.md                   # Documentation principale
├── LICENSE
├── .gitignore
│
├── k3d-deploy                  # 🚀 Lien vers scripts/k3d-deploy.sh
├── k3d-cleanup                 # 🧹 Lien vers scripts/k3d-cleanup.sh
├── gok-learn                   # 🎓 Lien vers scripts/gok-learn.sh
├── dashboard-access            # 📊 Script accès Dashboard K8s
│
├── scripts/                    # Scripts de gestion
│   ├── k3d-deploy.sh          # Déploiement k3d (RECOMMANDÉ)
│   ├── k3d-cleanup.sh         # Nettoyage k3d
│   ├── gok-learn.sh           # CLI interactif d'apprentissage
│   ├── gok-deploy.sh          # Déploiement kind (legacy)
│   ├── gok-status.sh          # Status du cluster
│   └── gok-cleanup.sh         # Nettoyage kind
│
├── kingdoms/                   # Code source des applications
│   ├── the-north/             # Application The North (Ravens)
│   │   ├── api/               # Backend Node.js + Socket.IO
│   │   └── frontend/          # Frontend HTML/JS
│   ├── build-images.sh        # Construction images Docker
│   └── load-images-to-k8s.sh  # Chargement images
│
├── manifests/                  # Manifestes Kubernetes
│   └── gotk8s/                # Manifestes GOTK8S
│       ├── 00-namespace/      # Namespace + quotas
│       ├── 01-redis/          # Redis deployment
│       ├── 02-the-north/      # API + Frontend
│       └── 03-ingress/        # Services NodePort
│
├── scenarios/                  # Scénarios d'apprentissage
│   └── 01-winter-is-coming/   # Scénario 1 - Tutorial
│
├── kind/                       # Configuration kind (legacy)
│   └── cluster-config.yaml    # Config kind (problèmes multi-node)
│
└── docs/                       # Documentation complète
    ├── INDEX.md               # Index complet
    ├── CHEATSHEET.md          # Commandes rapides
    ├── K3D_VS_KIND.md         # Comparaison k3d vs kind
    ├── LEARNING_CLI.md        # Guide CLI interactif
    ├── KUBERNETES_DASHBOARD.md # Guide Dashboard
    ├── TROUBLESHOOTING_KIND.md # Dépannage kind
    └── ...
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

### Personnaliser le cluster k3d

Modifier le script [scripts/k3d-deploy.sh](scripts/k3d-deploy.sh) pour ajuster :

```bash
# Exemple : Ajouter un 3ème agent (worker)
k3d cluster create gotk8s \
  --servers 1 \
  --agents 3 \    # Au lieu de 2
  --port "30100:30100@server:0" \
  --port "30101:30101@server:0"
```

### Accéder au Dashboard Kubernetes

```bash
# Lancer le script d'accès au dashboard
./dashboard-access
```

Voir [docs/KUBERNETES_DASHBOARD.md](docs/KUBERNETES_DASHBOARD.md) pour plus de détails.

### Utiliser kind (legacy)

Si vous préférez kind malgré les limitations multi-node :

```bash
./scripts/gok-deploy.sh  # Utilise kind au lieu de k3d
```

> **Note** : kind a des problèmes multi-node avec cgroup v2. Voir [docs/TROUBLESHOOTING_KIND.md](docs/TROUBLESHOOTING_KIND.md)

## Scripts de Gestion

Le projet inclut des scripts pour faciliter la gestion :

### Scripts k3d (RECOMMANDÉS) 🚀

| Script | Description | Durée |
|--------|-------------|-------|
| `./k3d-deploy` | Déploiement k3d multi-node complet | 2-3 min |
| `./k3d-cleanup` | Supprimer cluster k3d et images | 30 sec |
| `./gok-learn` | 🎓 CLI interactif d'apprentissage | - |
| `./dashboard-access` | 📊 Accès au Dashboard Kubernetes | 30 sec |

### Scripts kind (legacy)

| Script | Description | Durée |
|--------|-------------|-------|
| `./scripts/gok-deploy.sh` | Déploiement kind (problèmes multi-node) | 3-5 min |
| `./scripts/gok-status.sh` | Rapport d'état complet | 10 sec |
| `./scripts/gok-cleanup.sh` | Supprimer cluster kind et images | 30 sec |

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

Voir aussi [START_HERE.md](START_HERE.md) pour un guide de démarrage rapide.

## Commandes utiles

```bash
# Gestion avec scripts k3d
./k3d-deploy           # Créer et déployer tout
./k3d-cleanup          # Tout supprimer
./gok-learn            # CLI d'apprentissage
./dashboard-access     # Accéder au Dashboard

# Commandes k3d
k3d cluster list                    # Voir les clusters
k3d cluster delete gotk8s           # Supprimer le cluster
k3d image import <image> -c gotk8s  # Charger une image

# Commandes kubectl
kubectl get pods -A            # Voir tous les pods
kubectl get nodes              # Voir les nœuds (1 server + 2 agents)
kubectl get all -n westeros    # Voir les ressources GOTK8S
```

## 📚 Documentation

### Point d'entrée
- **[START_HERE.md](START_HERE.md)** - 🎯 Commencez ici pour un démarrage ultra-rapide !

### Documentation complète
Voir **[docs/INDEX.md](docs/INDEX.md)** pour l'index complet.

**Documents essentiels** :
- **[docs/CHEATSHEET.md](docs/CHEATSHEET.md)** - Commandes kubectl rapides ⚡
- **[K3D_VS_KIND.md](K3D_VS_KIND.md)** - Pourquoi k3d ? Comparaison détaillée
- **[docs/LEARNING_CLI.md](docs/LEARNING_CLI.md)** - Guide du CLI interactif 🎓
- **[docs/KUBERNETES_DASHBOARD.md](docs/KUBERNETES_DASHBOARD.md)** - Dashboard Kubernetes 📊

## Dépannage

- **[docs/TROUBLESHOOTING_KIND.md](docs/TROUBLESHOOTING_KIND.md)** - Problèmes multi-node kind
- **[docs/FIX_MULTINODE.md](docs/FIX_MULTINODE.md)** - Solutions multi-node
- **[K3D_VS_KIND.md](K3D_VS_KIND.md)** - Pourquoi nous sommes passés à k3d

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
- [Documentation k3d](https://k3d.io/)
- [Documentation k3s](https://docs.k3s.io/)
- [Documentation Docker](https://docs.docker.com/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Changelog

### v2.0 - Migration vers k3d
- ✅ Migration de kind vers k3d pour support multi-node stable
- ✅ Support complet cgroup v2
- ✅ 1 server + 2 agents fonctionnels
- ✅ Ajout du Dashboard Kubernetes
- ✅ Amélioration des performances (k3s plus léger que k8s)
- ✅ Scripts simplifiés avec liens symboliques
- ✅ Ajout de START_HERE.md pour démarrage rapide

### v1.0 - Version initiale avec kind
- ⚠️ Problèmes multi-node avec cgroup v2
- ⚠️ kind conservé pour compatibilité (scripts legacy)
