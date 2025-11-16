# Scénario 2 : Application avec base de données

**Niveau:** Intermédiaire
**Durée estimée:** 45 minutes
**Lab requis:** K8S-CLUSTER

## Objectifs

- Déployer une application multi-tiers (WordPress + MySQL)
- Utiliser les Secrets pour gérer les données sensibles
- Comprendre les PersistentVolumes et PersistentVolumeClaims
- Configurer la communication entre services

## Architecture

```
┌─────────────┐         ┌─────────────┐
│  WordPress  │────────>│    MySQL    │
│  (2 pods)   │         │   (1 pod)   │
└─────────────┘         └─────────────┘
      │                        │
      │                        │
   Service                  Service
   NodePort                ClusterIP
      │                        │
      └────────────────────────┘
              Storage
```

## Étape 1 : Créer les secrets

```bash
# Se connecter au master
vagrant ssh master

# Créer un secret pour le mot de passe MySQL
kubectl create secret generic mysql-secret \
  --from-literal=password=mysqlpassword

# Vérifier le secret
kubectl get secrets
kubectl describe secret mysql-secret

# Voir le contenu (encodé en base64)
kubectl get secret mysql-secret -o yaml
```

**Note:** En production, utilisez des solutions comme Vault ou Sealed Secrets

## Étape 2 : Déployer MySQL

### Option A : Utiliser le manifeste fourni

```bash
# Appliquer le manifeste WordPress + MySQL
kubectl apply -f /vagrant/../../manifests/k8s/apps/wordpress-mysql.yaml

# Observer la création
kubectl get all
kubectl get pvc
```

### Option B : Créer manuellement (apprentissage)

```bash
# Créer le PVC pour MySQL
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF

# Créer le déploiement MySQL
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: password
        - name: MYSQL_DATABASE
          value: wordpress
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
EOF

# Créer le service MySQL
kubectl expose deployment mysql --port=3306
```

## Étape 3 : Vérifier MySQL

```bash
# Attendre que MySQL soit prêt
kubectl get pods -w

# Une fois prêt, tester la connexion
POD=$(kubectl get pod -l app=mysql -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD -- mysql -u root -pmysqlpassword -e "SHOW DATABASES;"
```

**Résultat attendu:** Liste des bases de données incluant 'wordpress'

## Étape 4 : Déployer WordPress

```bash
# Créer le PVC pour WordPress
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wordpress-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF

# Créer le déploiement WordPress
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 2
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: wordpress
        image: wordpress:6-apache
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql
        - name: WORDPRESS_DB_USER
          value: root
        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: password
        - name: WORDPRESS_DB_NAME
          value: wordpress
        ports:
        - containerPort: 80
        volumeMounts:
        - name: wordpress-storage
          mountPath: /var/www/html
      volumes:
      - name: wordpress-storage
        persistentVolumeClaim:
          claimName: wordpress-pvc
EOF

# Exposer WordPress
kubectl expose deployment wordpress --port=80 --type=NodePort
```

## Étape 5 : Accéder à WordPress

```bash
# Obtenir le NodePort
NODE_PORT=$(kubectl get service wordpress -o jsonpath='{.spec.ports[0].nodePort}')
echo "WordPress disponible sur : http://192.168.56.10:$NODE_PORT"

# Tester depuis le master
curl -I http://localhost:$NODE_PORT
```

Ouvrir dans votre navigateur : `http://192.168.56.10:<NODE_PORT>`

## Étape 6 : Vérifier la persistance

```bash
# Configurer WordPress dans le navigateur
# Puis supprimer le pod WordPress
POD=$(kubectl get pod -l app=wordpress -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD

# Attendre qu'un nouveau pod soit créé
kubectl get pods -w

# Rafraîchir le navigateur - la configuration est conservée!
```

**Observation:** Les données persistent car elles sont stockées dans le PVC

## Étape 7 : Tester la scalabilité

```bash
# Scaler WordPress
kubectl scale deployment wordpress --replicas=4

# Vérifier la distribution
kubectl get pods -o wide -l app=wordpress

# Tous les pods partagent le même volume
# Faire plusieurs requêtes
for i in {1..10}; do
  curl -s http://192.168.56.10:$NODE_PORT | grep -o "WordPress"
done
```

## Étape 8 : Explorer les logs

```bash
# Logs WordPress
kubectl logs -l app=wordpress --tail=20

# Logs MySQL
kubectl logs -l app=mysql --tail=20

# Suivre les logs en temps réel
kubectl logs -l app=wordpress -f
```

## Étape 9 : Débug et troubleshooting

```bash
# Vérifier la connectivité entre WordPress et MySQL
POD=$(kubectl get pod -l app=wordpress -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD -- bash

# Dans le pod WordPress:
apt update && apt install -y telnet
telnet mysql 3306
# Devrait se connecter

# Vérifier les variables d'environnement
env | grep WORDPRESS
exit
```

## Étape 10 : Analyser les ressources

```bash
# Vérifier l'utilisation des ressources
kubectl top pods
kubectl top nodes

# Voir les events
kubectl get events --sort-by='.lastTimestamp'

# Détails des PVC
kubectl describe pvc mysql-pvc
kubectl describe pvc wordpress-pvc
```

## Questions de réflexion

1. **Pourquoi utiliser un Secret plutôt qu'une variable d'environnement ?**
   - Meilleure sécurité, les secrets ne sont pas visible dans les specs

2. **Que se passe-t-il si le pod MySQL est supprimé ?**
   - Il est recréé et les données persistent grâce au PVC

3. **Peut-on scaler MySQL de la même façon que WordPress ?**
   - Non, car MySQL utilise ReadWriteOnce. Il faudrait une solution comme MySQL Cluster

4. **Comment WordPress trouve-t-il MySQL ?**
   - Via le DNS Kubernetes (service "mysql")

## Nettoyage

```bash
# Supprimer tous les objets
kubectl delete deployment wordpress mysql
kubectl delete service wordpress mysql
kubectl delete pvc wordpress-pvc mysql-pvc
kubectl delete secret mysql-secret
```

## Aller plus loin

### Exercice bonus 1 : Ajouter un Ingress

```bash
# Installer Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/baremetal/deploy.yaml

# Créer un Ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wordpress-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: wordpress.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: wordpress
            port:
              number: 80
EOF

# Ajouter à /etc/hosts sur votre machine
# 192.168.56.10 wordpress.local
```

### Exercice bonus 2 : Configurer les ressources

```bash
kubectl edit deployment wordpress

# Ajouter:
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Exercice bonus 3 : Backup de la base de données

```bash
# Créer un Job de backup
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: mysql-backup
spec:
  template:
    spec:
      containers:
      - name: backup
        image: mysql:8.0
        command:
        - /bin/sh
        - -c
        - mysqldump -h mysql -u root -pmysqlpassword wordpress > /backup/wordpress.sql
        volumeMounts:
        - name: backup
          mountPath: /backup
      volumes:
      - name: backup
        emptyDir: {}
      restartPolicy: Never
EOF
```

## Prochaines étapes

- [Scénario 3 : Stockage persistant avancé](03-persistent-storage.md)
- [Scénario 4 : Networking et Ingress](04-networking.md)

## Ressources

- [Documentation Kubernetes - Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Documentation Kubernetes - Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
