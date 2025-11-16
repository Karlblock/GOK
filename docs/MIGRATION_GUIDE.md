# Guide de Migration : VM VirtualBox → kind

## 🎯 Objectif

Passer de la VM VirtualBox "Game Of Kube" (48,2 GB) à une solution moderne avec **kind** (2-3 GB).

**Gain d'espace : ~46 GB** 💾

## 📊 Comparaison

| Critère | VM VirtualBox | kind (Docker) |
|---------|---------------|---------------|
| **Taille totale** | 48,2 GB | 2-3 GB |
| **Démarrage** | 5-10 minutes | 30-60 secondes |
| **RAM utilisée** | 4-8 GB | 2-4 GB |
| **Portabilité** | Fichier .ova (4,3 GB) | Scripts Git |
| **Maintenance** | Import/Export | `./gok-deploy.sh` |
| **Flexibilité** | Moyenne | Élevée |
| **Moderne** | Non | Oui (standard K8s) |

## ✅ Avantages de kind

1. **Léger** : Utilise des conteneurs Docker au lieu de VMs complètes
2. **Rapide** : Cluster opérationnel en moins d'une minute
3. **Standard** : Outil officiel de la communauté Kubernetes
4. **Reproductible** : Configuration versionnée dans Git
5. **Économique** : Moins de RAM, moins de disque

## 🚀 Plan de Migration (5 étapes)

### Étape 1 : Vérifier les prérequis

```bash
# Vérifier Docker
docker --version
docker ps

# Vérifier kind
kind --version

# Vérifier kubectl
kubectl version --client
```

**Si manquant** → Voir [QUICKSTART.md](QUICKSTART.md) section "Installation rapide des dépendances"

### Étape 2 : Tester kind (SANS supprimer la VM encore !)

```bash
cd /home/kless/IUT/r509/GOK8S

# Déployer l'environnement kind
./gok-deploy.sh
```

**Durée** : 3-5 minutes

### Étape 3 : Vérifier que tout fonctionne

```bash
# Vérifier l'état complet
./gok-status.sh

# Tester l'accès
curl http://localhost:30100  # Frontend
curl http://localhost:30101  # API

# Voir les pods
kubectl get pods -n westeros
```

### Étape 4 : Si tout est OK → Supprimer la VM VirtualBox

#### Dans VirtualBox Manager :

1. Ouvre VirtualBox
2. **Arrête la VM** "Game Of Kube" si elle tourne
3. Clique droit sur "Game Of Kube"
4. Sélectionne **"Supprimer..."**
5. Coche **"Supprimer tous les fichiers"**
6. Confirme

**Gain immédiat : 48,2 GB libérés !** 🎉

#### Optionnel : Garder le fichier .ova en backup

Si tu as le fichier `GOK-v1.0.ova` quelque part :

```bash
# Option A : Le garder (4,3 GB) comme backup
# → Garde-le si tu n'es pas sûr à 100%

# Option B : Le supprimer aussi pour libérer encore plus d'espace
rm ~/path/to/GOK-v1.0.ova
# Gain additionnel : 4,3 GB
```

### Étape 5 : Mettre à jour ta documentation/notes

Note dans tes docs de TP :

```
✅ Game Of Kube : Migré vers kind (scripts dans GOK8S/)
   - Démarrage : ./gok-deploy.sh
   - Statut : ./gok-status.sh
   - Nettoyage : ./gok-cleanup.sh
```

## 🛠️ Utilisation Quotidienne

### Démarrer une session de TP

```bash
cd /home/kless/IUT/r509/GOK8S

# Option 1 : Si le cluster existe déjà
./gok-start.sh

# Option 2 : Si besoin de recréer
./gok-deploy.sh
```

### Pendant le TP

```bash
# Voir l'état
kubectl get all -n westeros

# Logs d'un service
kubectl logs -f deployment/the-north-api -n westeros

# Accéder aux services
firefox http://localhost:30100  # Frontend
```

### Fin du TP

```bash
# Option 1 : Garder le cluster pour plus tard
# → Ne rien faire, il reste en mémoire

# Option 2 : Libérer les ressources
./gok-cleanup.sh
```

## 📁 Scripts Créés

| Script | Fonction | Durée |
|--------|----------|-------|
| `gok-deploy.sh` | Créer cluster + déployer GOTK8S | 3-5 min |
| `gok-start.sh` | Vérifier cluster existant | 5 sec |
| `gok-status.sh` | Rapport d'état complet | 10 sec |
| `gok-cleanup.sh` | Supprimer cluster + images | 30 sec |

## 🎓 Scénarios d'Utilisation

### Scénario 1 : Premier TP de la semaine

```bash
./gok-deploy.sh
# ☕ Attendre 3-5 minutes
# ✅ Prêt à travailler
```

### Scénario 2 : TPs suivants (même semaine)

```bash
./gok-start.sh
# ✅ Prêt en 5 secondes
```

### Scénario 3 : Problème / Corruption

```bash
./gok-cleanup.sh
./gok-deploy.sh
# ✅ Environnement fraîchement recréé
```

### Scénario 4 : Fin du semestre

```bash
./gok-cleanup.sh
# ✅ 2-3 GB libérés
```

## 🔧 Dépannage

### Le cluster ne démarre pas

```bash
# Vérifier Docker
sudo systemctl status docker

# Redémarrer Docker si nécessaire
sudo systemctl restart docker

# Recréer le cluster
kind delete cluster --name gotk8s
./gok-deploy.sh
```

### Les services ne répondent pas

```bash
# Vérifier les pods
kubectl get pods -n westeros

# Voir les logs
kubectl logs deployment/the-north-api -n westeros

# Voir les événements
kubectl get events -n westeros --sort-by='.lastTimestamp'
```

### Pas assez d'espace disque

```bash
# Nettoyer GOK8S
./gok-cleanup.sh

# Nettoyer Docker complètement
docker system prune -a --volumes
# ⚠️ Cela supprime TOUT Docker (pas seulement GOK8S)
```

## 💾 Gestion de l'Espace Disque

### Espace utilisé par GOK8S

```bash
# Voir les images
docker images | grep gotk8s

# Voir l'espace Docker total
docker system df

# Rapport complet
./gok-status.sh
```

### Comparaison avant/après migration

**AVANT (VM VirtualBox)** :
```
Game Of Kube VM      : 48,2 GB
GOK-v1.0.ova backup  :  4,3 GB
Total                : 52,5 GB
```

**APRÈS (kind)** :
```
Images Docker gotk8s : ~1,5 GB
Cluster kind         : ~1,0 GB
Total                : ~2,5 GB
```

**GAIN NET : ~50 GB** 🎉

## 📚 Documentation de Référence

- [QUICKSTART.md](QUICKSTART.md) - Guide de démarrage rapide
- [README.md](README.md) - Documentation principale du projet
- [GOTK8S_PROJECT.md](GOTK8S_PROJECT.md) - Architecture complète
- [docs/troubleshooting.md](docs/troubleshooting.md) - Dépannage détaillé

## ❓ FAQ Migration

### Q : Et si je veux revenir à la VM ?

**R :** Tu peux toujours réimporter le fichier .ova si tu l'as gardé.

### Q : Les TPs fonctionnent-ils de la même façon ?

**R :** Oui ! Les applications sont identiques. Seule la méthode de déploiement change.

### Q : Puis-je utiliser les deux en parallèle ?

**R :** Oui, mais attention aux conflits de ports (30100, 30101). Tu peux modifier les ports dans `kind/cluster-config.yaml`.

### Q : Que se passe-t-il si je redémarre ma machine ?

**R :** Les conteneurs Docker s'arrêtent. Relance avec :
```bash
./gok-start.sh
# ou
./gok-deploy.sh
```

### Q : Comment partager cet environnement avec d'autres étudiants ?

**R :** Ils clonent juste le repo Git et lancent `./gok-deploy.sh`. Pas besoin de partager un gros fichier .ova !

## ✅ Checklist de Migration

- [ ] Docker installé et fonctionnel
- [ ] kind installé
- [ ] kubectl installé
- [ ] `./gok-deploy.sh` exécuté avec succès
- [ ] `./gok-status.sh` affiche tout en vert
- [ ] Services accessibles (http://localhost:30100 et 30101)
- [ ] VM VirtualBox "Game Of Kube" supprimée
- [ ] (Optionnel) Fichier .ova supprimé aussi
- [ ] Documentation mise à jour avec les nouveaux scripts

## 🎊 Après la Migration

Tu as maintenant :

✅ **Un environnement moderne** utilisant les standards Kubernetes
✅ **46 GB d'espace disque récupérés**
✅ **Un démarrage 10x plus rapide** (30s vs 5min)
✅ **Une solution reproductible** versionnée dans Git
✅ **Moins de RAM utilisée** (2-4 GB vs 4-8 GB)

---

**"The old way is dead. Long live kind!" 🐺⚡**
