# Scénario 1 : Premier déploiement

**Niveau:** Débutant
**Durée estimée:** 30 minutes
**Lab requis:** K8S-CLUSTER ou MINILAB

## Objectifs

- Déployer votre première application sur Kubernetes
- Comprendre les Deployments et Services
- Exposer une application au monde extérieur
- Scaler une application

## Prérequis

- Lab K8S-CLUSTER ou MINILAB déployé
- Accès SSH au master : `vagrant ssh master`

## Étape 1 : Vérifier le cluster

```bash
# Se connecter au master
vagrant ssh master

# Vérifier que tous les nœuds sont prêts
kubectl get nodes

# Vérifier les pods système
kubectl get pods --all-namespaces
```

**Résultat attendu:** Tous les nœuds en statut "Ready"

## Étape 2 : Déployer NGINX

```bash
# Créer un déploiement NGINX avec 3 replicas
kubectl create deployment nginx --image=nginx:alpine --replicas=3

# Vérifier le déploiement
kubectl get deployments
kubectl get pods

# Observer les détails
kubectl describe deployment nginx
```

**Résultat attendu:** 3 pods NGINX en état "Running"

## Étape 3 : Exposer le déploiement

```bash
# Créer un service de type NodePort
kubectl expose deployment nginx --port=80 --type=NodePort

# Vérifier le service
kubectl get services nginx

# Noter le port NodePort (ex: 30123)
NODE_PORT=$(kubectl get service nginx -o jsonpath='{.spec.ports[0].nodePort}')
echo "NodePort: $NODE_PORT"
```

## Étape 4 : Tester l'application

```bash
# Depuis le master
curl localhost:$NODE_PORT

# Depuis votre machine hôte
curl http://192.168.56.10:$NODE_PORT
```

**Résultat attendu:** Page d'accueil par défaut de NGINX

## Étape 5 : Scaler l'application

```bash
# Augmenter le nombre de replicas
kubectl scale deployment nginx --replicas=5

# Observer les nouveaux pods
kubectl get pods -w  # Ctrl+C pour arrêter

# Vérifier la distribution sur les nœuds
kubectl get pods -o wide
```

**Résultat attendu:** 5 pods distribués sur les différents nœuds

## Étape 6 : Mettre à jour l'application

```bash
# Mettre à jour vers une nouvelle version
kubectl set image deployment/nginx nginx=nginx:1.25-alpine

# Observer le rolling update
kubectl rollout status deployment/nginx

# Vérifier l'historique
kubectl rollout history deployment/nginx
```

## Étape 7 : Tester la résilience

```bash
# Supprimer un pod
POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD_NAME

# Observer que Kubernetes recrée automatiquement le pod
kubectl get pods -w
```

**Observation:** Un nouveau pod est créé automatiquement pour maintenir le nombre de replicas souhaité.

## Étape 8 : Explorer les logs

```bash
# Voir les logs d'un pod
kubectl logs -l app=nginx --tail=10

# Suivre les logs en temps réel
kubectl logs -l app=nginx -f
```

## Étape 9 : Nettoyage

```bash
# Supprimer le service et le déploiement
kubectl delete service nginx
kubectl delete deployment nginx

# Vérifier la suppression
kubectl get all
```

## Questions de réflexion

1. **Que se passe-t-il si vous supprimez manuellement un pod ?**
   - Kubernetes le recrée automatiquement pour maintenir le nombre désiré de replicas

2. **Comment le trafic est-il distribué entre les pods ?**
   - Via le Service qui fait du load balancing

3. **Quelle est la différence entre un Deployment et un Pod ?**
   - Le Deployment gère plusieurs Pods et assure leur résilience

4. **Que signifie "NodePort" ?**
   - Un port ouvert sur tous les nœuds du cluster qui redirige vers le Service

## Aller plus loin

### Exercice bonus 1 : Utiliser un fichier YAML

```bash
# Utiliser le manifeste fourni
kubectl apply -f /vagrant/../../manifests/k8s/apps/nginx-deployment.yaml

# Comparer avec ce que vous avez créé
kubectl get all
```

### Exercice bonus 2 : Ajouter des ressources limits

```bash
# Éditer le déploiement
kubectl edit deployment nginx

# Ajouter dans le spec du container:
resources:
  requests:
    memory: "64Mi"
    cpu: "100m"
  limits:
    memory: "128Mi"
    cpu: "200m"
```

### Exercice bonus 3 : Health checks

```bash
kubectl edit deployment nginx

# Ajouter:
livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 3
  periodSeconds: 3
readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5
```

## Prochaines étapes

- [Scénario 2 : Déploiement d'application avec base de données](02-app-with-database.md)
- [Scénario 3 : Gestion du stockage persistant](03-persistent-storage.md)

## Ressources

- [Documentation Kubernetes - Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Documentation Kubernetes - Services](https://kubernetes.io/docs/concepts/services-networking/service/)
