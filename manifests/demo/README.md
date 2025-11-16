# 🎬 Démonstration Scalabilité Kubernetes

Ce module fournit un outil interactif pour démontrer les capacités de scalabilité et d'auto-healing de Kubernetes.

## 📋 Vue d'ensemble

Le système de démonstration déploie une application web simple (nginx) et simule une montée en charge progressive pour déclencher l'autoscaling horizontal (HPA).

## 🚀 Utilisation

### Lancement rapide

```bash
./demo-scalabilite
```

### Menu interactif

Le script propose 9 options:

1. **🎬 Démonstration complète automatique** - Cycle complet avec montées en charge progressives
2. **📦 Déploiement initial seulement** - Déploie l'application sans load testing
3. **📈 Simulation montée en charge (10 users)** - Charge légère
4. **🔥 Simulation montée en charge (50 users)** - Charge moyenne
5. **💥 Simulation montée en charge (100 users)** - Charge importante
6. **🚀 Stress test (500 users)** - Stress test intensif
7. **📊 Voir état actuel du cluster** - Affiche les pods et HPA
8. **🧹 Nettoyer la démonstration** - Supprime le namespace demo
9. **🌐 Ouvrir le Dashboard Kubernetes** - Lance kubectl proxy et affiche le token

## 🏗️ Architecture

### Composants déployés

- **Namespace**: `demo`
- **Deployment**: `demo-webapp` (nginx:alpine)
- **Service**: NodePort sur le port 30200
- **HPA**: Auto-scaling de 1 à 10 replicas basé sur CPU (50%)

### Fichiers

```
manifests/demo/
├── demo-deployment.yaml    # Namespace, Deployment, Service
├── demo-hpa.yaml           # HorizontalPodAutoscaler
└── README.md               # Cette documentation

scripts/
├── demo-scalabilite.sh     # Script principal interactif
└── demo-load-test.sh       # Générateur de charge
```

## 📊 Visualisation

### Terminal

Le script affiche en temps réel:
- Nombre de replicas actifs
- Distribution des pods sur les nœuds
- État du HPA (min/max/actuel)
- Barre de progression du test

### Dashboard Kubernetes

Pour une visualisation graphique:

```bash
./dashboard-access
```

Puis ouvrez votre navigateur et surveillez:
- **Workloads > Deployments** - Voir le scaling en action
- **Workloads > Pods** - Distribution multi-node
- **Cluster > Nodes** - Utilisation des ressources

## ⚙️ Configuration HPA

```yaml
minReplicas: 1
maxReplicas: 10
metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: 50
```

### Comportement de scaling

- **Scale Up**: Immédiat, 100% ou +2 pods toutes les 15s
- **Scale Down**: Stabilisation de 60s avant réduction

## 🧪 Tests de charge

### Générateur de charge

Le script `demo-load-test.sh` génère du trafic HTTP avec:
- N utilisateurs simultanés
- Requêtes continues pendant la durée spécifiée
- 10 requêtes/sec par utilisateur

### Scénarios

| Users | Type | Attendu |
|-------|------|---------|
| 10 | Légère | 1-2 replicas |
| 50 | Moyenne | 3-5 replicas |
| 100 | Importante | 5-8 replicas |
| 500 | Stress | 10 replicas (max) |

## 🔍 Vérifications manuelles

### État du cluster

```bash
# Voir les pods et leur nœud
kubectl get pods -n demo -o wide

# Voir le HPA
kubectl get hpa -n demo

# Voir les événements
kubectl get events -n demo --sort-by='.lastTimestamp'

# Voir les métriques CPU
kubectl top pods -n demo
```

### Test manuel

```bash
# Accéder à l'application
curl http://localhost:30200

# Générer de la charge manuellement
for i in {1..100}; do curl -s http://localhost:30200 > /dev/null & done
```

## 🧹 Nettoyage

### Via le menu

Option 8 du menu interactif

### Manuel

```bash
kubectl delete namespace demo
```

## 📚 Concepts démontrés

1. **Horizontal Pod Autoscaling (HPA)** - Scaling automatique basé sur les métriques
2. **Multi-node distribution** - Pods répartis sur plusieurs nœuds
3. **Load Balancing** - Service distribue les requêtes
4. **Self-healing** - Kubernetes recrée les pods défaillants
5. **Resource Limits** - Gestion des ressources CPU/mémoire
6. **NodePort Service** - Exposition externe de l'application

## 🐛 Dépannage

### HPA ne scale pas

Vérifier que metrics-server est installé:
```bash
kubectl get deployment metrics-server -n kube-system
kubectl top nodes
```

### Pods en Pending

Vérifier les ressources disponibles:
```bash
kubectl describe pod <pod-name> -n demo
kubectl top nodes
```

### Load test ne démarre pas

Vérifier que l'application est accessible:
```bash
curl -v http://localhost:30200
kubectl get svc -n demo
```

## 💡 Utilisation pédagogique

### Démonstration complète (15-20 min)

1. Lancer option 1 (démo complète)
2. Ouvrir le Dashboard dans un autre terminal
3. Expliquer chaque phase pendant l'exécution
4. Montrer la répartition multi-node
5. Montrer le scale down après la charge

### Exercices interactifs

1. Modifier les limites du HPA dans `demo-hpa.yaml`
2. Changer le seuil CPU de 50% à 30%
3. Augmenter maxReplicas à 20
4. Tester différentes stratégies de scaling

### Points clés à souligner

- Automatisation complète (pas d'intervention manuelle)
- Résilience (self-healing)
- Distribution multi-node
- Optimisation des ressources
- Rapidité du scaling
