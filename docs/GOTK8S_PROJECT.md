# GOTK8S - Game Of Thrones Kubernetes

## Vision du projet

Un environnement d'apprentissage Kubernetes immersif basé sur l'univers Game of Thrones, où les étudiants déploient et gèrent les "Sept Royaumes" sous forme de microservices.

## Architecture globale - Les Sept Royaumes

```
                            ┌─────────────────────┐
                            │   King's Landing    │
                            │   (API Gateway)     │
                            │   Ingress/Traefik   │
                            └──────────┬──────────┘
                                       │
            ┌──────────────────────────┼──────────────────────────┐
            │                          │                          │
    ┌───────▼────────┐        ┌───────▼────────┐        ┌───────▼────────┐
    │   The North    │        │  Dorne         │        │  The Reach     │
    │   (Frontend)   │        │  (Frontend)    │        │  (Frontend)    │
    └───────┬────────┘        └───────┬────────┘        └───────┬────────┘
            │                         │                         │
    ┌───────▼────────┐        ┌───────▼────────┐        ┌───────▼────────┐
    │   Ravens API   │        │  Trade API     │        │  Harvest API   │
    │   (Messages)   │        │  (Commerce)    │        │  (Resources)   │
    └───────┬────────┘        └───────┬────────┘        └───────┬────────┘
            │                         │                         │
            └─────────────────────────┼──────────────────────── ┘
                                      │
                            ┌─────────▼──────────┐
                            │   The Citadel      │
                            │   (Database)       │
                            │   PostgreSQL       |
                            └────────────────────┘
```

## Les composants (Royaumes & Services)

### 1. **King's Landing** - API Gateway & Dashboard
- **Rôle:** Point d'entrée central, routage des requêtes
- **Technologies:** Traefik/Ingress NGINX, Dashboard de monitoring
- **Apprentissage:** Ingress, Load Balancing, TLS/SSL

### 2. **The North** - Service de messagerie
- **Rôle:** Système de messages (Ravens - Corbeaux)
- **Technologies:** React/Vue.js + Redis + WebSocket
- **Apprentissage:** StatefulSets, WebSockets, Sessions

### 3. **Dorne** - Service de commerce
- **Rôle:** Marché, échanges entre royaumes
- **Technologies:** API REST + MongoDB
- **Apprentissage:** Persistent Volumes, Secrets, ConfigMaps

### 4. **The Reach** - Service de ressources
- **Rôle:** Gestion des ressources (nourriture, or, armées)
- **Technologies:** GraphQL API + PostgreSQL
- **Apprentissage:** CronJobs, HPA (Auto-scaling)

### 5. **The Vale** - Service d'authentification
- **Rôle:** Gestion des utilisateurs et permissions
- **Technologies:** OAuth2/JWT + Redis
- **Apprentissage:** RBAC, Service Accounts, Network Policies

### 6. **The Riverlands** - Service de cache & performance
- **Rôle:** Cache distribué, CDN
- **Technologies:** Redis Cluster
- **Apprentissage:** StatefulSets, PV/PVC, Scaling

### 7. **The Westerlands** - Service de trésorerie
- **Rôle:** Gestion financière, paiements
- **Technologies:** API REST + Queue (RabbitMQ/Kafka)
- **Apprentissage:** Message Queues, Jobs, Worker Pods

### 8. **The Citadel** - Base de données centrale
- **Rôle:** Stockage des données historiques
- **Technologies:** PostgreSQL/MySQL en HA
- **Apprentissage:** Backup/Restore, Migrations, HA

### 9. **The Wall** - Monitoring & Sécurité
- **Rôle:** Surveillance du cluster
- **Technologies:** Prometheus, Grafana, Falco
- **Apprentissage:** Monitoring, Alerting, Security Policies

## Scénarios d'apprentissage progressifs

### Niveau 1 : "Winter is Coming" - Débutant
**Objectif:** Déployer les premiers royaumes

1. Déployer King's Landing (Ingress)
2. Déployer The North (Frontend simple)
3. Connecter The North à King's Landing
4. Exposer le service au monde extérieur

**Concepts:** Deployments, Services, Ingress

### Niveau 2 : "The War of Five Kings" - Intermédiaire
**Objectif:** Déployer plusieurs royaumes en interaction

5. Déployer The Citadel (PostgreSQL avec volumes)
6. Déployer Ravens API avec base de données
7. Créer des secrets pour les credentials
8. Mettre en place le scaling automatique

**Concepts:** PV/PVC, Secrets, ConfigMaps, HPA

### Niveau 3 : "The Long Night" - Avancé
**Objectif:** Résilience et haute disponibilité

9. Simuler une panne (tuer des pods)
10. Mettre en place la réplication de la BDD
11. Configurer les Network Policies (isolation)
12. Implémenter le monitoring complet

**Concepts:** HA, Network Policies, Monitoring, Troubleshooting

### Niveau 4 : "A Dream of Spring" - Expert
**Objectif:** CI/CD et production

13. Mettre en place un pipeline GitLab/Jenkins
14. Blue/Green deployments
15. Canary releases
16. Disaster Recovery

**Concepts:** CI/CD, GitOps, Advanced Deployments

## Défis techniques (Challenges)

### Challenge 1: "The Red Wedding"
Tous les pods d'un royaume sont tués. Les étudiants doivent restaurer le service.

**Apprentissage:** Disaster recovery, Backup/Restore

### Challenge 2: "The Battle of Blackwater"
Charge importante sur le système. Les étudiants doivent scaler.

**Apprentissage:** HPA, Resource limits, Load testing

### Challenge 3: "The Purple Wedding"
Faille de sécurité (pod compromis). Les étudiants doivent sécuriser.

**Apprentissage:** Network Policies, RBAC, Security

### Challenge 4: "The Battle of the Bastards"
Déployer une nouvelle version sans downtime.

**Apprentissage:** Rolling updates, Blue/Green, Canary

## Technologies utilisées

### Frontend
- React/Vue.js pour les interfaces
- Nginx comme serveur web
- WebSocket pour temps réel

### Backend
- Node.js / Python / Go pour les APIs
- Express / FastAPI / Gin
- REST et GraphQL

### Bases de données
- PostgreSQL (relationnel)
- MongoDB (NoSQL)
- Redis (cache/sessions)

### Message Queue
- RabbitMQ ou Kafka
- Pour communication asynchrone

### Monitoring
- Prometheus (métriques)
- Grafana (visualisation)
- ELK Stack (logs)
- Jaeger (tracing)

### Sécurité
- Falco (runtime security)
- OPA (policies)
- Cert-Manager (TLS)

## Structure des fichiers

```
GOK8S/
├── kingdoms/                    # Code source des applications
│   ├── kings-landing/          # API Gateway
│   │   ├── Dockerfile
│   │   └── src/
│   ├── the-north/              # Service messagerie
│   │   ├── frontend/
│   │   ├── backend/
│   │   └── k8s/
│   ├── dorne/                  # Service commerce
│   ├── the-reach/              # Service ressources
│   ├── the-vale/               # Service auth
│   ├── the-riverlands/         # Cache
│   ├── the-westerlands/        # Finance
│   └── the-citadel/            # Database
│
├── manifests/
│   ├── 01-namespace.yaml
│   ├── 02-ingress/
│   ├── 03-kingdoms/            # Déploiements par royaume
│   ├── 04-databases/
│   ├── 05-monitoring/
│   └── 06-security/
│
├── scenarios/                   # Scénarios d'apprentissage
│   ├── 01-winter-is-coming/
│   ├── 02-war-of-five-kings/
│   ├── 03-the-long-night/
│   └── 04-dream-of-spring/
│
├── challenges/                  # Défis techniques
│   ├── red-wedding/
│   ├── battle-of-blackwater/
│   └── purple-wedding/
│
└── docs/
    ├── architecture.md
    ├── deployment-guide.md
    └── challenges-guide.md
```

## Fonctionnalités des applications

### The North - Messagerie
- Envoi de messages entre utilisateurs (Ravens)
- Chat en temps réel
- Historique des messages
- Notifications

### Dorne - Commerce
- Marketplace de ressources
- Transactions entre royaumes
- Historique des échanges
- Tarification dynamique

### The Reach - Ressources
- Visualisation des stocks
- Production de ressources (CronJobs)
- Alertes sur pénuries
- API GraphQL

### The Vale - Authentification
- Inscription / Connexion
- JWT tokens
- Rôles et permissions
- OAuth2

## Métriques et objectifs pédagogiques

### Ce que les étudiants vont apprendre

**Kubernetes Core:**
- ✅ Pods, Deployments, StatefulSets
- ✅ Services (ClusterIP, NodePort, LoadBalancer)
- ✅ Ingress et routing
- ✅ ConfigMaps et Secrets
- ✅ PersistentVolumes et Claims

**Avancé:**
- ✅ Horizontal Pod Autoscaling
- ✅ Network Policies
- ✅ RBAC et Service Accounts
- ✅ Jobs et CronJobs
- ✅ DaemonSets

**DevOps:**
- ✅ CI/CD avec GitLab/Jenkins
- ✅ Helm charts
- ✅ GitOps avec ArgoCD
- ✅ Blue/Green deployments
- ✅ Canary releases

**Observabilité:**
- ✅ Prometheus et métriques
- ✅ Grafana dashboards
- ✅ Logging avec ELK
- ✅ Distributed tracing

**Sécurité:**
- ✅ Network isolation
- ✅ Pod Security Policies
- ✅ Secrets management
- ✅ Runtime security

## Roadmap de développement

### Phase 1 (2 semaines)
- Architecture et design
- Setup de base Vagrant
- Première application (The North)
- Documentation initiale

### Phase 2 (3 semaines)
- Développement des 7 royaumes
- APIs et bases de données
- Manifestes Kubernetes
- Tests d'intégration

### Phase 3 (2 semaines)
- Scénarios d'apprentissage
- Défis techniques
- Monitoring et observabilité
- Documentation complète

### Phase 4 (1 semaine)
- Tests avec des étudiants
- Corrections et améliorations
- Release finale

## Contribution

Projet open source, contributions bienvenues !

## Licence

MIT License - Pour l'éducation

---

**"When you play the game of Kubernetes, you win or you learn."**
