# GOTK8S OVA - Checklist Finale

## ✅ VM Complètement Configurée

### 📦 Logiciels Installés
- ✅ Docker 28.2.2
- ✅ Vagrant 2.4.9
- ✅ kubectl 1.28.15
- ✅ VirtualBox 6.1.50
- ✅ VS Code 1.105.1
- ✅ Git, Vim, Build tools

### 🎨 Personnalisation Game of Thrones
- ✅ Prompt bash avec emoji 🐺
- ✅ Message d'accueil GoT (MOTD)
- ✅ Citations aléatoires Game of Thrones
- ✅ Aliases thématiques (winter, castle, raven, etc.)
- ✅ Icônes bureau personnalisées
- ✅ Thème terminal sombre
- ✅ VIM configuré

### 🏰 Projet GOTK8S
- ✅ Dossier ~/GOK8S avec tous les fichiers
- ✅ Images Docker buildées :
  - gotk8s/the-north-api:1.0 (158 MB)
  - gotk8s/the-north-frontend:1.0 (52.9 MB)
- ✅ Box Vagrant ubuntu/jammy64 téléchargée
- ✅ Scripts de démarrage sur le Bureau

### 📚 Documentation
- ✅ GUIDE_ETUDIANT.md
- ✅ GUIDE_ENSEIGNANT.md
- ✅ Scénarios pédagogiques
- ✅ README sur le Bureau

## 🎯 Prochaines Étapes - Finaliser l'OVA

### 1. Dans la VM (faceless@192.168.56.9)

```bash
# Nettoyer l'historique
history -c
rm -f ~/.bash_history

# Nettoyer les fichiers temporaires
sudo apt autoremove -y
sudo apt clean
rm -rf /tmp/*
rm -rf ~/.cache/*

# Vider les logs système
sudo journalctl --vacuum-time=1d

# Optionnel: Remplir l'espace libre de zéros (réduit la taille OVA)
# ATTENTION: Prend du temps et de l'espace
# sudo dd if=/dev/zero of=/EMPTY bs=1M || true
# sudo rm -f /EMPTY

# Éteindre la VM
sudo shutdown -h now
```

### 2. Sur votre machine hôte (Parrot OS)

```bash
# Attendre que la VM soit complètement éteinte
# Vérifier l'état
VBoxManage showvminfo "GOTK8S-Student-VM" | grep State

# Exporter en OVA
cd ~/IUT/r509/GOK8S/ova
./export-ova.sh

# Ou manuellement:
VBoxManage export "GOTK8S-Student-VM" \
    --output ~/GOTK8S-v1.0.ova \
    --manifest \
    --vsys 0 \
    --product "GOTK8S - Game Of Thrones Kubernetes Lab" \
    --producturl "https://github.com/VOTRE-REPO/GOK8S" \
    --vendor "GOTK8S Project" \
    --version "1.0" \
    --description "Environnement d'apprentissage Kubernetes clé en main basé sur Game of Thrones"
```

### 3. Vérification de l'OVA

```bash
# Vérifier la taille
ls -lh ~/GOTK8S-v1.0.ova

# Générer le checksum
sha256sum ~/GOTK8S-v1.0.ova > ~/GOTK8S-v1.0.ova.sha256

# Tester l'import
VBoxManage import ~/GOTK8S-v1.0.ova --dry-run
```

## 📋 Configuration de la VM

| Paramètre | Valeur |
|-----------|--------|
| **Nom** | GOTK8S-Student-VM |
| **RAM** | 8 Go |
| **CPU** | 4 cores |
| **Disque** | 80 Go (dynamique) |
| **Réseau** | NAT + Host-only (vboxnet0) |
| **IP** | 192.168.56.9 |
| **Nested Virt** | Activé |
| **OS** | Ubuntu 22.04.5 LTS Desktop |
| **Utilisateur** | faceless |
| **Password** | faceless |
| **Hostname** | GOTK8S |

## 🎓 Instructions pour les Étudiants

### Import de l'OVA (5 minutes)

1. Télécharger `GOTK8S-v1.0.ova`
2. Ouvrir VirtualBox
3. **Fichier** > **Importer un appareil virtuel**
4. Sélectionner le fichier .ova
5. Cliquer sur **Importer**
6. Démarrer la VM

### Connexion

- **Utilisateur:** faceless
- **Mot de passe:** faceless

### Premier Démarrage (15-20 minutes)

Sur le Bureau, double-cliquer sur `START-GOTK8S.sh`

Cela va :
- Démarrer le cluster Kubernetes (3 VMs)
- Déployer les applications The North
- Configurer kubectl

### Accès aux Services

- **Frontend:** http://192.168.56.9:30100
- **API:** http://192.168.56.9:30101

### Commandes Personnalisées Game of Thrones

```bash
winter          # Voir les pods (kubectl get pods -n westeros)
castle          # Voir les nodes (kubectl get nodes)
rally           # Voir tout (kubectl get all -n westeros)
raven <pod>     # Voir les logs (kubectl logs -f)
raise-army      # Démarrer le cluster (vagrant up)
stand-down      # Arrêter le cluster (vagrant halt)
```

## 📊 Taille Estimée de l'OVA

- **Avant compression:** ~25-30 Go
- **Après export OVA:** ~12-15 Go
- **Téléchargement étudiant:** ~15 minutes (100 Mbps)

## 🚀 Distribution

### Options de Distribution

**Option 1: Serveur Web École**
```bash
scp ~/GOTK8S-v1.0.ova user@serveur:/partage/cours/kubernetes/
```

**Option 2: Cloud (Google Drive, OneDrive)**
- Téléverser l'OVA
- Partager le lien avec les étudiants

**Option 3: Clés USB**
- Copier sur plusieurs clés USB
- Distribuer en classe

### Fichiers à Distribuer

1. `GOTK8S-v1.0.ova` (12-15 Go)
2. `GOTK8S-v1.0.ova.sha256` (checksum)
3. `INSTRUCTIONS_ETUDIANTS.pdf` (à créer)

## ✅ Checklist Pré-Export

Avant d'exporter l'OVA, vérifier que :

- [ ] Tous les logiciels sont installés et fonctionnent
- [ ] Les images Docker sont buildées
- [ ] La box Vagrant est téléchargée
- [ ] Les scripts Desktop fonctionnent
- [ ] Le thème GoT est appliqué
- [ ] La documentation est complète
- [ ] L'historique bash est nettoyé
- [ ] Les fichiers temporaires sont supprimés
- [ ] La VM est éteinte proprement

## 🎉 Résultat Final

Les étudiants auront une VM prête en **3 minutes** au lieu de **40 minutes** !

### Gain de Temps par Étudiant

| Étape | Sans OVA | Avec OVA |
|-------|----------|----------|
| Installation Ubuntu | 20 min | ✅ Inclus |
| Installation outils | 30 min | ✅ Inclus |
| Clone projet | 5 min | ✅ Inclus |
| Build images | 10 min | ✅ Inclus |
| Download box Vagrant | 15 min | ✅ Inclus |
| Configuration | 10 min | ✅ Inclus |
| **TOTAL** | **90 min** | **3 min** |

**Économie:** 87 minutes par étudiant !

Pour une classe de 30 étudiants : **43,5 heures économisées** ! 🚀

## 🐺 Winter is Coming...

Votre OVA GOTK8S est prête à conquérir les Sept Royaumes de l'enseignement Kubernetes ! ❄️

---

**Créé par:** GOTK8S Project
**Version:** 1.0
**Date:** Novembre 2024
**Licence:** MIT
