# GOTK8S - Guide de l'enseignant

## 👨‍🏫 Vue d'ensemble du projet pédagogique

**GOTK8S** est un environnement d'apprentissage Kubernetes "clé en main" utilisant l'univers Game of Thrones pour rendre l'apprentissage immersif et mémorable.

## 🎯 Objectifs pédagogiques

### Compétences visées
- Comprendre l'architecture microservices
- Maîtriser les concepts fondamentaux de Kubernetes
- Savoir déployer et gérer des applications conteneurisées
- Débugger et résoudre des problèmes en production
- Mettre en place du monitoring et de l'observabilité

### Niveau et prérequis

**Public cible :**
- IUT Informatique (2e année)
- Licence Pro DevOps
- Master 1 Informatique
- Formation continue

**Prérequis étudiants :**
- Bases de Linux/Shell
- Compréhension des conteneurs Docker (notions)
- Bases de réseau (IP, ports, DNS)
- Optionnel : Node.js/JavaScript (pour comprendre le code)

## 📅 Planning recommandé

### Format court (1 journée - 6h)
- **Matin (3h)** : Scénario 1 "Winter is Coming"
  - 0h-1h : Présentation théorique + démo
  - 1h-3h : TP guidé avec The North
- **Après-midi (3h)** : Exercices pratiques
  - 3h-4h30 : Exercices et challenges
  - 4h30-6h : Projet en binôme

### Format moyen (2 jours - 12h)
- **Jour 1** : Fondamentaux
  - Matin : Théorie + Scénario 1
  - Après-midi : Exercices et debugging
- **Jour 2** : Avancé
  - Matin : Scénario 2 (multi-royaumes)
  - Après-midi : Projet et présentation

### Format complet (1 semaine - 30h)
- **Jour 1-2** : Fondamentaux (Scénarios 1-2)
- **Jour 3** : Avancé (Scénario 3 - HA)
- **Jour 4** : DevOps (Scénario 4 - CI/CD)
- **Jour 5** : Projet final et évaluation

## 🏗️ Préparation de l'environnement

### Option 1 : Un cluster par étudiant (Recommandé)

**Matériel nécessaire :**
- 1 machine par étudiant (8 Go RAM, 4 CPU cores, 40 Go disque)
- Docker installé
- kind installé (Kubernetes IN Docker)
- Connexion Internet (pour télécharger les images)

**Installation :**
```bash
# Sur chaque machine étudiant
git clone https://github.com/votre-repo/GOK8S.git
cd GOK8S
cd kind
kind create cluster --config cluster-config.yaml  # 30-60 secondes ⚡

# Charger les images Docker dans le cluster
cd ../kingdoms
./load-images-to-k8s.sh
```

**Avantages de kind vs Vagrant :**
- ✅ **10x plus rapide** : 30 secondes vs 20-25 minutes
- ✅ **Plus stable** : Pas de nested virtualization
- ✅ **Moins de ressources** : Utilise Docker au lieu de VMs complètes
- ✅ **Standard de l'industrie** : kind est utilisé par les projets Kubernetes officiels

### Option 2 : Cluster partagé (Labs en groupe)

**Matériel nécessaire :**
- 1 serveur/VM puissant (32+ Go RAM, 16+ CPU cores)
- Cluster K8s multi-nœuds
- Accès réseau pour chaque étudiant

**Configuration :**
- 1 namespace par étudiant/binôme
- ResourceQuotas pour isolation
- Chaque étudiant a son kubeconfig

### Option 3 : Cloud (AWS/GCP/Azure)

**Avantages :**
- Pas de limitation matérielle
- Accessible de partout
- Facile à scaler

**Coûts estimés :**
- ~2-5€ par étudiant par jour
- Penser à détruire les clusters après les TPs

## 📚 Structure des supports

### Documents fournis

| Document | Public | Usage |
|----------|--------|-------|
| **GUIDE_ETUDIANT.md** | Étudiants | Guide complet avec exercices |
| **scenarios/01-winter-is-coming/** | Étudiants | TP guidé pas à pas (1h30) |
| **GOTK8S_PROJECT.md** | Tous | Architecture et vision |
| **GOTK8S_QUICKSTART.md** | Tous | Démarrage rapide |
| **GUIDE_ENSEIGNANT.md** | Enseignants | Ce document |

### Slides recommandés (à créer)

**Partie 1 : Introduction (30 min)**
- Pourquoi Kubernetes ?
- Architecture d'un cluster
- Concepts de base (Pods, Services, Deployments)

**Partie 2 : Démo live (30 min)**
- Déploiement de The North
- Exploration avec kubectl
- Scaling et résilience

**Partie 3 : Hands-on (2h)**
- Les étudiants suivent le scénario
- Vous circulez pour aider
- Questions/réponses

## 🎓 Déroulé d'une session type

### Session 1 : "Winter is Coming" (3h)

**00:00 - 00:30 | Introduction théorique**
- Présentation de Kubernetes
- Architecture du projet GOTK8S
- Objectifs de la séance

**00:30 - 01:00 | Démo live**
- Vous déployez The North en direct
- Explications des commandes
- Montrez le frontend fonctionnel

**01:00 - 02:30 | TP guidé**
- Les étudiants suivent [scenarios/01-winter-is-coming/](scenarios/01-winter-is-coming/)
- Vous circulez et aidez
- Checkpoints réguliers

**02:30 - 03:00 | Debriefing**
- Questions/réponses
- Concepts clés à retenir
- Préparation pour la suite

### Points d'attention pendant le TP

**Checkpoint 1 (après Mission 2) :**
Vérifiez que tous ont Redis qui tourne :
```bash
kubectl get pods -n westeros | grep redis
```

**Checkpoint 2 (après Mission 4) :**
Tous doivent voir l'interface web :
```bash
curl http://localhost:30100
```

**Checkpoint 3 (après Mission 7) :**
Scaling et résilience testés.

## 🎯 Exercices et évaluation

### Exercices progressifs

**Niveau 1 : Découverte (facile)**
- Explorer les pods et services
- Consulter les logs
- Comprendre les labels et selectors

**Niveau 2 : Manipulation (moyen)**
- Scaler les déploiements
- Modifier les ConfigMaps
- Tester la résilience

**Niveau 3 : Création (difficile)**
- Créer un nouveau service
- Écrire des manifestes YAML
- Troubleshooter des problèmes

### Challenges avec correction

#### Challenge 1 : "The Red Wedding"
**Objectif :** Restaurer un service après crash total

**Mise en place (prof) :**
```bash
# Tuer tous les pods d'un royaume
kubectl delete pods --all -n westeros
```

**Correction attendue (étudiant) :**
Les pods se recréent automatiquement grâce aux Deployments.
L'étudiant doit observer et expliquer le mécanisme.

**Points d'évaluation :**
- Comprend le rôle du Deployment ✓
- Sait utiliser kubectl get/describe ✓
- Identifie que c'est automatique ✓

#### Challenge 2 : "Battle of Blackwater"
**Objectif :** Gérer la montée en charge

**Mise en place :**
Installer k6 et lancer un test de charge.

**Correction attendue :**
```bash
kubectl scale deployment the-north-api --replicas=10 -n westeros
# ou mieux : configurer HPA
kubectl autoscale deployment the-north-api --min=2 --max=10 --cpu-percent=70 -n westeros
```

#### Challenge 3 : "Purple Wedding"
**Objectif :** Sécuriser avec Network Policies

**Correction type :**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: redis-policy
  namespace: westeros
spec:
  podSelector:
    matchLabels:
      app: redis
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: the-north-api
    ports:
    - protocol: TCP
      port: 6379
```

### Évaluation finale

**QCM (30 min - 20 points)**
- 20 questions sur les concepts
- Pods, Services, Deployments, etc.

**TP Pratique (1h30 - 40 points)**
- Déployer une nouvelle application
- Exposer le service
- Scaler et monitorer
- Troubleshooter un problème planté

**Projet (optionnel - 40 points)**
- Créer un nouveau royaume
- Documentation complète
- Présentation 10 min

## 🔧 Troubleshooting commun

### Problème 1 : Images pas disponibles

**Symptôme :** ImagePullBackOff

**Cause :** Images Docker pas chargées dans les nœuds

**Solution :**
```bash
cd kingdoms
./load-images-to-k8s.sh
```

### Problème 2 : Pods en CrashLoopBackOff

**Symptôme :** Pods redémarrent en boucle

**Diagnostic :**
```bash
kubectl logs <pod> -n westeros
kubectl describe pod <pod> -n westeros
```

**Causes fréquentes :**
- Redis pas accessible → vérifier le service
- Variable d'environnement manquante
- Port déjà utilisé

### Problème 3 : Frontend affiche erreur

**Cause :** L'API n'est pas accessible

**Vérification :**
```bash
kubectl get svc -n westeros
curl http://localhost:30101/health
```

## 📊 Métriques de succès

### Indicateurs d'engagement
- % d'étudiants qui terminent le Scénario 1
- Nombre de questions posées
- Feedback post-TP

### Indicateurs d'apprentissage
- Résultats au QCM
- Qualité des projets finaux
- Autonomie lors des challenges

## 🎁 Ressources additionnelles

### Pour aller plus loin

**Livres recommandés :**
- "Kubernetes: Up and Running" - Kelsey Hightower
- "The Kubernetes Book" - Nigel Poulton

**Certifications :**
- CKA (Certified Kubernetes Administrator)
- CKAD (Certified Kubernetes Application Developer)

**Communautés :**
- Kubernetes Slack
- CNCF Meetups
- KubeCon (conférence annuelle)

### Extensions possibles du projet

1. **Ajouter d'autres royaumes**
   - Dorne (MongoDB + API REST)
   - The Reach (GraphQL + PostgreSQL)
   - The Vale (OAuth2 + Redis)

2. **Monitoring avancé**
   - Prometheus + Grafana
   - ELK Stack pour les logs
   - Jaeger pour le tracing

3. **CI/CD**
   - Pipeline GitLab CI
   - ArgoCD pour GitOps
   - Flux pour déploiement continu

4. **Sécurité**
   - Falco pour runtime security
   - OPA pour policy enforcement
   - Vault pour secrets management

## 💡 Conseils pédagogiques

### Ce qui fonctionne bien

✅ **L'immersion thématique** : Les étudiants retiennent mieux avec GoT
✅ **Learning by doing** : Manipulation directe plutôt que théorie pure
✅ **Erreurs encouragées** : "Cassez, réparez, apprenez"
✅ **Travail en binôme** : Collaboration et entraide
✅ **Challenges progressifs** : Du facile au difficile

### Pièges à éviter

❌ Trop de théorie d'un coup
❌ Aller trop vite sur les bases
❌ Ne pas laisser le temps d'expérimenter
❌ Oublier de vérifier que tout le monde suit
❌ Négliger le debriefing final

### Timing flexible

**Si vous êtes en retard :**
- Scénario 1 peut être fait en 1h (mode accéléré)
- Sauter certains exercices bonus
- Donner le reste en homework

**Si vous êtes en avance :**
- Challenges supplémentaires
- Commencer le Scénario 2
- Discuter des use cases réels

## 📧 Support et contribution

**Questions ?**
- Issues GitHub
- Email : [votre email]

**Contribuer ?**
- Pull requests bienvenues
- Idées de nouveaux royaumes
- Nouveaux scénarios pédagogiques

## 📜 Licence et attribution

- Projet sous licence MIT
- Libre d'utilisation pour l'enseignement
- Attribution appréciée mais non obligatoire

---

## 🏆 Retours d'expérience

*Section à compléter après vos premiers TPs*

**Ce qui a bien fonctionné :**
- ...

**À améliorer :**
- ...

**Suggestions des étudiants :**
- ...

---

**"A teacher who doesn't deploy can't teach Kubernetes. A student who doesn't break things doesn't learn."**

*Bon enseignement !* 👨‍🏫🎓
