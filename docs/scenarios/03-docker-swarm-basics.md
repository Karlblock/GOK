# Scénario 3 : Les bases de Docker Swarm

**Niveau:** Débutant
**Durée estimée:** 40 minutes
**Lab requis:** DOCKER-SWARM

## Objectifs

- Comprendre l'architecture Docker Swarm
- Déployer et gérer des services
- Utiliser les stacks Docker Compose
- Scaler et mettre à jour des services
- Exploiter la résilience du Swarm

## Prérequis

- Lab DOCKER-SWARM déployé
- Accès SSH au manager : `vagrant ssh manager`

## Architecture Docker Swarm

```
┌─────────────────────────────────────┐
│         Manager Node                │
│   - Orchestration                   │
│   - Scheduling                      │
│   - API Swarm                       │
└─────────────────────────────────────┘
              │
       ┌──────┴──────┐
       │             │
┌──────▼─────┐ ┌────▼──────┐
│  Worker 1  │ │  Worker 2 │
│            │ │           │
└────────────┘ └───────────┘
```

## Étape 1 : Explorer le cluster

```bash
# Se connecter au manager
vagrant ssh manager

# Voir les nœuds du swarm
docker node ls

# Détails d'un nœud
docker node inspect swarm-manager --pretty

# Voir les services en cours
docker service ls

# Voir les réseaux
docker network ls | grep overlay
```

**Résultat attendu:** 1 manager + 2 workers, tous en état "Ready"

## Étape 2 : Déployer un premier service

```bash
# Créer un service simple
docker service create \
  --name web \
  --replicas 3 \
  --publish published=8080,target=80 \
  nginx:alpine

# Vérifier le service
docker service ls

# Voir les tâches (containers) du service
docker service ps web

# Voir les logs
docker service logs web
```

**Observation:** Les 3 replicas sont distribués sur les différents nœuds

## Étape 3 : Tester l'accès au service

```bash
# Depuis le manager
curl http://localhost:8080

# Faire plusieurs requêtes pour voir le load balancing
for i in {1..5}; do
  curl -s http://localhost:8080 | grep -o "Welcome to nginx"
done

# Depuis votre machine hôte
curl http://192.168.56.30:8080
```

**Observation:** Le swarm fait du load balancing automatique entre les replicas

## Étape 4 : Scaler le service

```bash
# Augmenter le nombre de replicas
docker service scale web=6

# Observer le scaling
docker service ps web

# Vérifier la distribution
docker service ps web --format "{{.Node}} {{.CurrentState}}"

# Réduire à 2 replicas
docker service scale web=2

# Observer
docker service ps web
```

## Étape 5 : Mettre à jour un service

```bash
# Mettre à jour l'image
docker service update \
  --image nginx:1.25-alpine \
  web

# Observer le rolling update
watch docker service ps web

# Vérifier l'historique
docker service inspect web --pretty
```

**Observation:** Le update se fait progressivement (rolling update)

## Étape 6 : Tester la résilience

```bash
# Identifier un container du service
CONTAINER_ID=$(docker ps | grep web | head -n1 | cut -d' ' -f1)

# Le supprimer
docker rm -f $CONTAINER_ID

# Observer que Swarm recrée automatiquement un container
docker service ps web

# Vérifier que le service reste accessible
curl http://localhost:8080
```

**Observation:** Le service reste disponible, Swarm garantit le nombre de replicas

## Étape 7 : Utiliser les contraintes de placement

```bash
# Créer un service qui ne tourne que sur le manager
docker service create \
  --name manager-only \
  --constraint 'node.role==manager' \
  --replicas 1 \
  alpine ping 8.8.8.8

# Vérifier où il tourne
docker service ps manager-only

# Créer un service distribué uniquement sur les workers
docker service create \
  --name workers-only \
  --constraint 'node.role==worker' \
  --replicas 2 \
  alpine ping 8.8.8.8

# Vérifier
docker service ps workers-only
```

## Étape 8 : Déployer une stack complète

```bash
# Créer un fichier docker-compose.yml
cat > /tmp/demo-stack.yml <<EOF
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8081:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
    networks:
      - demo-net

  redis:
    image: redis:alpine
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == manager
    networks:
      - demo-net

  visualizer:
    image: dockersamples/visualizer
    ports:
      - "8082:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      placement:
        constraints:
          - node.role == manager
    networks:
      - demo-net

networks:
  demo-net:
    driver: overlay
    attachable: true
EOF

# Déployer la stack
docker stack deploy -c /tmp/demo-stack.yml demo

# Vérifier la stack
docker stack ls
docker stack services demo
docker stack ps demo
```

## Étape 9 : Explorer la stack déployée

```bash
# Voir tous les services de la stack
docker service ls --filter label=com.docker.stack.namespace=demo

# Logs d'un service spécifique
docker service logs demo_web

# Vérifier le réseau
docker network inspect demo_demo-net

# Accéder au visualizer
echo "Visualizer: http://192.168.56.30:8082"
```

Ouvrir dans le navigateur pour voir une représentation graphique du swarm

## Étape 10 : Mettre à jour la stack

```bash
# Modifier le fichier
sed -i 's/replicas: 3/replicas: 5/' /tmp/demo-stack.yml

# Redéployer (mise à jour)
docker stack deploy -c /tmp/demo-stack.yml demo

# Observer les changements
docker service ps demo_web
```

**Observation:** Seuls les changements sont appliqués (update incrémental)

## Étape 11 : Utiliser des secrets

```bash
# Créer un secret
echo "super_secret_password" | docker secret create db_password -

# Vérifier
docker secret ls

# Créer un service utilisant le secret
docker service create \
  --name db \
  --secret db_password \
  -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_password \
  mysql:8.0

# Le secret est monté dans /run/secrets/
docker service ps db
```

## Étape 12 : Monitoring avec Portainer

```bash
# Portainer devrait déjà être déployé
docker service ls | grep portainer

# Accéder à Portainer
echo "Portainer: http://192.168.56.30:9000"
```

Dans Portainer :
1. Créer un compte admin
2. Explorer le cluster Swarm
3. Gérer les services via l'interface

## Questions de réflexion

1. **Quelle est la différence entre un service et un container ?**
   - Un service est une abstraction qui gère plusieurs containers (replicas)

2. **Comment le routing mesh fonctionne-t-il ?**
   - Tous les nœuds acceptent les connexions sur les ports publiés et les routent vers un container approprié

3. **Que se passe-t-il si un nœud tombe ?**
   - Swarm redémarre les services sur les autres nœuds disponibles

4. **Différence entre Swarm mode et Kubernetes ?**
   - Swarm : plus simple, intégré à Docker
   - K8s : plus features, écosystème plus large, plus complexe

## Nettoyage

```bash
# Supprimer la stack
docker stack rm demo

# Supprimer les services individuels
docker service rm web manager-only workers-only db

# Supprimer le secret
docker secret rm db_password

# Vérifier
docker service ls
```

## Aller plus loin

### Exercice bonus 1 : Limiter les ressources

```bash
docker service create \
  --name limited \
  --replicas 2 \
  --reserve-memory 128M \
  --limit-memory 256M \
  --reserve-cpu 0.5 \
  --limit-cpu 1.0 \
  nginx:alpine

# Vérifier
docker service inspect limited --pretty
```

### Exercice bonus 2 : Health checks

```bash
docker service create \
  --name healthy-web \
  --replicas 3 \
  --health-cmd "curl -f http://localhost/ || exit 1" \
  --health-interval 30s \
  --health-retries 3 \
  --health-timeout 5s \
  nginx:alpine

# Observer les health checks
docker service ps healthy-web
```

### Exercice bonus 3 : Global service

```bash
# Service qui tourne sur tous les nœuds
docker service create \
  --name node-exporter \
  --mode global \
  --mount type=bind,source=/,target=/host,readonly \
  prom/node-exporter

# Vérifier - devrait avoir 3 instances (1 par nœud)
docker service ps node-exporter
```

### Exercice bonus 4 : Déployer le monitoring

```bash
# Utiliser la stack de monitoring fournie
docker stack deploy -c /vagrant/../../manifests/docker/stacks/monitoring-stack.yml monitoring

# Accéder
echo "Prometheus: http://192.168.56.30:9090"
echo "Grafana: http://192.168.56.30:3000"
# Login Grafana: admin/admin
```

## Comparaison avec Kubernetes

| Feature | Docker Swarm | Kubernetes |
|---------|--------------|------------|
| Complexité | Simple | Complexe |
| Installation | Facile | Plus difficile |
| Scaling | Facile | Avancé |
| Écosystème | Docker | Large |
| Load Balancing | Intégré | Require Ingress |
| Auto-healing | Oui | Oui |
| Rolling updates | Oui | Oui |
| Multi-cloud | Limité | Excellent |

## Prochaines étapes

- [Scénario 4 : Kubernetes Networking](04-k8s-networking.md)
- [Scénario 5 : CI/CD Pipeline](05-cicd-pipeline.md)

## Ressources

- [Documentation Docker Swarm](https://docs.docker.com/engine/swarm/)
- [Docker Compose pour Swarm](https://docs.docker.com/compose/compose-file/)
- [Secrets Management](https://docs.docker.com/engine/swarm/secrets/)
