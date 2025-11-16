# Scénario 1 : Winter is Coming

**Niveau:** Débutant
**Durée estimée:** 1h30
**Royaume:** The North
**Motto:** "Winter is Coming"

## Contexte

Les Stark du Nord ont besoin d'un système de communication pour envoyer des messages (Ravens) entre les différents royaumes de Westeros. Vous êtes le Maester chargé de déployer ce système dans le cluster Kubernetes.

## Objectifs d'apprentissage

À la fin de ce scénario, vous saurez :
- ✅ Créer et gérer des Namespaces
- ✅ Déployer une application multi-tiers (frontend + backend + cache)
- ✅ Comprendre les Services et leur rôle
- ✅ Exposer une application au monde extérieur (NodePort)
- ✅ Utiliser les ConfigMaps pour la configuration
- ✅ Débugger des pods qui ne démarrent pas
- ✅ Consulter les logs d'une application

## Architecture déployée

```
┌─────────────────────────┐
│  The North Frontend     │
│  (Nginx + HTML/JS)      │  ← Utilisateurs
└────────┬────────────────┘
         │ HTTP
┌────────▼────────────────┐
│  The North API          │
│  (Node.js + Socket.IO)  │
└────────┬────────────────┘
         │ TCP
┌────────▼────────────────┐
│  Redis                  │
│  (Cache & Messages)     │
└─────────────────────────┘
```

## Mission 1 : Préparer le terrain

### Étape 1.1 : Créer le namespace Westeros

Un namespace permet d'isoler les ressources du cluster.

```bash
kubectl apply -f manifests/gotk8s/00-namespace/westeros-namespace.yaml
```

**Questions de réflexion :**
1. Pourquoi utiliser un namespace plutôt que le namespace `default` ?
2. Que contient ce fichier en plus du namespace ?

**Vérification :**
```bash
kubectl get namespaces
kubectl describe namespace westeros
```

Vous devriez voir les ResourceQuotas et LimitRanges configurés.

### Étape 1.2 : Examiner les quotas

```bash
kubectl get resourcequota -n westeros
kubectl describe resourcequota westeros-quota -n westeros
```

**Défi :** Combien de pods maximum peuvent être créés dans ce namespace ?

## Mission 2 : Déployer la base de données (Redis)

### Étape 2.1 : Comprendre le déploiement Redis

Ouvrez le fichier `manifests/gotk8s/01-redis/redis-deployment.yaml` et étudiez-le.

**Questions :**
1. Combien de replicas Redis sont déployés ? Pourquoi ?
2. Quels sont les `livenessProbe` et `readinessProbe` utilisés ?
3. Où sont stockées les données Redis ?

### Étape 2.2 : Déployer Redis

```bash
kubectl apply -f manifests/gotk8s/01-redis/redis-deployment.yaml
```

### Étape 2.3 : Vérifier le déploiement

```bash
# Voir le pod Redis
kubectl get pods -n westeros

# Attendre qu'il soit Ready
kubectl wait --for=condition=ready pod -l app=redis -n westeros --timeout=60s

# Voir les détails
kubectl describe pod -l app=redis -n westeros
```

**Défi :** Le pod prend du temps à démarrer. Pourquoi ?
*Indice : Regardez les probes*

### Étape 2.4 : Tester Redis

```bash
# Se connecter au pod Redis
kubectl exec -it deployment/redis -n westeros -- redis-cli

# Dans redis-cli:
PING
# Devrait répondre PONG

SET test "Hello from The North"
GET test

EXIT
```

**Success!** Redis fonctionne ! ✅

## Mission 3 : Déployer The North API (Backend)

### Étape 3.1 : Construire l'image Docker

```bash
cd kingdoms
./build-images.sh
```

### Étape 3.2 : Charger les images sur les nœuds

*Note : Cette étape est spécifique à un environnement Vagrant. En production, vous utiliseriez un registry Docker.*

```bash
# Voir GOTK8S_QUICKSTART.md pour les détails complets
docker save gotk8s/the-north-api:1.0 | gzip > the-north-api.tar.gz

# Copier sur les nœuds K8s (voir guide complet)
```

### Étape 3.3 : Examiner le manifeste

Ouvrez `manifests/gotk8s/02-the-north/the-north-deployment.yaml`.

**Questions :**
1. Combien de replicas de l'API sont déployés ?
2. Quelles variables d'environnement sont passées au conteneur ?
3. Comment l'API trouve-t-elle Redis ?
4. Quels sont les resource requests et limits ?

### Étape 3.4 : Déployer l'API

```bash
kubectl apply -f manifests/gotk8s/02-the-north/the-north-deployment.yaml
```

### Étape 3.5 : Débugger si ça ne démarre pas

```bash
# Voir les pods
kubectl get pods -n westeros

# Si ImagePullBackOff : l'image n'est pas disponible
kubectl describe pod -l app=the-north-api -n westeros

# Voir les logs
kubectl logs -l app=the-north-api -n westeros

# Vérifier les événements
kubectl get events -n westeros --sort-by='.lastTimestamp'
```

**Défi :** Corrigez les erreurs potentielles !

### Étape 3.6 : Tester l'API

```bash
# Port-forward pour accéder à l'API
kubectl port-forward svc/the-north-api-service 3000:3000 -n westeros

# Dans un autre terminal:
curl http://localhost:3000/health

# Devrait répondre avec le status et le motto
```

## Mission 4 : Déployer le Frontend

### Étape 4.1 : Déployer (déjà fait si vous avez appliqué le fichier complet)

Le frontend est dans le même fichier que l'API.

### Étape 4.2 : Vérifier

```bash
kubectl get pods -l app=the-north-frontend -n westeros
kubectl get svc -n westeros
```

## Mission 5 : Exposer l'application au monde

### Étape 5.1 : Déployer les NodePorts

```bash
kubectl apply -f manifests/gotk8s/03-ingress/westeros-ingress.yaml
```

### Étape 5.2 : Obtenir les URLs

```bash
kubectl get svc -n westeros | grep NodePort
```

Vous devriez voir :
- Frontend : port 30100
- API : port 30101

### Étape 5.3 : Accéder à l'application

Ouvrez votre navigateur : **http://192.168.56.10:30100**

## Mission 6 : Tester l'application

### Test 1 : Envoyer un Raven

1. Sélectionnez "The North" comme source
2. Sélectionnez "King's Landing" comme destination
3. Écrivez un message : "Winter is Coming"
4. Cliquez sur "Send Raven"

Le message doit apparaître dans la liste !

### Test 2 : Temps réel (WebSocket)

1. Ouvrez l'application dans 2 onglets différents
2. Envoyez un message depuis un onglet
3. Le message doit apparaître instantanément dans les deux !

### Test 3 : Persistence

1. Envoyez plusieurs messages
2. Redémarrez les pods :
```bash
kubectl rollout restart deployment/the-north-api -n westeros
```
3. Rafraîchissez le navigateur
4. Les messages sont toujours là ! (stockés dans Redis)

## Mission 7 : Scaling et résilience

### Étape 7.1 : Scaler l'API

```bash
# Augmenter à 3 replicas
kubectl scale deployment the-north-api --replicas=3 -n westeros

# Voir les pods
kubectl get pods -n westeros -w
```

### Étape 7.2 : Tester la résilience

```bash
# Tuer un pod
POD=$(kubectl get pod -n westeros -l app=the-north-api -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD -n westeros

# Observer qu'un nouveau pod est recréé
kubectl get pods -n westeros -w
```

L'application reste disponible ! Load balancing automatique.

### Étape 7.3 : Voir la distribution

```bash
kubectl get pods -n westeros -o wide
```

Les pods sont distribués sur différents nœuds.

## Mission 8 : Monitoring et logs

### Étape 8.1 : Consulter les logs

```bash
# Logs de tous les pods API
kubectl logs -l app=the-north-api -n westeros --tail=50

# Suivre les logs en temps réel
kubectl logs -f deployment/the-north-api -n westeros

# Logs avec timestamps
kubectl logs deployment/the-north-api -n westeros --timestamps
```

### Étape 8.2 : Statistiques de ressources

```bash
# Utilisation CPU/RAM
kubectl top pods -n westeros

# Par nœud
kubectl top nodes
```

### Étape 8.3 : Événements

```bash
kubectl get events -n westeros --sort-by='.lastTimestamp'
```

## Mission 9 : Comprendre les Services

### Étape 9.1 : Lister les services

```bash
kubectl get svc -n westeros
```

**Questions :**
1. Qu'est-ce qu'une ClusterIP ?
2. Qu'est-ce qu'un NodePort ?
3. Quelle est la différence ?

### Étape 9.2 : Tester le DNS interne

```bash
# Depuis un pod API
kubectl exec -it deployment/the-north-api -n westeros -- sh

# Dans le pod:
ping redis-service
nslookup redis-service

# Essayer avec le FQDN complet
nslookup redis-service.westeros.svc.cluster.local
```

C'est comme ça que les services se trouvent entre eux !

## Challenges supplémentaires

### Challenge 1 : Network Policy

Créez une Network Policy qui :
- Permet à l'API de communiquer avec Redis
- Empêche le Frontend de communiquer directement avec Redis

### Challenge 2 : ConfigMap

Externalisez la configuration de l'API dans un ConfigMap :
- Liste des royaumes disponibles
- Timeouts
- Rate limits

### Challenge 3 : Liveness & Readiness

Simulez une panne :
1. Modifiez l'API pour qu'elle réponde 500 sur /health après 30 secondes
2. Observez Kubernetes redémarrer automatiquement le pod

### Challenge 4 : Resource Limits

Réduisez drastiquement les limites mémoire de l'API. Que se passe-t-il ? (OOMKilled)

## Résumé des concepts appris

- ✅ **Namespaces** : Isolation des ressources
- ✅ **Deployments** : Gestion des pods
- ✅ **Services** : Découverte et load balancing
- ✅ **ClusterIP vs NodePort** : Types d'exposition
- ✅ **ConfigMaps** : Configuration externe
- ✅ **Probes** : Health checks
- ✅ **Resource Limits** : Gestion des ressources
- ✅ **Logs & Events** : Debugging
- ✅ **Scaling** : Haute disponibilité

## Nettoyage

```bash
kubectl delete namespace westeros
```

## Prochaine étape

Scénario 2 : **War of Five Kings** - Déployer plusieurs royaumes avec interaction et gestion avancée.

---

**"The North Remembers... everything you learned!"** 🐺
