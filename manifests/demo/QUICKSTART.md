# 🚀 Quick Start - Démonstration Scalabilité

## Démarrage rapide (2 minutes)

### Option 1 : Démonstration complète automatique

```bash
./demo-scalabilite
# Choisir l'option 1
```

Ceci va :
1. Déployer l'application nginx
2. Configurer le HPA (auto-scaling)
3. Lancer 3 tests de charge progressifs (10, 50, 100 users)
4. Montrer le scaling en temps réel

**Durée : ~3-4 minutes**

### Option 2 : Test manuel

```bash
./demo-scalabilite
```

Menu interactif :

1. **Première fois** : Choisir option `2` (Déploiement initial)
2. **Test léger** : Option `3` (10 users, 60s)
3. **Test moyen** : Option `4` (50 users, 45s)
4. **Test intense** : Option `5` (100 users, 60s)
5. **Stress test** : Option `6` (500 users)

### Visualisation graphique

Dans un second terminal :

```bash
./dashboard-access
```

Puis ouvrez votre navigateur et naviguez vers :
- **Workloads > Deployments** : Voir `demo-webapp` scaler
- **Workloads > Pods** : Voir les pods se créer
- **Cluster > Nodes** : Voir la distribution sur les nœuds

## Ce que vous allez voir

### Phase 1 : Déploiement (option 2)
```
✓ Application déployée
✓ Application prête
✓ Metrics-server déjà installé
✓ HPA configuré (min: 1, max: 10 replicas)
✓ Port 30200 déjà accessible

📊 État actuel du cluster:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Replicas: 1/1 prêts

Distribution des pods:
  [▓] demo-webapp-xxx → k3d-gotk8s-agent-0

Autoscaling (HPA):
  Min: 1 | Max: 10 | Actuel: 1

URL d'accès: http://localhost:30200
```

### Phase 2 : Test de charge (option 3-6)

Pendant le test :
```
🔥 Simulation en cours...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👥 Utilisateurs: 50
⏱️  Temps écoulé: 30s / 45s
📊 Progression: [▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░] 66%

📊 État actuel du cluster:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Replicas: 5/5 prêts

Distribution des pods:
  [▓] demo-webapp-xxx → k3d-gotk8s-agent-0
  [▓] demo-webapp-yyy → k3d-gotk8s-agent-1
  [▓] demo-webapp-zzz → k3d-gotk8s-server-0
  [▓] demo-webapp-aaa → k3d-gotk8s-agent-0
  [▓] demo-webapp-bbb → k3d-gotk8s-agent-1

Autoscaling (HPA):
  Min: 1 | Max: 10 | Actuel: 5

URL d'accès: http://localhost:30200
```

### Après le test

Le HPA va progressivement réduire le nombre de replicas après 60 secondes de stabilisation.

## Résultats attendus

| Utilisateurs | Replicas attendus | Temps de scaling |
|--------------|-------------------|------------------|
| 10           | 1-2              | Immédiat         |
| 50           | 3-5              | ~30-45s          |
| 100          | 5-8              | ~45-60s          |
| 500          | 10 (max)         | ~60-90s          |

## Nettoyage

```bash
./demo-scalabilite
# Choisir option 8
```

Ceci supprime complètement le namespace `demo`.

## Problèmes courants

### Port 30200 non mappé

**Message** :
```
⚠ Port 30200 non mappé dans k3d
💡 Recréez le cluster avec: ./k3d-deploy
```

**Solution** : Le script configure automatiquement un port-forward. Pour un mapping permanent, recréez le cluster avec `./k3d-deploy` (le port 30200 est maintenant dans la config).

### HPA affiche `<unknown>`

**Cause** : Le metrics-server collecte encore les données (prend 15-30s).

**Solution** : Attendez quelques secondes, le HPA affichera bientôt les valeurs CPU.

### Aucun scaling observé

**Vérifications** :
```bash
# 1. HPA configuré?
kubectl get hpa -n demo

# 2. Metrics disponibles?
kubectl top pods -n demo

# 3. Application accessible?
curl http://localhost:30200
```

## Commandes utiles

```bash
# Voir les pods en temps réel
watch kubectl get pods -n demo -o wide

# Voir le HPA en temps réel
watch kubectl get hpa -n demo

# Voir les événements
kubectl get events -n demo --sort-by='.lastTimestamp'

# Voir les métriques CPU
kubectl top pods -n demo

# Test manuel de charge
for i in {1..100}; do curl -s http://localhost:30200 > /dev/null & done
```

## Concepts démontrés

✅ **Horizontal Pod Autoscaling (HPA)** - Scaling basé sur CPU
✅ **Multi-node distribution** - Pods sur 3 nœuds
✅ **Load Balancing** - Service distribue les requêtes
✅ **Self-healing** - Pods recréés automatiquement
✅ **Resource Management** - Limites CPU/Mémoire
✅ **Real-time Monitoring** - Visualisation en direct

## Pour aller plus loin

- Modifier [demo-hpa.yaml](demo-hpa.yaml) pour changer les seuils
- Ajuster les limites de ressources dans [demo-deployment.yaml](demo-deployment.yaml)
- Créer des alertes basées sur les métriques
- Tester différentes stratégies de scaling
