# Kubernetes Dashboard - Guide d'Utilisation

## 📋 Vue d'Ensemble

Le Kubernetes Dashboard est une interface web pour gérer et monitorer votre cluster Kubernetes. Il est automatiquement déployé lors de l'installation du cluster GOK8S.

## 🚀 Installation Automatique

Le dashboard est installé automatiquement lors du déploiement avec `./k3d-deploy` :

```bash
./k3d-deploy
# Répondre "Y" à la question: "Installer le Kubernetes Dashboard?"
```

### Ce qui est installé :

1. **Kubernetes Dashboard** (v2.7.0)
2. **ServiceAccount** `admin-user` avec droits cluster-admin
3. **Token d'accès** pré-configuré pour connexion facile

## 🔑 Accès au Dashboard

### Méthode 1 : Script Helper (RECOMMANDÉ)

Le moyen le plus simple :

```bash
./dashboard-access
```

Ce script :
- ✅ Affiche le token d'accès
- ✅ Propose de lancer automatiquement `kubectl proxy`
- ✅ Fournit l'URL d'accès

### Méthode 2 : Manuelle

#### Étape 1 : Récupérer le token

```bash
kubectl get secret admin-user-token -n kubernetes-dashboard \
  -o jsonpath='{.data.token}' | base64 -d && echo
```

Copiez le token affiché.

#### Étape 2 : Lancer le proxy

Dans un terminal :

```bash
kubectl proxy
```

Laissez ce terminal ouvert.

#### Étape 3 : Accéder au dashboard

Ouvrez votre navigateur à :

```
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

#### Étape 4 : Se connecter

1. Choisir l'option **Token**
2. Coller le token récupéré à l'étape 1
3. Cliquer sur **Sign In**

## 🎯 Fonctionnalités Principales

### 1. Vue d'ensemble du Cluster

- **Workloads** : Deployments, Pods, ReplicaSets, DaemonSets, StatefulSets
- **Discovery & Load Balancing** : Services, Ingresses
- **Config & Storage** : ConfigMaps, Secrets, PersistentVolumes
- **RBAC** : ServiceAccounts, Roles, RoleBindings

### 2. Monitoring

- État des Pods (Running, Pending, Failed)
- Utilisation des ressources (CPU, RAM)
- Logs des containers en temps réel
- Events du cluster

### 3. Gestion

- Créer des ressources via YAML ou formulaire
- Éditer des ressources existantes
- Supprimer des ressources
- Scaler les Deployments
- Redémarrer des Pods

## 📊 Cas d'Usage

### Visualiser les Pods de GOTK8S

1. Dans le menu de gauche : **Workloads** → **Pods**
2. Sélectionner le namespace : **westeros**
3. Voir tous les Pods avec leur statut

### Voir les Logs d'un Pod

1. Aller dans **Workloads** → **Pods**
2. Cliquer sur le nom d'un Pod
3. Onglet **Logs** pour voir les logs en temps réel

### Scaler un Deployment

1. Aller dans **Workloads** → **Deployments**
2. Cliquer sur le Deployment (ex: `the-north-api`)
3. Cliquer sur l'icône **Edit** (crayon en haut à droite)
4. Modifier `spec.replicas`
5. **Update**

### Créer un Service

1. Menu **+** (Create) en haut à droite
2. Choisir **Create from form** ou **Create from file**
3. Remplir le formulaire ou coller le YAML
4. **Upload**

## 🔐 Sécurité

### Token Admin

Le token créé automatiquement a les droits **cluster-admin**, ce qui signifie :

- ✅ **Avantages** : Accès complet à toutes les ressources du cluster
- ⚠️  **Risque** : À utiliser UNIQUEMENT pour dev/apprentissage
- ❌ **Production** : Créer des ServiceAccounts avec permissions limitées

### Créer un utilisateur avec permissions limitées

Pour production, créez un ServiceAccount avec Role spécifique :

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: readonly-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: readonly-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view  # Role lecture seule
subjects:
- kind: ServiceAccount
  name: readonly-user
  namespace: kubernetes-dashboard
```

## 🛠️ Dépannage

### Le dashboard ne charge pas

Vérifiez que le proxy est lancé :

```bash
# Dans un terminal
kubectl proxy
```

### Token invalide

Régénérez le token :

```bash
kubectl delete secret admin-user-token -n kubernetes-dashboard
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: admin-user-token
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token
EOF

# Attendre 2 secondes
sleep 2

# Récupérer le nouveau token
kubectl get secret admin-user-token -n kubernetes-dashboard \
  -o jsonpath='{.data.token}' | base64 -d && echo
```

### Dashboard pods pas prêts

Vérifiez le statut :

```bash
kubectl get pods -n kubernetes-dashboard

# Voir les logs si problème
kubectl logs -n kubernetes-dashboard deployment/kubernetes-dashboard
```

## 📚 Ressources

- [Documentation officielle](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
- [GitHub Kubernetes Dashboard](https://github.com/kubernetes/dashboard)
- [Guide RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

## 🎓 Intégration avec GOK-LEARN

Le dashboard est un excellent complément aux tutorials GOK-LEARN :

- **Tutorial 1 (Pods)** : Visualisez les Pods dans l'interface
- **Tutorial 2 (Deployments)** : Scalez via le dashboard
- **Tutorial 3 (Services)** : Voyez les endpoints en temps réel
- **Tutorial 6 (Namespaces)** : Naviguez entre les namespaces
- **Tutorial 7 (Health Probes)** : Vérifiez le statut Ready/Not Ready
- **Tutorial 8 (Architecture)** : Explorez les composants kube-system

## ⚡ Commandes Rapides

```bash
# Accès rapide au dashboard
./dashboard-access

# Voir le token à tout moment
kubectl get secret admin-user-token -n kubernetes-dashboard \
  -o jsonpath='{.data.token}' | base64 -d && echo

# Lancer le proxy
kubectl proxy

# Vérifier l'installation
kubectl get all -n kubernetes-dashboard

# Désinstaller le dashboard
kubectl delete namespace kubernetes-dashboard
kubectl delete clusterrolebinding admin-user
```

---

**Winter is Coming... And the Dashboard shows everything!** 🐺👑📊
