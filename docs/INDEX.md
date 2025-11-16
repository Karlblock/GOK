# Documentation GOK8S

## 🚀 Démarrage Rapide

- **[CHEATSHEET.md](CHEATSHEET.md)** - Commandes rapides et aide-mémoire
- **[QUICKSTART.md](QUICKSTART.md)** - Guide de démarrage rapide
- **[K3D_VS_KIND.md](K3D_VS_KIND.md)** - k3d vs kind : Pourquoi multi-node avec k3d ?

## 📚 Guides Utilisateur

### Pour les Étudiants
- **[GUIDE_ETUDIANT.md](GUIDE_ETUDIANT.md)** - Guide complet pour les étudiants
- **[LEARNING_CLI.md](LEARNING_CLI.md)** - Utilisation du CLI interactif d'apprentissage
- **[../scenarios/](../scenarios/)** - Scénarios d'apprentissage progressifs

### Pour les Enseignants
- **[GUIDE_ENSEIGNANT.md](GUIDE_ENSEIGNANT.md)** - Guide pour les enseignants
- **[GOTK8S_PROJECT.md](GOTK8S_PROJECT.md)** - Architecture complète du projet

## 🔧 Installation & Configuration

- **[installation.md](installation.md)** - Guide d'installation détaillé
- **[ANSIBLE_SETUP.md](ANSIBLE_SETUP.md)** - Configuration avec Ansible (avancé)

## 🐛 Dépannage

- **[TROUBLESHOOTING_KIND.md](TROUBLESHOOTING_KIND.md)** - Problème workers kind + cgroup v2
- **[FIX_MULTINODE.md](FIX_MULTINODE.md)** - Solutions pour avoir le multi-node
- **[troubleshooting.md](troubleshooting.md)** - Dépannage général
- **[PROBLEMES_RESOLUS.md](PROBLEMES_RESOLUS.md)** - Problèmes courants résolus

## 📦 Migration & Résumés

- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Migration VM VirtualBox → kind/k3d
- **[RESUME_SCRIPTS.md](RESUME_SCRIPTS.md)** - Résumé détaillé des scripts
- **[FINAL_SUMMARY.txt](FINAL_SUMMARY.txt)** - Résumé complet du projet
- **[GOK_SCRIPTS_README.txt](GOK_SCRIPTS_README.txt)** - Quick reference des scripts

## 📜 Historique & Développement

- **[CHANGELOG.md](CHANGELOG.md)** - Historique des versions
- **[OVA_CREATION_GUIDE.md](OVA_CREATION_GUIDE.md)** - Guide création VM OVA (legacy)
- **[OVA_FINAL_CHECKLIST.md](OVA_FINAL_CHECKLIST.md)** - Checklist VM OVA (legacy)

## 🎯 Documents par Cas d'Usage

### Je veux démarrer rapidement
1. [QUICKSTART.md](QUICKSTART.md)
2. [CHEATSHEET.md](CHEATSHEET.md)

### Je veux comprendre pourquoi k3d
1. [K3D_VS_KIND.md](K3D_VS_KIND.md)
2. [TROUBLESHOOTING_KIND.md](TROUBLESHOOTING_KIND.md)

### Je veux apprendre Kubernetes
1. [LEARNING_CLI.md](LEARNING_CLI.md)
2. [../scenarios/](../scenarios/)
3. Lancer `../gok-learn`

### J'ai un problème
1. [TROUBLESHOOTING_KIND.md](TROUBLESHOOTING_KIND.md)
2. [FIX_MULTINODE.md](FIX_MULTINODE.md)
3. [troubleshooting.md](troubleshooting.md)

### Je veux migrer depuis la VM
1. [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
2. [QUICKSTART.md](QUICKSTART.md)

## 📁 Structure de la Documentation

```
docs/
├── INDEX.md                    # Ce fichier
├── CHEATSHEET.md              # ⭐ Commandes rapides
├── QUICKSTART.md              # ⭐ Guide de démarrage
├── K3D_VS_KIND.md             # ⭐ k3d vs kind
├── LEARNING_CLI.md            # ⭐ CLI interactif
├── GUIDE_ETUDIANT.md          # Pour étudiants
├── GUIDE_ENSEIGNANT.md        # Pour enseignants
├── GOTK8S_PROJECT.md          # Architecture projet
├── installation.md            # Installation détaillée
├── TROUBLESHOOTING_KIND.md    # Debug kind
├── FIX_MULTINODE.md           # Solutions multi-node
├── troubleshooting.md         # Dépannage général
├── MIGRATION_GUIDE.md         # Migration VM
├── RESUME_SCRIPTS.md          # Résumé scripts
├── FINAL_SUMMARY.txt          # Résumé complet
├── CHANGELOG.md               # Historique
├── OVA_*.md                   # Docs OVA (legacy)
└── scenarios/                 # Scénarios d'apprentissage
```

## 🔗 Liens Externes

- [Documentation Kubernetes](https://kubernetes.io/docs/)
- [Documentation k3d](https://k3d.io/)
- [Documentation kind](https://kind.sigs.k8s.io/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---

⭐ = Documents recommandés en priorité
