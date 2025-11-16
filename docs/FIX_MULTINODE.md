# Fix Multi-Node kind avec cgroup v2

## Diagnostic du Problème

Ton système utilise **cgroup v2** par défaut, ce qui cause des problèmes avec kubeadm dans les workers kind.

Vérifier :
```bash
docker info | grep "Cgroup Version"
# Si tu vois "Cgroup Version: 2" → c'est le problème
```

## Solutions (par ordre de préférence)

---

## ✅ Solution 1 : Utiliser k3d (Alternative à kind)

**k3d** est comme kind mais utilise **k3s** au lieu de kubeadm, ce qui fonctionne avec cgroup v2.

### Installation

```bash
# Installer k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Créer un cluster multi-node
k3d cluster create gotk8s \
  --servers 1 \
  --agents 2 \
  -p "30100:30100@loadbalancer" \
  -p "30101:30101@loadbalancer"

# Vérifier
kubectl get nodes
```

### Avantages
- ✅ Fonctionne avec cgroup v2
- ✅ Plus rapide que kind
- ✅ Même API que kind
- ✅ Compatible avec les manifests GOTK8S

### Désavantages
- ⚠️ Utilise k3s au lieu de kubeadm (légèrement différent)

---

## ✅ Solution 2 : Forcer Docker à utiliser cgroup v1

### Étape 1 : Modifier la config Docker

```bash
# Éditer /etc/docker/daemon.json
sudo nano /etc/docker/daemon.json
```

Ajouter cette ligne :
```json
{
  "default-address-pools": [
    {
      "base": "10.10.0.0/16",
      "size": 24
    }
  ],
  "bip": "10.10.0.1/24",
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
```

### Étape 2 : Redémarrer Docker

```bash
sudo systemctl restart docker
```

### Étape 3 : Vérifier

```bash
docker info | grep "Cgroup Driver"
# Devrait afficher: Cgroup Driver: cgroupfs
```

### Étape 4 : Recréer le cluster kind

```bash
kind delete cluster --name gotk8s
kind create cluster --config kind/cluster-config.yaml
```

### Avantages
- ✅ Fonctionne avec kind
- ✅ Pas de changement d'outil

### Désavantages
- ⚠️ Nécessite sudo
- ⚠️ Affecte tous les conteneurs Docker

---

## ✅ Solution 3 : Forcer cgroup v1 au niveau système (Kernel)

### Étape 1 : Modifier GRUB

```bash
sudo nano /etc/default/grub
```

Modifier la ligne `GRUB_CMDLINE_LINUX_DEFAULT` :
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet systemd.unified_cgroup_hierarchy=0"
```

### Étape 2 : Mettre à jour GRUB

```bash
sudo update-grub
```

### Étape 3 : Redémarrer

```bash
sudo reboot
```

### Étape 4 : Vérifier après reboot

```bash
cat /proc/cmdline | grep cgroup
docker info | grep "Cgroup Version"
```

### Étape 5 : Recréer le cluster

```bash
kind delete cluster --name gotk8s
kind create cluster --config kind/cluster-config.yaml
```

### Avantages
- ✅ Résout le problème à la racine
- ✅ Fonctionne pour tous les outils

### Désavantages
- ⚠️ Nécessite sudo + reboot
- ⚠️ Affecte tout le système
- ⚠️ Peut casser d'autres outils qui nécessitent cgroup v2

---

## ✅ Solution 4 : Utiliser une version plus récente de kind

Les versions récentes de kind ont des meilleurs workarounds pour cgroup v2.

```bash
# Installer la dernière version
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Vérifier
kind --version

# Essayer avec une image Kubernetes plus récente
```

Modifier `kind/cluster-config.yaml` :
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: gotk8s
nodes:
  - role: control-plane
    image: kindest/node:v1.31.0  # Version plus récente
    extraPortMappings:
      - containerPort: 30100
        hostPort: 30100
      - containerPort: 30101
        hostPort: 30101

  - role: worker
    image: kindest/node:v1.31.0

  - role: worker
    image: kindest/node:v1.31.0
```

---

## 🎯 Ma Recommandation

**Essaie d'abord k3d** (Solution 1) :

1. C'est le plus simple (pas de sudo, pas de reboot)
2. Ça fonctionne avec cgroup v2
3. Multi-node out of the box
4. Compatible avec tes manifests GOTK8S

### Script pour tester k3d

```bash
# Installation
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Supprime kind
kind delete cluster --name gotk8s

# Crée cluster k3d
k3d cluster create gotk8s \
  --servers 1 \
  --agents 2 \
  -p "30100:30100@loadbalancer" \
  -p "30101:30101@loadbalancer"

# Vérifier
kubectl get nodes

# Déployer GOTK8S
kubectl apply -f manifests/gotk8s/00-namespace/
kubectl apply -f manifests/gotk8s/01-redis/
kubectl apply -f manifests/gotk8s/02-the-north/
kubectl apply -f manifests/gotk8s/03-ingress/

# Tester
curl http://localhost:30100
```

---

## Comparaison des Solutions

| Solution | Difficulté | Sudo? | Reboot? | Affecte système? | Multi-node? |
|----------|-----------|-------|---------|------------------|-------------|
| k3d | ⭐ Facile | ❌ | ❌ | ❌ | ✅ |
| Docker cgroupfs | ⭐⭐ Moyen | ✅ | ❌ | Oui (Docker) | ✅ |
| Kernel cgroup v1 | ⭐⭐⭐ Difficile | ✅ | ✅ | Oui (tout) | ✅ |
| kind v0.24+ | ⭐ Facile | Peut-être | ❌ | ❌ | ✅ ? |

---

## Quelle solution veux-tu essayer ?

1. **k3d** (recommandé) - 5 minutes
2. **Docker cgroupfs** - 10 minutes + sudo
3. **Kernel cgroup v1** - 15 minutes + sudo + reboot
4. **kind v0.24+** - 5 minutes (pas garanti de fonctionner)

Dis-moi et je t'aide à l'implémenter !
