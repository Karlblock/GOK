# Changelog - GOK8S / GOTK8S

## [v1.0] - 2025-11-09

### Migration Vagrant → kind

**Changement majeur** : Le projet est passé de Vagrant à kind (Kubernetes IN Docker)

**Raison** : Problèmes de nested virtualization avec VirtualBox dans un environnement de VM hôte

**Avantages** :
- 10x plus rapide : 30-60 secondes vs 20-25 minutes
- Plus stable : Pas de nested virtualization
- Moins de ressources : Utilise Docker au lieu de VMs complètes
- Standard de l'industrie : kind est utilisé par les projets Kubernetes officiels

### Modifications importantes

#### 1. Frontend corrigé - index.html

**Fichier** : `kingdoms/the-north/frontend/index.html` (lignes 309-311)

**Problème** : L'application frontend ne pouvait pas se connecter à l'API depuis une machine hôte

**Cause** : API_URL utilisait le port 3000 au lieu du NodePort 30101

**Solution** :
```javascript
const API_URL = window.location.hostname === 'localhost'
    ? 'http://localhost:30101'
    : `http://${window.location.hostname}:30101`;
```

**Impact** : Frontend maintenant pleinement fonctionnel en accès externe (192.168.56.11:30100)

#### 2. Script de chargement d'images - load-images-to-k8s.sh

**Fichier** : `kingdoms/load-images-to-k8s.sh`

**Modification** : Complètement réécrit pour kind

**Ancien** : Utilisait vagrant ssh et scp vers les nœuds VMs
**Nouveau** : Utilise `kind load image-archive`

**Exemple** :
```bash
kind load image-archive the-north-api.tar --name gotk8s
kind load image-archive the-north-frontend.tar --name gotk8s
```

#### 3. Configuration cluster kind

**Fichier** : `kind/cluster-config.yaml`

**Configuration** :
- 1 nœud control-plane
- 2 nœuds worker
- Port mappings pour NodePorts (30100, 30101)

#### 4. Documentation mise à jour

**Fichiers mis à jour** :
- `README.md` - Instructions d'installation kind
- `GUIDE_ENSEIGNANT.md` - Procédures avec kind
- `GUIDE_ETUDIANT.md` - Commandes adaptées à kind
- `GOTK8S_PROJECT.md` - Architecture actualisée

**Changements clés** :
- Toutes les références à Vagrant remplacées par kind
- Commandes kubectl adaptées (localhost au lieu de 192.168.56.x pour les étudiants)
- Procédures d'installation simplifiées

### Tests effectués

#### Scénario 1 : "Winter is Coming" - Complet ✅

**Toutes les missions testées** :
1. Création namespace avec quotas ✅
2. Déploiement Redis ✅
3. Déploiement API ✅
4. Déploiement Frontend ✅
5. Exposition NodePort ✅
6. Test application (envoi ravens, WebSocket temps réel) ✅
7. Scaling (2 → 3 replicas) ✅
8. Résilience (auto-recovery des pods) ✅
9. Monitoring et logs ✅

**Résultats** :
- Tous les pods démarrent correctement
- Load balancing fonctionne
- Application accessible depuis l'hôte
- WebSocket temps réel fonctionnel
- Scaling et résilience validés

### VM GOK v1.0 - OVA exportée

**Fichier** : `GOK-v1.0.ova` (4.4 GB)
**SHA256** : `9db091afb0d095d8853b66c92feb998c3dcc33226c729e22d0551bbc59737014`

**Contenu** :
- Ubuntu 24.04 Server
- Docker 28.5.2
- kind 0.20.0
- kubectl v1.28.15
- Projet GOK8S complet (~140MB)
- Images Docker pré-chargées
- Scripts de démarrage (start-cluster.sh, stop-cluster.sh)
- MOTD personnalisé
- Configuration réseau dual NIC (NAT + Host-Only)

**Credentials** : faceless / faceless
**IP** : 192.168.56.11

**État** : Environnement nettoyé pour les étudiants
- Namespace supprimé
- Cluster arrêté
- Historique bash nettoyé
- Images Docker conservées pour déploiement rapide

### Fichiers créés

**Sur VM** :
- `~/start-cluster.sh` - Démarre cluster kind
- `~/stop-cluster.sh` - Arrête cluster kind
- `/etc/motd` - Banner GOK8S

**Documentation** :
- `GOK-GUIDE-DEMARRAGE.md` - Guide rapide pour enseignants/étudiants

### Points d'attention

#### Pour les enseignants

1. **Port mapping** : Les NodePorts sont accessibles via localhost dans la VM, ou via 192.168.56.11 depuis l'hôte
2. **Persistence** : Les images Docker sont conservées même après `kind delete cluster`
3. **Temps de déploiement** : ~2 minutes pour un déploiement complet (cluster + app)

#### Pour les étudiants

1. **Premiers pas** : Toujours démarrer par `~/start-cluster.sh`
2. **Vérification** : `kubectl get nodes` doit montrer 3 nœuds Ready
3. **URL frontend** : http://localhost:30100 (dans la VM) ou http://192.168.56.11:30100 (depuis l'hôte)

### Améliorations futures

**Prévues** :
- [ ] Ajouter les autres royaumes (Dorne, The Reach, etc.)
- [ ] Implémenter les scénarios avancés
- [ ] Ajouter Prometheus/Grafana pour monitoring
- [ ] Network policies pour isolation inter-royaumes
- [ ] Ingress controller (nginx) pour routing avancé

**En cours de réflexion** :
- [ ] Helm charts pour déploiements simplifiés
- [ ] GitOps avec ArgoCD
- [ ] Service mesh (Istio/Linkerd)
- [ ] CI/CD pipeline exemple

### Breaking Changes

⚠️ **Incompatibilité avec versions précédentes Vagrant**

Si vous avez utilisé une version Vagrant :
1. Supprimer les VMs Vagrant : `vagrant destroy -f`
2. Cloner la nouvelle version du repo
3. Installer Docker et kind
4. Suivre les nouvelles instructions d'installation

**Les manifests K8s restent compatibles** - Seule la méthode de déploiement du cluster change.

### Contributeurs

- Mise à jour : kless
- Tests : kless
- Documentation : kless

### Liens utiles

- **Repository** : https://github.com/Karlblock/GOTK8S
- **kind documentation** : https://kind.sigs.k8s.io/
- **Issues** : https://github.com/Karlblock/GOTK8S/issues

---

**"Winter is Coming... and so is Kubernetes mastery!"** ❄️🐺
