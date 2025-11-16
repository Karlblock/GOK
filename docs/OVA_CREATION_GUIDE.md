# Guide de création de l'OVA GOTK8S

## 🎯 Objectif

Créer une VM VirtualBox (.ova) préinstallée avec tout GOTK8S, permettant aux étudiants de :
1. Importer l'OVA dans VirtualBox
2. Démarrer la VM
3. Lancer `vagrant up` dans le cluster
4. Commencer le TP immédiatement

**Gain de temps étudiant :** De 30-40 min à 2-3 min ! ⚡

## 📦 Contenu de l'OVA

### VM de base
- **OS :** Ubuntu 22.04 LTS Desktop (interface graphique)
- **RAM :** 4 Go (minimum pour la VM hôte)
- **CPU :** 2 cores
- **Disque :** 60 Go (dynamique)
- **Réseau :** NAT + Host-only adapter

### Logiciels préinstallés
- ✅ VirtualBox + Extension Pack
- ✅ Vagrant
- ✅ Docker
- ✅ kubectl
- ✅ Git
- ✅ VS Code
- ✅ Firefox
- ✅ Terminal (ZSH + Oh My Zsh optionnel)

### Projet GOTK8S
- ✅ Dossier `/home/faceless/GOTK8S` avec tout le code
- ✅ Images Docker déjà buildées
- ✅ Box Vagrant `ubuntu/jammy64` déjà téléchargée
- ✅ Documentation accessible
- ✅ Scripts prêts à l'emploi

## 🔨 Étapes de création

### Phase 1 : Créer la VM de base (30 min)

#### 1.1 Créer la VM dans VirtualBox

```bash
# Depuis VirtualBox Manager
New VM:
  Name: GOTK8S-Student-VM
  Type: Linux
  Version: Ubuntu (64-bit)
  RAM: 4096 MB
  Disk: 60 GB (dynamique)

Network:
  Adapter 1: NAT
  Adapter 2: Host-only Adapter (vboxnet0)
```

#### 1.2 Installer Ubuntu Desktop

1. Télécharger Ubuntu 22.04 LTS Desktop ISO
2. Monter l'ISO et démarrer l'installation
3. Configuration :
   - Nom d'utilisateur : `faceless`
   - Mot de passe : `faceless` (ou autre simple)
   - Hostname : `gotk8s-lab`
   - Installation minimale (pas de jeux, libreoffice, etc.)

#### 1.3 Configuration post-installation

```bash
# Dans la VM Ubuntu
sudo apt update && sudo apt upgrade -y

# Installer les Guest Additions
# Menu VM > Insert Guest Additions CD
sudo apt install -y build-essential dkms linux-headers-$(uname -r)
sudo /media/$USER/VBox*/VBoxLinuxAdditions.run

# Redémarrer
sudo reboot
```

### Phase 2 : Installer les logiciels (20 min)

#### 2.1 Installer VirtualBox (pour nested virtualization)

```bash
# Depuis la VM faceless
sudo apt install -y virtualbox virtualbox-ext-pack

# Activer nested virtualization
# (Depuis l'hôte, VM éteinte)
VBoxManage modifyvm "GOTK8S-Student-VM" --nested-hw-virt on
```

#### 2.2 Installer Vagrant

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vagrant
```

#### 2.3 Installer Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker faceless
```

#### 2.4 Installer kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

#### 2.5 Installer outils additionnels

```bash
# VS Code
sudo snap install code --classic

# Git (déjà installé normalement)
sudo apt install -y git

# Autres outils utiles
sudo apt install -y vim curl wget htop tree
```

### Phase 3 : Préparer GOTK8S (30 min)

#### 3.1 Cloner le projet

```bash
cd /home/faceless
git clone https://github.com/votre-repo/GOK8S.git
cd GOK8S

# Ou si pas encore sur GitHub, copier depuis votre machine
```

#### 3.2 Télécharger la box Vagrant

```bash
cd vagrant/k8s-cluster
vagrant box add ubuntu/jammy64
# Cela prend 5-10 min, mais les étudiants n'auront pas à le faire !
```

#### 3.3 Builder les images Docker

```bash
cd /home/faceless/GOK8S/kingdoms
./build-images.sh

# Sauvegarder les images
docker save gotk8s/the-north-api:1.0 -o the-north-api.tar
docker save gotk8s/the-north-frontend:1.0 -o the-north-frontend.tar
```

#### 3.4 Créer un script de démarrage rapide

```bash
cat > /home/faceless/Desktop/START-GOTK8S.sh << 'EOF'
#!/bin/bash

# Script de démarrage GOTK8S pour étudiants

echo "=========================================="
echo "  GOTK8S - Game Of Thrones Kubernetes"
echo "=========================================="
echo ""
echo "Bienvenue ! Ce script va démarrer le cluster K8s."
echo "Durée estimée : 15-20 minutes"
echo ""

cd /home/faceless/GOK8S/vagrant/k8s-cluster

echo "Démarrage du cluster Kubernetes..."
vagrant up

echo ""
echo "=========================================="
echo "  Cluster démarré avec succès !"
echo "=========================================="
echo ""
echo "Prochaines étapes :"
echo ""
echo "1. Configurer kubectl :"
echo "   export KUBECONFIG=~/.kube/gok8s-config"
echo "   vagrant ssh master -c 'cat /home/vagrant/.kube/config' > ~/.kube/gok8s-config"
echo "   sed -i 's/127.0.0.1/192.168.56.10/g' ~/.kube/gok8s-config"
echo ""
echo "2. Vérifier le cluster :"
echo "   kubectl get nodes"
echo ""
echo "3. Déployer The North :"
echo "   cd /home/faceless/GOK8S/kingdoms"
echo "   ./load-images-to-k8s.sh"
echo "   ./deploy-gotk8s.sh"
echo ""
echo "4. Accéder à l'application :"
echo "   Firefox : http://192.168.56.10:30100"
echo ""
echo "5. Suivre le guide étudiant :"
echo "   code /home/faceless/GOK8S/GUIDE_ETUDIANT.md"
echo ""
echo "Bon apprentissage ! 🐺"
EOF

chmod +x /home/faceless/Desktop/START-GOTK8S.sh
```

#### 3.5 Créer un fichier README sur le bureau

```bash
cat > /home/faceless/Desktop/README-GOTK8S.txt << 'EOF'
╔══════════════════════════════════════════════════════════╗
║          GOTK8S - Game Of Thrones Kubernetes            ║
║              Laboratoire d'apprentissage                ║
╚══════════════════════════════════════════════════════════╝

🎯 DÉMARRAGE RAPIDE
═══════════════════

1. Double-cliquer sur "START-GOTK8S.sh" sur le bureau
   → Cela va démarrer le cluster Kubernetes (15-20 min)

2. Suivre les instructions affichées à la fin du script

3. Ouvrir le guide étudiant :
   → /home/faceless/GOK8S/GUIDE_ETUDIANT.md

📚 DOCUMENTATION
════════════════

Tous les documents sont dans : /home/faceless/GOK8S/

- GUIDE_ETUDIANT.md         → Votre guide principal
- scenarios/01-winter-is-coming/  → Premier TP (1h30)
- GOTK8S_QUICKSTART.md      → Démarrage rapide
- GOTK8S_PROJECT.md         → Architecture complète

🎓 SCÉNARIO 1 : "WINTER IS COMING"
═══════════════════════════════════

Durée : 1h30
Niveau : Débutant

Vous allez déployer The North, un système de messagerie
utilisant des "Ravens" (corbeaux messagers).

Suivez : /home/faceless/GOK8S/scenarios/01-winter-is-coming/README.md

🔧 OUTILS INSTALLÉS
═══════════════════

✅ VirtualBox + Vagrant  → Virtualisation
✅ Docker                → Conteneurisation
✅ kubectl               → CLI Kubernetes
✅ VS Code               → Éditeur
✅ Firefox               → Navigateur

💡 AIDE
═══════

Si vous rencontrez un problème :
1. Consultez docs/troubleshooting.md
2. Demandez à votre formateur

Credentials :
  User: faceless
  Pass: faceless

═══════════════════════════════════════════════════════════

"Winter is Coming... êtes-vous prêt ?" 🐺❄️
EOF
```

### Phase 4 : Optimisations (10 min)

#### 4.1 Configurer le terminal

```bash
# Installer ZSH (optionnel mais sympa)
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ajouter des alias utiles
cat >> ~/.zshrc << 'EOF'

# GOTK8S Aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kga='kubectl get all'
alias kn='kubectl get nodes'
alias kw='kubectl get pods -w'

# Vagrant aliases
alias vup='vagrant up'
alias vhalt='vagrant halt'
alias vssh='vagrant ssh'
alias vstatus='vagrant status'

# Go to GOTK8S
alias gotk8s='cd /home/faceless/GOK8S'
alias kingdoms='cd /home/faceless/GOK8S/kingdoms'
EOF
```

#### 4.2 Configurer le bureau

```bash
# Fond d'écran Game of Thrones (optionnel)
# Créer des lanceurs sur le bureau :
# - Terminal
# - VS Code
# - Firefox
# - Dossier GOK8S
```

#### 4.3 Nettoyer

```bash
# Supprimer les fichiers temporaires
sudo apt clean
sudo apt autoremove -y

# Vider les caches
rm -rf ~/.cache/*

# Historique
history -c
```

### Phase 5 : Exporter l'OVA (10 min)

#### 5.1 Arrêter la VM proprement

```bash
# Dans la VM
sudo shutdown -h now
```

#### 5.2 Exporter depuis VirtualBox

```bash
# GUI VirtualBox :
# File > Export Appliance > Select "GOTK8S-Student-VM"
#
# Format: OVA 1.0
# File: GOTK8S-Student-v1.0.ova
#
# Options:
# - Write Manifest file: ✓
# - Include ISO images: ✗
#
# Export (prend 10-15 min)
```

#### 5.3 Créer le fichier de métadonnées

```bash
cat > GOTK8S-Student-v1.0-README.txt << 'EOF'
GOTK8S - Student VM v1.0
═══════════════════════════════════════

📦 CONTENU DE L'OVA
══════════════════

- Ubuntu 22.04 LTS Desktop
- VirtualBox + Vagrant préinstallés
- Docker + kubectl
- Projet GOK8S complet
- Images Docker pré-buildées
- Box Vagrant pré-téléchargée

💻 CONFIGURATION VM
══════════════════

RAM : 4 Go (ajustable)
CPU : 2 cores (ajustable)
Disque : 60 Go (dynamique)
Réseau : NAT + Host-only

👤 CREDENTIALS
═════════════

Username: faceless
Password: faceless

🚀 DÉMARRAGE RAPIDE
══════════════════

1. Importer l'OVA dans VirtualBox
2. Démarrer la VM
3. Login avec faceless/faceless
4. Double-cliquer "START-GOTK8S.sh" sur le bureau
5. Attendre 15-20 min
6. Commencer le TP !

📚 DOCUMENTATION
═══════════════

Tous les guides sont dans /home/faceless/GOK8S/
Commencez par GUIDE_ETUDIANT.md

⚙️ CONFIGURATION RECOMMANDÉE
═══════════════════════════

Pour de meilleures performances :
- RAM VM : 6-8 Go (au lieu de 4)
- CPU : 4 cores (au lieu de 2)

📏 TAILLE FICHIER
════════════════

OVA : ~8-10 Go (compressé)
Après import : ~15-20 Go

🔗 SUPPORT
═════════

GitHub : https://github.com/votre-repo/GOK8S
Issues : https://github.com/votre-repo/GOK8S/issues

══════════════════════════════════════════

Créé pour l'apprentissage de Kubernetes
Version 1.0 - Novembre 2025
EOF
```

## 📋 Checklist finale avant export

```bash
✅ Ubuntu 22.04 installé et à jour
✅ Guest Additions installées
✅ VirtualBox + Vagrant installés
✅ Docker installé et fonctionnel
✅ kubectl installé
✅ Projet GOK8S cloné dans /home/faceless/
✅ Box vagrant ubuntu/jammy64 téléchargée
✅ Images Docker buildées et sauvegardées
✅ Script START-GOTK8S.sh sur le bureau
✅ README sur le bureau
✅ Aliases configurés
✅ VS Code installé
✅ VM nettoyée
✅ Mot de passe simple configuré
✅ Nested virtualization activée
✅ Réseau configuré (NAT + Host-only)
```

## 🎓 Guide étudiant pour l'OVA

Créez un document séparé pour les étudiants :

### GOTK8S-Student-Import-Guide.md

```markdown
# Guide d'importation GOTK8S

## Prérequis

- VirtualBox 6.1+ installé sur VOTRE machine
- 8 Go RAM disponible
- 30 Go disque libre
- Fichier GOTK8S-Student-v1.0.ova téléchargé

## Installation (5 min)

### 1. Importer l'OVA

1. Ouvrir VirtualBox
2. Fichier > Importer un appareil virtuel
3. Sélectionner `GOTK8S-Student-v1.0.ova`
4. Ajuster si nécessaire :
   - RAM : 6-8 Go (recommandé)
   - CPU : 4 cores (recommandé)
5. Importer (prend 5-10 min)

### 2. Démarrer la VM

1. Sélectionner "GOTK8S-Student-VM"
2. Cliquer "Démarrer"
3. Login : `faceless` / `faceless`

### 3. Lancer le cluster K8s

Double-cliquer sur `START-GOTK8S.sh` sur le bureau
→ Attendre 15-20 minutes ☕

### 4. Commencer le TP

Ouvrir `/home/faceless/GOK8S/GUIDE_ETUDIANT.md`

## C'est parti ! 🚀
```

## 🌐 Distribution de l'OVA

### Option 1 : USB/Disque local
- Copier l'OVA sur clés USB
- Distribuer aux étudiants

### Option 2 : Serveur local
- Héberger sur serveur de l'école
- URL interne : http://serveur.école.fr/gotk8s/GOTK8S-v1.0.ova

### Option 3 : Cloud
- Google Drive / Dropbox
- Nextcloud / OwnCloud
- Partage temporaire

### Option 4 : Torrent (si grosse classe)
- Créer un torrent
- Seeder depuis plusieurs machines

## 💡 Améliorations possibles

### Version 1.1 (futures)
- [ ] Cluster déjà démarré (snapshot)
- [ ] Images Docker déjà chargées dans les nœuds
- [ ] The North déjà déployé
- [ ] Fond d'écran Game of Thrones
- [ ] Tutoriel vidéo intégré
- [ ] Quiz interactif
- [ ] Monitoring pré-configuré

### Version Pro
- [ ] Plusieurs snapshots (checkpoints)
- [ ] Tous les royaumes disponibles
- [ ] IDE web (Theia/code-server)
- [ ] Dashboard préinstallé

## 📊 Avantages de l'OVA

| Aspect | Sans OVA | Avec OVA |
|--------|----------|----------|
| **Temps setup** | 30-40 min | 2-3 min |
| **Téléchargements** | ~2 Go | 0 (déjà dans OVA) |
| **Problèmes install** | Fréquents | Rares |
| **Support formateur** | Élevé | Minimal |
| **Homogénéité** | Variable | Identique |
| **Démarrage TP** | Après 40 min | Après 3 min |

## 🎯 Résultat

**Les étudiants peuvent commencer à apprendre Kubernetes en 3 minutes au lieu de 40 !**

Le formateur passe moins de temps sur l'installation, plus sur la pédagogie. ✅

---

*Ce guide vous permet de créer une OVA "clé en main" pour vos TPs Kubernetes.*
