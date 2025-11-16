# GOK8S - Cheatsheet

## 🚀 Scripts Essentiels

### k3d (Multi-Node - Recommandé ✅)

```bash
./k3d-deploy.sh      # Créer et déployer avec k3d multi-node (2-3 min)
./k3d-cleanup.sh     # Tout supprimer (30 sec)
./gok-learn.sh       # 🎓 CLI interactif d'apprentissage
```

### kind (Single-Node - Fallback)

```bash
./gok-deploy.sh      # Créer et déployer avec kind single-node (3-5 min)
./gok-start.sh       # Vérifier l'existant (5 sec)
./gok-status.sh      # Diagnostic complet (10 sec)
./gok-cleanup.sh     # Tout supprimer (30 sec)
```

**Note**: Sur ton système, utilise **k3d** pour avoir le multi-node. Voir [K3D_VS_KIND.md](K3D_VS_KIND.md)

## 🌐 URLs

- Frontend : http://localhost:30100
- API : http://localhost:30101

## ☸️ Kubernetes

```bash
# Pods
kubectl get pods -n westeros
kubectl describe pod <pod-name> -n westeros
kubectl logs -f deployment/the-north-api -n westeros

# Services
kubectl get svc -n westeros
kubectl get all -n westeros

# Nœuds
kubectl get nodes

# Debug
kubectl get events -n westeros --sort-by='.lastTimestamp'
kubectl exec -it deployment/the-north-api -n westeros -- sh
```

## 🐋 Docker

```bash
# Images
docker images | grep gotk8s

# Espace
docker system df

# Nettoyage
docker system prune -a
```

## 🔧 k3d (Recommandé ✅)

```bash
# Clusters
~/bin/k3d cluster list

# Supprimer
~/bin/k3d cluster delete gotk8s

# Créer multi-node
~/bin/k3d cluster create gotk8s --servers 1 --agents 2 -p "30100:30100@loadbalancer" -p "30101:30101@loadbalancer"

# Charger image
~/bin/k3d image import gotk8s/the-north-api:1.0 -c gotk8s

# Arrêter/Démarrer (sans supprimer)
~/bin/k3d cluster stop gotk8s
~/bin/k3d cluster start gotk8s
```

## 🔧 kind (Fallback)

```bash
# Clusters
kind get clusters

# Supprimer
kind delete cluster --name gotk8s

# Créer (single-node seulement)
kind create cluster --config kind/cluster-config.yaml

# Charger image
kind load docker-image gotk8s/the-north-api:1.0 --name gotk8s
```

## 🚨 Dépannage Rapide

```bash
# Redémarrer Docker
sudo systemctl restart docker

# Recréer from scratch
./gok-cleanup.sh && ./gok-deploy.sh

# Port déjà utilisé
sudo lsof -i :30100
sudo lsof -i :30101

# Voir les logs
kubectl logs -f deployment/the-north-api -n westeros
```

## 📦 Migration VM → kind

**Avant** : VM VirtualBox = 48,2 GB
**Après** : kind + Docker = ~2-3 GB
**Gain** : ~46 GB

**Supprimer la VM VirtualBox** :
1. `./gok-deploy.sh` pour tester kind
2. Ouvrir VirtualBox
3. Clique droit sur "Game Of Kube" → Supprimer
4. Cocher "Supprimer tous les fichiers"

## 📚 Docs

- [QUICKSTART.md](QUICKSTART.md) - Guide de démarrage
- [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Migration VM → kind
- [RESUME_SCRIPTS.md](RESUME_SCRIPTS.md) - Détails des scripts
- [README.md](README.md) - Doc complète
