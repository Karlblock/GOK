# Guide d'installation GOK8S

Ce guide vous aidera à installer et configurer votre environnement GOK8S.

## Table des matières

1. [Prérequis](#prérequis)
2. [Installation des dépendances](#installation-des-dépendances)
3. [Déploiement des labs](#déploiement-des-labs)
4. [Vérification](#vérification)
5. [Dépannage](#dépannage)

## Prérequis

### Configuration matérielle minimale

- **Pour MINILAB:**
  - 4 Go RAM
  - 2 CPU cores
  - 20 Go d'espace disque

- **Pour K8S-CLUSTER ou DOCKER-SWARM:**
  - 8 Go RAM (16 Go recommandé)
  - 4 CPU cores
  - 40 Go d'espace disque

- **Pour TOUS les labs simultanément:**
  - 16 Go RAM minimum
  - 8 CPU cores
  - 80 Go d'espace disque

### Systèmes d'exploitation supportés

- Ubuntu 20.04 LTS ou supérieur
- Debian 11 ou supérieur
- Fedora 35 ou supérieur
- macOS 11 (Big Sur) ou supérieur
- Windows 10/11 avec WSL2

## Installation des dépendances

### Ubuntu/Debian

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation de VirtualBox
sudo apt install -y virtualbox virtualbox-ext-pack

# Installation de Vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant

# Installation d'Ansible (optionnel)
sudo apt install -y ansible

# Vérification
vagrant --version
vboxmanage --version
ansible --version
```

### Fedora/RHEL/CentOS

```bash
# Installation de VirtualBox
sudo dnf install -y @development-tools
sudo dnf install -y kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras
sudo dnf install -y VirtualBox

# Installation de Vagrant
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install -y vagrant

# Installation d'Ansible (optionnel)
sudo dnf install -y ansible

# Vérification
vagrant --version
vboxmanage --version
```

### macOS

```bash
# Installation via Homebrew
brew install --cask virtualbox
brew install --cask vagrant
brew install ansible

# Vérification
vagrant --version
vboxmanage --version
ansible --version
```

### Windows (avec WSL2)

1. Installer WSL2 et Ubuntu depuis le Microsoft Store
2. Dans WSL2, suivre les instructions Ubuntu ci-dessus
3. Ou installer VirtualBox et Vagrant directement sur Windows

## Déploiement des labs

### Méthode 1 : Script d'installation automatique

```bash
cd GOK8S
./scripts/install.sh
```

Le script vous proposera de choisir le lab à déployer.

### Méthode 2 : Déploiement manuel

#### K8S-CLUSTER (Cluster Kubernetes)

```bash
cd GOK8S/vagrant/k8s-cluster
vagrant up
```

Le déploiement prend environ 15-20 minutes.

#### DOCKER-SWARM

```bash
cd GOK8S/vagrant/docker-swarm
vagrant up
```

Le déploiement prend environ 10-15 minutes.

#### MINILAB

```bash
cd GOK8S/vagrant/minilab
vagrant up
```

Le déploiement prend environ 5-10 minutes.

## Vérification

### Vérifier K8S-CLUSTER

```bash
# SSH dans le master
cd vagrant/k8s-cluster
vagrant ssh master

# Vérifier les nœuds
kubectl get nodes

# Devrait afficher:
# NAME          STATUS   ROLES           AGE   VERSION
# k8s-master    Ready    control-plane   5m    v1.28.0
# k8s-worker1   Ready    <none>          3m    v1.28.0
# k8s-worker2   Ready    <none>          2m    v1.28.0

# Vérifier les pods système
kubectl get pods --all-namespaces

# Déployer une application de test
kubectl apply -f /vagrant/../../manifests/k8s/apps/nginx-deployment.yaml
kubectl get pods
```

### Vérifier DOCKER-SWARM

```bash
# SSH dans le manager
cd vagrant/docker-swarm
vagrant ssh manager

# Vérifier les nœuds
docker node ls

# Devrait afficher 3 nœuds (1 manager, 2 workers)

# Vérifier les services
docker service ls

# Accéder aux interfaces web
# Portainer: http://192.168.56.30:9000
# Visualizer: http://192.168.56.30:8080
```

### Vérifier MINILAB

```bash
# SSH dans le minilab
cd vagrant/minilab
vagrant ssh minilab

# Vérifier K3s
kubectl get nodes

# Vérifier Docker
docker ps

# Accéder à Portainer: http://192.168.56.50:9000
```

## Configuration post-installation

### Accéder au Dashboard Kubernetes

```bash
# Récupérer le token
cd vagrant/k8s-cluster
cat dashboard-token.txt

# Dans une autre fenêtre, créer un tunnel
vagrant ssh master -- -L 8001:localhost:8001
kubectl proxy

# Ouvrir dans le navigateur:
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

### Configurer kubectl local

Pour accéder au cluster depuis votre machine hôte :

```bash
# Copier le kubeconfig
cd vagrant/k8s-cluster
vagrant ssh master -c 'cat /home/vagrant/.kube/config' > ~/.kube/gok8s-config

# Modifier l'IP dans le fichier
sed -i 's/127.0.0.1/192.168.56.10/g' ~/.kube/gok8s-config

# Utiliser le config
export KUBECONFIG=~/.kube/gok8s-config
kubectl get nodes
```

## Commandes utiles

### Gestion des VMs

```bash
# Voir le statut
vagrant status

# Arrêter les VMs
vagrant halt

# Redémarrer
vagrant reload

# Détruire (supprime tout)
vagrant destroy -f

# Provisionner à nouveau
vagrant provision

# SSH dans une VM spécifique
vagrant ssh master
vagrant ssh worker1
```

### Snapshots (sauvegardes)

```bash
# Créer un snapshot
vagrant snapshot save nom_du_snapshot

# Lister les snapshots
vagrant snapshot list

# Restaurer un snapshot
vagrant snapshot restore nom_du_snapshot

# Supprimer un snapshot
vagrant snapshot delete nom_du_snapshot
```

## Dépannage

Consultez [troubleshooting.md](troubleshooting.md) pour les problèmes courants et leurs solutions.

## Prochaines étapes

Une fois l'installation terminée, consultez :

- [Scénarios d'apprentissage](scenarios/) pour des exercices pratiques
- [Guide d'utilisation](usage.md) pour les commandes courantes
- [Documentation Kubernetes](https://kubernetes.io/docs/)
- [Documentation Docker Swarm](https://docs.docker.com/engine/swarm/)
