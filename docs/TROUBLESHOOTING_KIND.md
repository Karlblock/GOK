# Dépannage : Problème avec les Workers kind

## Problème Rencontré

Sur certains systèmes (notamment Parrot OS / Debian avec cgroup v2), les **worker nodes** de kind ne peuvent pas démarrer. L'erreur est :

```
ERROR: failed to join node with kubeadm: command "docker exec --privileged gotk8s-worker kubeadm join ..."
timed out waiting for the condition
- The kubelet is unhealthy due to a misconfiguration of the node in some way (required cgroups disabled)
```

## Cause

C'est un problème connu de compatibilité entre :
- kind
- kubeadm
- cgroup v2 (utilisé par défaut sur les systèmes récents)
- containerd

## Solution Appliquée

Utiliser un **cluster à 1 seul nœud** (control-plane uniquement).

Le control-plane peut exécuter des workloads même sans workers, ce qui est parfait pour l'apprentissage et le développement.

### Configuration utilisée

Fichier [kind/cluster-config.yaml](kind/cluster-config.yaml) :

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: gotk8s
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30100
        hostPort: 30100
      - containerPort: 30101
        hostPort: 30101
```

## Impact

✅ **Aucun impact** sur l'apprentissage :
- Tous les tutoriels fonctionnent
- Tous les challenges fonctionnent
- Les pods peuvent s'exécuter sur le control-plane

⚠️ **Limitations** (non critiques pour l'apprentissage) :
- Pas de démonstration de scheduling multi-nœuds
- Pas de node affinity/anti-affinity
- Pas de taints/tolerations sur workers

## Alternatives (si tu veux absolument des workers)

### Option 1 : Minikube

```bash
minikube start --nodes=3 --cpus=4 --memory=8192
```

### Option 2 : k3d (plus léger que kind)

```bash
k3d cluster create gotk8s --servers 1 --agents 2 -p "30100:30100@loadbalancer" -p "30101:30101@loadbalancer"
```

### Option 3 : kubeadm "natif" (dans une VM)

Utiliser la VM VirtualBox originale ou créer une VM avec Vagrant.

## Vérification du Système

Pour vérifier ta configuration cgroup :

```bash
# Voir la version de cgroup
docker info | grep -i cgroup

# Si tu vois "Cgroup Version: 2", c'est la cause du problème
```

## Workarounds Testés (qui n'ont PAS fonctionné)

1. ❌ Changer la version de l'image kind
2. ❌ Modifier la configuration réseau
3. ❌ Ajouter des paramètres kubeadm custom
4. ❌ Utiliser systemd cgroup driver

## Conclusion

La configuration à **1 nœud est suffisante** pour GOK8S et l'apprentissage de Kubernetes.

Pour une utilisation en production ou pour tester des scénarios multi-nœuds avancés, utilise plutôt **minikube** ou **k3d**.

---

**Date** : 2025-11-15
**Système testé** : Parrot OS avec Docker 28.5.1 + kind 0.20.0
**Solution** : Configuration single-node
