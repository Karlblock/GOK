# 📝 Résumé : Scripts GOK8S

## 🎯 Problème Résolu

**AVANT** : VM VirtualBox "Game Of Kube" = 48,2 GB
**APRÈS** : Cluster kind + images Docker = ~2-3 GB
**GAIN** : ~46 GB libérés ! 🎉

## 🚀 Les 4 Scripts Créés

### 1. `gok-deploy.sh` - Le Déploiement Complet

**Usage** :
```bash
./gok-deploy.sh
```

**Fait quoi** :
1. ✅ Vérifie Docker, kind, kubectl
2. ✅ Crée le cluster Kubernetes (1 control-plane + 2 workers)
3. ✅ Construit les images Docker des applications
4. ✅ Charge les images dans kind
5. ✅ Déploie GOTK8S (namespace westeros, Redis, The North)
6. ✅ Affiche les URLs d'accès

**Quand l'utiliser** :
- Première utilisation
- Le cluster n'existe pas
- Tu veux recréer l'environnement from scratch

**Durée** : 3-5 minutes

---

### 2. `gok-start.sh` - Le Démarrage Rapide

**Usage** :
```bash
./gok-start.sh
```

**Fait quoi** :
1. ✅ Vérifie que le cluster existe
2. ✅ Configure kubectl
3. ✅ Affiche l'état des pods/services
4. ✅ Affiche les URLs d'accès

**Quand l'utiliser** :
- Le cluster existe déjà
- Tu veux juste vérifier que tout tourne
- Tu as redémarré ta machine

**Durée** : 5 secondes

---

### 3. `gok-status.sh` - Le Rapport Complet

**Usage** :
```bash
./gok-status.sh
```

**Fait quoi** :
1. ✅ Vérifie Docker, kind, kubectl
2. ✅ Liste les clusters kind
3. ✅ Affiche l'état du cluster gotk8s
4. ✅ Affiche les pods et services de westeros
5. ✅ Teste l'accessibilité des services (30100, 30101)
6. ✅ Affiche l'espace disque utilisé
7. ✅ Liste les commandes utiles

**Quand l'utiliser** :
- Tu veux un diagnostic complet
- Quelque chose ne fonctionne pas
- Tu veux voir l'espace disque utilisé

**Durée** : 10 secondes

---

### 4. `gok-cleanup.sh` - Le Nettoyage

**Usage** :
```bash
./gok-cleanup.sh
```

**Fait quoi** :
1. ⚠️ Supprime le cluster kind 'gotk8s'
2. ⚠️ Supprime les images Docker gotk8s/*
3. ✅ Libère ~2-3 GB d'espace disque

**Quand l'utiliser** :
- Tu as fini le TP
- Tu veux libérer de l'espace
- Tu veux repartir de zéro

**Durée** : 30 secondes

---

## 📋 Workflow Typique

### Scénario A : Première fois

```bash
cd /home/kless/IUT/r509/GOK8S
./gok-deploy.sh
# ☕ Attendre 3-5 minutes
# ✅ Environnement prêt !

# Travailler sur le TP...
kubectl get pods -n westeros
curl http://localhost:30100
```

### Scénario B : Sessions suivantes (même semaine)

```bash
cd /home/kless/IUT/r509/GOK8S
./gok-start.sh
# ✅ Prêt en 5 secondes !

# Travailler sur le TP...
```

### Scénario C : Problème / Debugging

```bash
cd /home/kless/IUT/r509/GOK8S
./gok-status.sh
# 🔍 Voir ce qui ne va pas

# Si besoin de recréer :
./gok-cleanup.sh
./gok-deploy.sh
```

### Scénario D : Fin du semestre

```bash
cd /home/kless/IUT/r509/GOK8S
./gok-cleanup.sh
# ✅ 2-3 GB libérés
```

---

## 🗂️ Fichiers Documentation

| Fichier | Contenu |
|---------|---------|
| [QUICKSTART.md](QUICKSTART.md) | Guide de démarrage rapide |
| [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) | Guide complet de migration VM → kind |
| [RESUME_SCRIPTS.md](RESUME_SCRIPTS.md) | Ce fichier (résumé des scripts) |
| [README.md](README.md) | Documentation principale |
| [GOTK8S_PROJECT.md](GOTK8S_PROJECT.md) | Architecture complète du projet |

---

## ✅ Checklist : Supprimer la VM VirtualBox

1. [ ] Tester kind : `./gok-deploy.sh`
2. [ ] Vérifier que tout fonctionne : `./gok-status.sh`
3. [ ] Tester l'accès : `curl http://localhost:30100`
4. [ ] Ouvrir VirtualBox
5. [ ] Arrêter la VM "Game Of Kube"
6. [ ] Clique droit → "Supprimer..."
7. [ ] Cocher "Supprimer tous les fichiers"
8. [ ] Confirmer
9. [ ] **GAIN : 48,2 GB libérés !** 🎊

---

## 🔧 Commandes Rapides

```bash
# Tout déployer
./gok-deploy.sh

# Vérifier l'état
./gok-status.sh

# Démarrage rapide
./gok-start.sh

# Tout supprimer
./gok-cleanup.sh

# Voir les pods
kubectl get pods -n westeros

# Logs en temps réel
kubectl logs -f deployment/the-north-api -n westeros

# Accéder aux services
curl http://localhost:30100  # Frontend
curl http://localhost:30101  # API
```

---

## 💡 Conseils

### Conseil 1 : Garde le cluster entre les sessions
Si tu travailles plusieurs jours de suite sur le même TP, **ne supprime pas le cluster** avec `gok-cleanup.sh`. Utilise juste `gok-start.sh` pour vérifier qu'il tourne.

### Conseil 2 : Utilise gok-status.sh en cas de problème
Avant de demander de l'aide, lance `./gok-status.sh`. Il te donnera un diagnostic complet.

### Conseil 3 : Nettoie en fin de semestre
Pense à utiliser `./gok-cleanup.sh` quand tu as fini les TPs pour libérer l'espace disque.

### Conseil 4 : Personnalise les scripts
Les scripts sont en bash simple. Tu peux les modifier si besoin (changer les ports, ajouter des royaumes, etc.).

---

## 🆘 Aide Rapide

**Problème** : Le cluster ne démarre pas
```bash
sudo systemctl restart docker
./gok-cleanup.sh
./gok-deploy.sh
```

**Problème** : Les services ne répondent pas
```bash
./gok-status.sh
kubectl get pods -n westeros
kubectl describe pod <pod-name> -n westeros
```

**Problème** : Port déjà utilisé (30100 ou 30101)
```bash
sudo lsof -i :30100
# Tuer le processus ou changer le port dans kind/cluster-config.yaml
```

**Problème** : Pas assez d'espace disque
```bash
./gok-cleanup.sh
docker system prune -a
```

---

## 📞 Support

- Documentation : [README.md](README.md), [QUICKSTART.md](QUICKSTART.md)
- Dépannage : [docs/troubleshooting.md](docs/troubleshooting.md)
- Architecture : [GOTK8S_PROJECT.md](GOTK8S_PROJECT.md)

---

**"Winter is Coming... but deployment is fast! 🐺⚡"**
