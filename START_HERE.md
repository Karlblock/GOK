#  GOK8S - Commencer Ici

##  Démarrage Ultra-Rapide (2 commandes)

```bash
# 1. Déployer le cluster multi-node
./k3d-deploy

# 2. Lancer le CLI d'apprentissage
./gok-learn
```
---

## Structure du Projet

```
GOK8S/
├── k3d-deploy       → Déployer avec k3d (multi-node) ⭐
├── k3d-cleanup      → Nettoyer k3d
├── gok-learn        → CLI interactif d'apprentissage ⭐
│
├── scripts/         → Tous les scripts
│   ├── k3d-*.sh        (k3d multi-node - recommandé)
│   └── gok-*.sh        (kind single-node - fallback)
│
├── docs/            → Toute la documentation
│   ├── INDEX.md        (index complet)
│   ├── CHEATSHEET.md   (commandes rapides) ⭐
│   ├── K3D_VS_KIND.md  (k3d vs kind)
│   └── LEARNING_CLI.md (guide CLI)
│
├── kingdoms/        → Code source des applications
├── manifests/       → Manifests Kubernetes
├── scenarios/       → Scénarios d'apprentissage
└── kind/            → Configuration kind (legacy)
```

---

## 🎓 Pour Apprendre Kubernetes

### Étape 1 : Déployer
```bash
./k3d-deploy
```

### Étape 2 : Apprendre
```bash
./gok-learn
```

Dans le CLI :
- **Menu 1** → Tutoriels Pods, Deployments, Services
- **Menu 4** → Challenge "The Red Wedding"
- **Menu 5** → Voir ta progression

---

## 📚 Documentation Rapide

| Document | Quand l'utiliser |
|----------|------------------|
| [CHEATSHEET.md](CHEATSHEET.md) | Commandes kubectl rapides |
| [K3D_VS_KIND.md](K3D_VS_KIND.md) | Comprendre k3d vs kind |
| [docs/LEARNING_CLI.md](docs/LEARNING_CLI.md) | Détails du CLI interactif |
| [docs/INDEX.md](docs/INDEX.md) | Index complet de la doc |

---

## ❓ Questions Fréquentes

### Pourquoi k3d et pas kind ?
→ Voir [K3D_VS_KIND.md](K3D_VS_KIND.md)
TL;DR : k3d fonctionne en multi-node avec cgroup v2, kind non.

### J'ai des workers avec kind ?
→ Non, problème cgroup v2. Voir [docs/TROUBLESHOOTING_KIND.md](docs/TROUBLESHOOTING_KIND.md)

### Où sont les URLs ?
- Frontend : http://localhost:30100
- API : http://localhost:30101

### Comment nettoyer ?
```bash
./k3d-cleanup
```

---

## 🎯 Workflows

### Première Utilisation
```bash
./k3d-deploy     # Déploie tout (2-3 min)
./gok-learn      # Lance le CLI
```

### Sessions Suivantes
```bash
./gok-learn      # Le cluster existe déjà
```

### Fin du TP
```bash
./k3d-cleanup    # Nettoie tout (30 sec)
```

---

## 🆘 Problèmes ?

1. **Le cluster ne démarre pas**
   ```bash
   ./k3d-cleanup
   ./k3d-deploy
   ```

2. **Les pods ne démarrent pas**
   ```bash
   kubectl get pods -n westeros
   kubectl describe pod <pod-name> -n westeros
   ```

3. **k3d n'est pas installé**
   ```bash
   mkdir -p ~/bin
   curl -Lo ~/bin/k3d https://github.com/k3d-io/k3d/releases/download/v5.6.0/k3d-linux-amd64
   chmod +x ~/bin/k3d
   ```

Plus de détails : [docs/TROUBLESHOOTING_KIND.md](docs/TROUBLESHOOTING_KIND.md)

---

## 🎊 Résumé

✅ **Multi-node** : 1 server + 2 agents (avec k3d)
✅ **CLI interactif** : Tutoriels + Challenges GOT
✅ **Léger** : ~2-3 GB (vs 48,2 GB pour la VM)
✅ **Rapide** : Déploiement en 2-3 minutes

**Commence maintenant** :
```bash
./k3d-deploy && ./gok-learn
```

---

Winter is Coming... Learn Kubernetes! 🐺
