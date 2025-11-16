# GOTK8S - Guide de l'étudiant

## 🎯 Bienvenue dans le royaume de Westeros !

Ce laboratoire vous permet d'apprendre Kubernetes de manière immersive en déployant et gérant les "Sept Royaumes" de Game of Thrones sous forme de microservices.

## 🏰 Qu'allez-vous apprendre ?

En suivant ce lab, vous maîtriserez :

### Concepts Kubernetes essentiels
- ✅ **Pods** - Plus petite unité déployable
- ✅ **Deployments** - Gestion déclarative des applications
- ✅ **Services** - Découverte et load balancing
- ✅ **Namespaces** - Isolation des ressources
- ✅ **ConfigMaps & Secrets** - Configuration externe
- ✅ **Ingress** - Routage HTTP/HTTPS
- ✅ **Scaling** - Horizontal et vertical
- ✅ **Health Checks** - Liveness et readiness probes
- ✅ **Monitoring** - Logs et métriques

### Compétences pratiques
- ✅ Déployer une application multi-tiers
- ✅ Gérer des bases de données dans K8s
- ✅ Exposer des services au monde extérieur
- ✅ Débugger des problèmes de déploiement
- ✅ Scaler une application automatiquement
- ✅ Mettre à jour sans interruption de service

## 🗺️ Parcours d'apprentissage

### Niveau 1 : "Winter is Coming" (Débutant - 1h30)
**Premier royaume : The North 🐺**

Vous allez déployer un système de messagerie utilisant des "Ravens" (corbeaux).

**Ce que vous allez faire :**
1. Créer un namespace isolé avec quotas
2. Déployer Redis (base de données)
3. Déployer l'API backend (Node.js)
4. Déployer le frontend web
5. Exposer l'application au monde
6. Tester le scaling et la résilience
7. Explorer les logs et le monitoring

**📚 Suivez :** [scenarios/01-winter-is-coming/README.md](scenarios/01-winter-is-coming/README.md)

### Niveau 2 : "War of Five Kings" (Intermédiaire - 2h)
**Déployer plusieurs royaumes**

- Dorne (Commerce API + MongoDB)
- The Reach (GraphQL + PostgreSQL)
- Communication entre royaumes
- Network Policies
- Persistent Volumes avancés

### Niveau 3 : "The Long Night" (Avancé - 2h)
**Haute disponibilité et sécurité**

- Multi-master setup
- StatefulSets pour bases de données
- Backup et disaster recovery
- Security policies
- Runtime security avec Falco

### Niveau 4 : "A Dream of Spring" (Expert - 3h)
**Production et DevOps**

- CI/CD avec GitLab
- GitOps avec ArgoCD
- Blue/Green deployments
- Canary releases
- Monitoring avec Prometheus/Grafana

## 🚀 Démarrage rapide

### Prérequis

Votre formateur a déjà préparé :
- ✅ Cluster Kubernetes (3 nœuds)
- ✅ kubectl configuré
- ✅ Images Docker des applications
- ✅ Toute la documentation

### Vérifier l'accès au cluster

```bash
# Voir les nœuds du cluster
kubectl get nodes

# Devrait afficher 3 nœuds (1 master + 2 workers)
```

### Accéder à l'application The North

L'application est déjà déployée pour vous découvrir Kubernetes :

**Frontend :** http://localhost:30100

**Testez :**
1. Ouvrez l'URL dans votre navigateur
2. Envoyez un message depuis "The North" vers "King's Landing"
3. Le message apparaît en temps réel !

## 📝 Commandes essentielles

### Exploration de base

```bash
# Voir tous les namespaces
kubectl get namespaces

# Voir tout dans le namespace Westeros
kubectl get all -n westeros

# Voir les pods en détail
kubectl get pods -n westeros -o wide

# Décrire un pod
kubectl describe pod <nom-du-pod> -n westeros
```

### Logs et debugging

```bash
# Voir les logs d'un pod
kubectl logs <nom-du-pod> -n westeros

# Suivre les logs en temps réel
kubectl logs -f deployment/the-north-api -n westeros

# Accéder à un pod
kubectl exec -it <nom-du-pod> -n westeros -- sh

# Voir les événements
kubectl get events -n westeros --sort-by='.lastTimestamp'
```

### Scaling et gestion

```bash
# Scaler un déploiement
kubectl scale deployment the-north-api --replicas=5 -n westeros

# Voir l'état d'un déploiement
kubectl rollout status deployment/the-north-api -n westeros

# Redémarrer un déploiement
kubectl rollout restart deployment/the-north-api -n westeros
```

### Monitoring

```bash
# Utilisation CPU/RAM des pods
kubectl top pods -n westeros

# Utilisation des nœuds
kubectl top nodes
```

## 🎯 Exercices pratiques

### Exercice 1 : Explorer l'architecture (15 min)

```bash
# 1. Combien de pods tournent dans westeros ?
kubectl get pods -n westeros

# 2. Quelle est l'adresse IP de chaque pod ?
kubectl get pods -n westeros -o wide

# 3. Sur quels nœuds tournent les pods ?
# (Regarder la colonne NODE)

# 4. Quel type de service expose l'API ?
kubectl get svc -n westeros

# 5. Quels sont les ports exposés ?
```

**Questions :**
- Pourquoi y a-t-il 2 pods API ?
- Quelle est la différence entre ClusterIP et NodePort ?

### Exercice 2 : Tester la résilience (15 min)

```bash
# 1. Tuer un pod API
POD=$(kubectl get pod -n westeros -l app=the-north-api -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD -n westeros

# 2. Observer immédiatement
kubectl get pods -n westeros -w

# 3. Pendant ce temps, tester l'API
curl http://localhost:30101/health
```

**Observations :**
- L'API reste-t-elle accessible ?
- Combien de temps pour recréer le pod ?
- Qui a recréé le pod ?

### Exercice 3 : Scaling horizontal (15 min)

```bash
# 1. Voir le nombre actuel de replicas
kubectl get deployment the-north-api -n westeros

# 2. Passer à 5 replicas
kubectl scale deployment the-north-api --replicas=5 -n westeros

# 3. Observer la création
kubectl get pods -n westeros -w

# 4. Voir la distribution
kubectl get pods -n westeros -o wide

# 5. Envoyer des requêtes et voir le load balancing
for i in {1..10}; do
  curl -s http://localhost:30101/health | grep motto
done
```

**Questions :**
- Comment les pods sont-ils distribués ?
- Comment le Service fait-il du load balancing ?

### Exercice 4 : Explorer les configurations (20 min)

```bash
# 1. Voir les ConfigMaps
kubectl get configmap -n westeros

# 2. Voir le contenu de la config Redis
kubectl describe configmap redis-config -n westeros

# 3. Voir les variables d'environnement d'un pod
kubectl exec -it deployment/the-north-api -n westeros -- env

# 4. Comment l'API trouve-t-elle Redis ?
kubectl exec -it deployment/the-north-api -n westeros -- sh
# Dans le pod:
ping redis-service
nslookup redis-service
```

### Exercice 5 : Analyser les ressources (15 min)

```bash
# 1. Voir les quotas du namespace
kubectl describe namespace westeros

# 2. Voir les limites de ressources
kubectl get limitrange -n westeros -o yaml

# 3. Utilisation actuelle
kubectl top pods -n westeros

# 4. Détails d'un pod
kubectl describe pod -l app=the-north-api -n westeros
```

**Questions :**
- Combien de CPU/RAM est alloué à chaque pod ?
- Que se passe-t-il si un pod dépasse ses limites ?

## 🏆 Challenges

### Challenge 1 : "The Red Wedding" (Difficulté: ⭐⭐)
**Objectif :** Tous les pods d'un royaume sont tués. Restaurez le service.

```bash
# Tuer tous les pods API
kubectl delete pods -l app=the-north-api -n westeros

# Mission: Restaurer le service en moins de 2 minutes
```

### Challenge 2 : "Battle of Blackwater" (Difficulté: ⭐⭐⭐)
**Objectif :** L'application est sous charge. Scalez pour gérer 1000 req/s.

```bash
# Installer k6 pour load testing
# https://k6.io/docs/getting-started/installation/

# Lancez le test de charge (fichier fourni)
k6 run loadtest.js

# Mission: Ajuster le scaling pour 0 erreurs
```

### Challenge 3 : "The Purple Wedding" (Difficulté: ⭐⭐⭐⭐)
**Objectif :** Un pod est compromis. Isolez-le avec des Network Policies.

```bash
# Mission: Créer des Network Policies pour:
# 1. L'API peut accéder à Redis
# 2. Le Frontend peut accéder à l'API
# 3. Redis n'est accessible que par l'API
```

### Challenge 4 : "Night King Attack" (Difficulté: ⭐⭐⭐⭐⭐)
**Objectif :** Le cluster est en chaos. Troubleshootez et réparez.

Votre formateur va introduire des pannes. Diagnostiquez et réparez !

## 📚 Ressources

### Documentation officielle
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Documentation du projet
- [Architecture complète](GOTK8S_PROJECT.md)
- [Guide de démarrage](GOTK8S_QUICKSTART.md)
- [Scénarios détaillés](scenarios/)
- [Troubleshooting](docs/troubleshooting.md)

### Tutoriels interactifs
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)

## ❓ FAQ

**Q: Puis-je casser quelque chose ?**
R: Oui ! C'est fait pour ça. Vous apprenez en expérimentant.

**Q: Comment réinitialiser tout ?**
R: `kubectl delete namespace westeros` puis redéployer.

**Q: L'application ne répond plus ?**
R: Vérifiez les logs : `kubectl logs -f deployment/the-north-api -n westeros`

**Q: Puis-je travailler chez moi ?**
R: Oui ! Suivez le guide d'installation pour installer votre propre cluster.

## 🎓 Évaluation

Votre compréhension sera évaluée sur :

1. **Concepts théoriques** (QCM)
   - Pods, Deployments, Services
   - Namespaces, ConfigMaps, Secrets
   - Scaling, Health checks

2. **Pratique** (Lab)
   - Déployer une application
   - Debugger un problème
   - Scaler et monitorer

3. **Projet final**
   - Déployer un nouveau royaume
   - Documentation complète
   - Présentation devant la classe

## 🌟 Aller plus loin

Une fois le lab terminé :

- Contribuez au projet (GitHub)
- Créez votre propre royaume
- Participez aux challenges avancés
- Passez la certification CKA (Certified Kubernetes Administrator)

---

## 🐺 Message des Stark

> *"The man who passes the sentence should swing the sword."*
>
> Dans Kubernetes, celui qui déploie doit comprendre ce qu'il déploie.
> Ce lab vous donne les connaissances ET la pratique.

**Winter is Coming... êtes-vous prêt ?** ❄️

---

*Bon apprentissage ! Et rappelez-vous : dans Kubernetes, on apprend de ses erreurs.* 🎓
