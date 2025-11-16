# 🎓 GOK8S - CLI Interactif d'Apprentissage

## Vue d'ensemble

Le **CLI interactif** (`gok-learn.sh`) est un outil pédagogique pour apprendre Kubernetes de manière interactive et ludique, en utilisant le thème Game of Thrones.

## Lancement

```bash
cd /home/kless/IUT/r509/GOK8S
./gok-learn.sh
```

## 🎯 Fonctionnalités

### 1. 📚 Tutoriels Guidés (Débutant)

Des tutoriels pas à pas pour apprendre les concepts de base :

- **Les Pods** - Comprendre les conteneurs
  - Créer un pod
  - Voir les logs
  - Supprimer un pod

- **Les Deployments** - Gérer les réplicas
  - Créer un deployment
  - Scaler (augmenter/réduire les réplicas)
  - Voir le statut

- **Les Services** - Exposer les applications
  - Créer un service NodePort
  - Tester l'accès HTTP
  - Comprendre le load balancing

- **ConfigMaps & Secrets** - Configuration (en développement)

- **Volumes** - Stockage persistant (en développement)

### 2. 🎯 Challenges Pratiques (Intermédiaire)

Des challenges pour mettre en pratique :

- Debug un pod qui crashe
- Scaler une application sous charge
- Faire un rolling update sans downtime
- Sécuriser avec des secrets
- Configurer un Ingress

### 3. 🔥 Scénarios Avancés (Expert)

Scénarios complexes et réalistes (en développement).

### 4. 🏆 Game of Thrones Challenges

Des challenges immersifs dans l'univers GOT :

#### ⚔️ The Red Wedding - Disaster Recovery
- **Scénario** : Tous les pods de The North sont tués
- **Objectif** : Restaurer le service en moins de 2 minutes
- **Compétences** : Self-healing, Deployments, Observabilité

#### 🔥 Battle of Blackwater - Load Testing (en développement)
- **Scénario** : Gérer une charge importante
- **Objectif** : Scaler automatiquement
- **Compétences** : HPA, Resource Limits, Monitoring

#### 👑 The Purple Wedding - Security Breach (en développement)
- **Scénario** : Pod compromis
- **Objectif** : Sécuriser le cluster
- **Compétences** : Network Policies, RBAC, Secrets

#### ❄️ The Long Night - High Availability (en développement)
- **Scénario** : Assurer la HA pendant une panne
- **Objectif** : Zero downtime
- **Compétences** : Pod Disruption Budgets, Liveness/Readiness

### 5. 📊 Progression

- Système de suivi de progression
- 14 challenges au total
- Stockage dans `~/.gok8s_progress`
- Visualisation du pourcentage de complétion

### 6. 🔍 Explorateur de Cluster

Navigation facile dans le cluster :
- Voir tous les pods
- Voir tous les services
- Voir tous les deployments
- Voir les namespaces
- Voir les nœuds
- Voir les événements récents

### 7. 💡 Tips & Cheatsheet

Aide-mémoire intégré avec les commandes kubectl essentielles.

## 🎮 Interface

### Menu Principal

```
╔════════════════════════════════════════════════════════════╗
║     GOK8S - Interactive Kubernetes Learning CLI           ║
╚════════════════════════════════════════════════════════════╝

🎓 Menu Principal
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Progression: 3/14 challenges complétés

1. 📚 Tutoriels Guidés (Débutant)
2. 🎯 Challenges Pratiques (Intermédiaire)
3. 🔥 Scénarios Avancés (Expert)
4. 🏆 Game of Thrones Challenges
5. 📊 Voir ma progression
6. 🔍 Explorer le cluster
7. 💡 Tips & Best Practices
8. ❓ Aide / Cheatsheet
9. 🚪 Quitter

Choix [1-9]:
```

## 📝 Exemple d'Utilisation

### Tutorial 1 : Les Pods

```bash
./gok-learn.sh
# Choisir option 1 (Tutoriels Guidés)
# Choisir option 1 (Les Pods)
```

Le CLI :
1. Explique ce qu'est un Pod
2. Montre un exemple de YAML
3. Propose de créer le pod automatiquement
4. Vérifie le statut
5. Propose de nettoyer

### Challenge : The Red Wedding

```bash
./gok-learn.sh
# Choisir option 4 (GOT Challenges)
# Choisir option 1 (The Red Wedding)
```

Le CLI :
1. Explique le scénario
2. Tue tous les pods de The North
3. Lance un chronomètre
4. Attend que tu restaures les pods
5. Vérifie le temps et donne un score

## 🎯 Objectifs Pédagogiques

### Pour les Débutants
- ✅ Comprendre les concepts de base (Pods, Deployments, Services)
- ✅ Apprendre la syntaxe kubectl
- ✅ Manipuler des objets Kubernetes
- ✅ Debugger des problèmes simples

### Pour les Intermédiaires
- ✅ Gérer le cycle de vie des applications
- ✅ Configurer la scalabilité
- ✅ Gérer la configuration (ConfigMaps, Secrets)
- ✅ Exposer des services

### Pour les Avancés
- ✅ Disaster recovery
- ✅ Haute disponibilité
- ✅ Sécurité
- ✅ Performance tuning

## 📊 Système de Progression

Le CLI sauvegarde automatiquement ta progression dans `~/.gok8s_progress`.

### Voir ta progression

```bash
./gok-learn.sh
# Option 5 : Voir ma progression
```

Affiche :
```
📚 Tutoriels Guidés:
  ✓ Les Pods
  ✓ Les Deployments
  ✓ Les Services
  ✗ ConfigMaps & Secrets
  ✗ Volumes

🎯 Challenges Pratiques:
  ✓ Debug un pod
  ✗ Scaler une app
  ...

🏆 Game of Thrones Challenges:
  ✓ The Red Wedding
  ✗ Battle of Blackwater
  ...

Progression globale: 8/14 (57%)
💪 Bon progrès! Vous êtes à mi-chemin!
```

### Réinitialiser la progression

```bash
rm ~/.gok8s_progress
```

## 🛠️ Architecture Technique

### Fichiers créés automatiquement

Le CLI crée des fichiers temporaires dans `/tmp` :
- `/tmp/gok-nginx-pod.yaml` - Exemple de pod
- `/tmp/gok-nginx-deployment.yaml` - Exemple de deployment
- `/tmp/gok-nginx-service.yaml` - Exemple de service

### Namespace utilisé

Tous les objets créés sont dans le namespace `westeros`.

### Nettoyage

Le CLI propose toujours de nettoyer les ressources créées après chaque tutorial/challenge.

## 💡 Conseils d'Utilisation

### 1. Commence par les Tutoriels

Les tutoriels sont conçus pour être faits dans l'ordre :
1. Pods → 2. Deployments → 3. Services → etc.

### 2. Prends ton temps

Chaque tutorial inclut :
- Des explications
- Du code YAML
- Des commandes kubectl
- Des tests pratiques

Lis tout et expérimente !

### 3. Utilise l'Explorateur

L'option "Explorer le cluster" (6) permet de voir l'état du cluster à tout moment.

### 4. Refais les Challenges

Tu peux refaire un challenge même s'il est marqué comme complété pour t'entraîner.

### 5. Combine avec kubectl

Le CLI est un complément à kubectl, pas un remplacement. Continue à utiliser kubectl directement pour approfondir.

## 🚀 Prochaines Fonctionnalités (Roadmap)

- [ ] Tutoriels ConfigMaps & Secrets
- [ ] Tutorial Volumes & Persistence
- [ ] Challenge "Debug un pod qui crashe"
- [ ] Challenge "Scaler sous charge"
- [ ] Challenge "Rolling update"
- [ ] GOT Challenge "Battle of Blackwater"
- [ ] GOT Challenge "Purple Wedding"
- [ ] GOT Challenge "Long Night"
- [ ] Mode expert avec scénarios multi-composants
- [ ] Intégration avec monitoring (Prometheus)
- [ ] Génération de certificats (pour le challenge "Purple Wedding")
- [ ] Simulation de pannes réseau

## 🤝 Contribution

Tu peux ajouter tes propres challenges ! Le code est dans [gok-learn.sh](gok-learn.sh).

### Ajouter un nouveau tutorial

1. Créer une fonction `tutorial_nom()`
2. L'ajouter au menu dans `show_tutorials_menu()`
3. L'ajouter au case dans `main()`

### Ajouter un nouveau challenge GOT

1. Créer une fonction `got_challenge_nom()`
2. L'ajouter au menu dans `show_got_challenges()`
3. L'ajouter à la progression dans `show_progress()`

## 📚 Ressources Complémentaires

- [README.md](README.md) - Documentation principale GOK8S
- [CHEATSHEET.md](CHEATSHEET.md) - Commandes kubectl rapides
- [GOTK8S_PROJECT.md](GOTK8S_PROJECT.md) - Architecture complète
- [scenarios/](scenarios/) - Scénarios d'apprentissage détaillés

## 🎓 Exemples de Session

### Session Débutant (30 min)

```bash
./gok-learn.sh
# 1. Tutorial Pods (10 min)
# 2. Tutorial Deployments (10 min)
# 3. Tutorial Services (10 min)
# 5. Voir la progression
```

### Session Intermédiaire (45 min)

```bash
./gok-learn.sh
# Révision rapide des tutoriels
# 2. Faire 2-3 challenges pratiques
# 4. Essayer "The Red Wedding"
```

### Session Expert (1h)

```bash
./gok-learn.sh
# 4. Faire tous les GOT Challenges
# 3. Scénarios avancés
# Expérimenter avec kubectl directement
```

---

**"Learn by doing. Winter is Coming... be prepared! 🐺📚"**
