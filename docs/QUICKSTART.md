# GOK8S - Guide de Démarrage Rapide

## Remplacement de la VM VirtualBox (48,2 GB)

Tu n'as **plus besoin** de la VM VirtualBox "Game Of Kube" de 48,2 GB !

Ce projet utilise **kind** (Kubernetes in Docker), ce qui est :
- **Plus rapide** : démarrage en 30-60 secondes vs 5-10 minutes pour une VM
- **Plus léger** : ~2-3 GB au lieu de 48,2 GB
- **Plus flexible** : création/destruction facile

## Prérequis

Assure-toi d'avoir installé :

```bash
# Docker (version 20.10+)
docker --version

# kind (Kubernetes IN Docker)
kind --version

# kubectl
kubectl version --client
```

### Installation rapide des dépendances

Si tu n'as pas **kind** :

```bash
# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# macOS
brew install kind
```

Si tu n'as pas **kubectl** :

```bash
# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# macOS
brew install kubectl
```

## Scripts Disponibles

### 1. `gok-deploy.sh` - Déploiement complet

Crée le cluster Kubernetes et déploie GOTK8S.

```bash
./gok-deploy.sh
```

Ce script :
1. Vérifie les dépendances (Docker, kind, kubectl)
2. Crée un cluster Kubernetes avec kind (1 control-plane + 2 workers)
3. Construit les images Docker des applications
4. Charge les images dans le cluster kind
5. Déploie GOTK8S (namespace westeros, Redis, The North)
6. Affiche les URLs d'accès

**Durée** : 3-5 minutes la première fois

### 2. `gok-start.sh` - Démarrage rapide

Vérifie qu'un cluster existant est opérationnel.

```bash
./gok-start.sh
```

Utilise ce script quand :
- Le cluster kind existe déjà
- Tu veux juste vérifier le statut
- Tu as redémarré ta machine

**Durée** : 5 secondes

### 3. `gok-cleanup.sh` - Nettoyage

Supprime complètement l'environnement GOK8S.

```bash
./gok-cleanup.sh
```

Ce script supprime :
- Le cluster kind `gotk8s`
- Les images Docker `gotk8s/*`

Utilise ce script quand :
- Tu veux libérer de l'espace disque
- Tu veux repartir de zéro
- Tu as fini le TP

**Gain d'espace** : ~2-3 GB

## Workflow Typique

### Première utilisation

```bash
# 1. Déployer l'environnement complet
./gok-deploy.sh

# 2. Accéder aux applications
firefox http://localhost:30100  # Frontend
curl http://localhost:30101     # API
```

### Sessions suivantes

```bash
# Vérifier que tout fonctionne
./gok-start.sh

# Voir les pods
kubectl get pods -n westeros

# Voir les logs
kubectl logs -f deployment/the-north-api -n westeros
```

### Fin du TP / Libérer de l'espace

```bash
# Supprimer l'environnement
./gok-cleanup.sh
```

## Comparaison VM vs kind

| Aspect | VM VirtualBox | kind |
|--------|---------------|------|
| Taille | 48,2 GB | ~2-3 GB |
| Démarrage | 5-10 minutes | 30-60 secondes |
| RAM nécessaire | 4-8 GB | 2-4 GB |
| Portabilité | .ova | Scripts + Docker |
| Recréation | Import .ova | `./gok-deploy.sh` |

## URLs d'Accès

Une fois déployé :

- **Frontend The North** : [http://localhost:30100](http://localhost:30100)
- **API The North** : [http://localhost:30101](http://localhost:30101)
- **Dashboard K8s** (optionnel) : [http://localhost:30000](http://localhost:30000)

## Commandes Kubernetes Utiles

```bash
# Voir tous les clusters kind
kind get clusters

# Voir les nœuds du cluster
kubectl get nodes

# Voir tous les pods dans westeros
kubectl get pods -n westeros

# Voir tous les services
kubectl get svc -n westeros

# Logs en temps réel
kubectl logs -f deployment/the-north-api -n westeros

# Exécuter une commande dans un pod
kubectl exec -it deployment/the-north-api -n westeros -- sh

# Voir la configuration du cluster
kubectl cluster-info
```

## Dépannage

### Le cluster ne démarre pas

```bash
# Vérifier que Docker fonctionne
docker ps

# Supprimer et recréer le cluster
kind delete cluster --name gotk8s
./gok-deploy.sh
```

### Les pods ne démarrent pas

```bash
# Voir les événements
kubectl get events -n westeros --sort-by='.lastTimestamp'

# Décrire un pod problématique
kubectl describe pod <pod-name> -n westeros
```

### Port déjà utilisé (30100, 30101)

```bash
# Trouver quel processus utilise le port
sudo lsof -i :30100

# Ou utiliser netstat
netstat -tuln | grep 30100
```

### Images Docker non chargées

```bash
# Reconstruire et charger les images
cd kingdoms
bash build-images.sh
kind load docker-image gotk8s/the-north-api:1.0 --name gotk8s
kind load docker-image gotk8s/the-north-frontend:1.0 --name gotk8s
```

## Migration depuis la VM VirtualBox

### Étapes pour supprimer la VM de 48,2 GB

1. **Teste d'abord que kind fonctionne** :
   ```bash
   ./gok-deploy.sh
   ```

2. **Vérifie que tout est OK** :
   ```bash
   kubectl get all -n westeros
   curl http://localhost:30100
   ```

3. **Si tout fonctionne, supprime la VM VirtualBox** :
   - Ouvre VirtualBox
   - Clique droit sur "Game Of Kube"
   - "Supprimer" → "Supprimer tous les fichiers"
   - **Gain : 48,2 GB libérés !**

4. **Optionnel : Garde le fichier .ova en backup** :
   ```bash
   # Si tu as GOK-v1.0.ova quelque part
   # Tu peux le garder (4,3 GB) ou le supprimer si tu es confiant
   ```

## Avantages de cette approche

✅ **Gain d'espace** : 48,2 GB → 2-3 GB (économie de ~46 GB)
✅ **Démarrage rapide** : 30-60s au lieu de 5-10 min
✅ **Reproductible** : Scripts versionnés dans Git
✅ **Moderne** : Utilise les outils standards K8s (kind, kubectl)
✅ **Flexible** : Facile à modifier et personnaliser

## Support

Pour toute question, consulte :

- [README.md](README.md) - Documentation principale
- [GOTK8S_PROJECT.md](GOTK8S_PROJECT.md) - Architecture complète
- [docs/troubleshooting.md](docs/troubleshooting.md) - Dépannage détaillé

---

**"Winter is Coming, but kind makes it faster!" 🐺⚡**
