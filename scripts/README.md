# Scripts GOK8S

Ce répertoire contient tous les scripts de gestion de GOK8S.

## 🎯 Scripts Recommandés (k3d)

### k3d-deploy.sh
Déploiement complet avec k3d multi-node.

**Usage** :
```bash
./scripts/k3d-deploy.sh
# ou via le lien symbolique
./k3d-deploy
```

**Fait quoi** :
1. Vérifie Docker, k3d, kubectl
2. Crée cluster k3d (1 server + 2 agents)
3. Construit les images Docker
4. Charge les images dans k3d
5. Déploie GOTK8S (namespace, Redis, The North)

**Durée** : 2-3 minutes

---

### k3d-cleanup.sh
Nettoyage complet k3d.

**Usage** :
```bash
./scripts/k3d-cleanup.sh
# ou
./k3d-cleanup
```

**Fait quoi** :
1. Supprime le cluster k3d 'gotk8s'
2. Supprime les images Docker gotk8s/*

**Durée** : 30 secondes

---

### gok-learn.sh
CLI interactif d'apprentissage.

**Usage** :
```bash
./scripts/gok-learn.sh
# ou
./gok-learn
```

**Fait quoi** :
- Tutoriels guidés (Pods, Deployments, Services)
- Challenges pratiques
- Game of Thrones Challenges (The Red Wedding, etc.)
- Système de progression
- Explorateur de cluster

---

## 📦 Scripts kind (Fallback)

Utilisés uniquement si k3d ne fonctionne pas ou si tu veux tester kind single-node.

### gok-deploy.sh
Déploiement avec kind (single-node seulement sur ton système).

### gok-start.sh
Vérification rapide d'un cluster kind existant.

### gok-status.sh
Diagnostic complet de l'environnement kind.

### gok-cleanup.sh
Nettoyage complet kind.

---

## 🔗 Liens Symboliques

Pour faciliter l'accès, des liens symboliques sont créés à la racine :

```bash
./k3d-deploy   → scripts/k3d-deploy.sh
./k3d-cleanup  → scripts/k3d-cleanup.sh
./gok-learn    → scripts/gok-learn.sh
```

Tu peux donc lancer depuis la racine :
```bash
./k3d-deploy
./gok-learn
```

---

## 📋 Workflow Typique

### Première utilisation

```bash
# 1. Déployer
./k3d-deploy

# 2. Apprendre
./gok-learn
```

### Sessions suivantes

```bash
# Vérifier que le cluster existe
~/bin/k3d cluster list

# Si oui, juste lancer le CLI
./gok-learn

# Sinon, redéployer
./k3d-deploy
```

### Fin du TP

```bash
# Nettoyer
./k3d-cleanup
```

---

## 🛠️ Développement des Scripts

Si tu veux modifier ou contribuer aux scripts :

1. Éditer dans `scripts/`
2. Tester avec `bash -n script.sh` (vérifier syntaxe)
3. Les liens symboliques pointent automatiquement vers la nouvelle version

---

## 📚 Documentation

- [../K3D_VS_KIND.md](../K3D_VS_KIND.md) - Pourquoi k3d ?
- [../CHEATSHEET.md](../CHEATSHEET.md) - Commandes rapides
- [../LEARNING_CLI.md](../LEARNING_CLI.md) - Guide du CLI d'apprentissage
- [../README.md](../README.md) - Documentation principale
