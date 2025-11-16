# Problèmes rencontrés lors de la création de l'OVA GOTK8S

## Problème : Dépendances de packages cassées

### Symptômes
- VM importée ne démarre pas correctement (GUI KO)
- `dpkg --configure -a` montre "too many errors"
- Paquets manquants : libcurl3t64-gnutls, libldap2
- DNS ne fonctionne pas (NetworkManager cassé)

### Cause racine
**Mélange de versions Ubuntu**

La VM a été créée avec Ubuntu 22.04 LTS (Jammy) mais certains logiciels ont ajouté des dépôts Ubuntu 24.04 LTS (Noble):

1. Installation initiale: Ubuntu 22.04 (Jammy)
2. Installation de VS Code: Ajoute des repos Ubuntu 24.04 (Noble)
3. `apt update` : Le système voit les nouveaux paquets Noble
4. `apt install` : Installe un mélange de paquets Jammy + Noble
5. Résultat: Dépendances incompatibles

### Preuve
```bash
# La VM montre Jammy
$ cat /etc/os-release
VERSION="22.04.5 LTS (Jammy Jellyfish)"

# Mais apt cherche sur Noble
$ sudo apt update
Ign:1 http://fr.archive.ubuntu.com/ubuntu noble InRelease
```

### Solution : Utiliser Ubuntu 24.04 LTS dès le départ

Au lieu de mélanger 22.04 + 24.04, installer directement **Ubuntu 24.04 LTS Noble**.

#### Avantages
- ✅ Cohérence des paquets (tout en Noble)
- ✅ Pas de conflits de dépendances
- ✅ Plus récent (meilleur support des logiciels)
- ✅ Kubernetes 1.28 compatible
- ✅ VirtualBox 7.x compatible

#### Inconvénients
- ❌ ISO plus récente (~6 GB à télécharger)
- ❌ Possible incompatibilité avec vieux matériel (mais rare)

## Actions correctives

### 1. Télécharger Ubuntu 24.04 LTS
```bash
cd /home/kless/IUT/r509/GOK8S/ova
wget -O ubuntu-24.04-desktop-amd64.iso https://releases.ubuntu.com/noble/ubuntu-24.04.1-desktop-amd64.iso
```

### 2. Mettre à jour create-vm.sh
```bash
# Avant
ISO_PATH="ubuntu-22.04.5-desktop-amd64.iso"

# Après
ISO_PATH="ubuntu-24.04-desktop-amd64.iso"
```

### 3. Recréer la VM proprement
```bash
cd /home/kless/IUT/r509/GOK8S/ova
./create-vm.sh
```

Puis installer Ubuntu 24.04 manuellement avec:
- Utilisateur: faceless
- Mot de passe: faceless
- Hostname: gotk8s-lab

### 4. Automatiser l'installation des logiciels
Le script `setup-gotk8s-vm.sh` fonctionne déjà bien - il va installer:
- Docker 28.x
- Vagrant 2.4.x
- kubectl 1.28.x
- VirtualBox 7.x
- VS Code (qui cette fois sera cohérent avec Noble)

### 5. Exporter l'OVA propre
```bash
cd /home/kless/IUT/r509/GOK8S/ova
./export-ova.sh
```

## Prévention future

### Checklist avant export OVA
- [ ] Vérifier `/etc/os-release` montre la bonne version
- [ ] Vérifier `cat /etc/apt/sources.list` n'a qu'une seule version Ubuntu
- [ ] Tester `sudo apt update` sans erreurs
- [ ] Tester `sudo dpkg --configure -a` sans erreurs
- [ ] Vérifier DNS fonctionne: `ping google.com`
- [ ] Vérifier NetworkManager: `systemctl status NetworkManager`
- [ ] Installer Guest Additions: `/media/*/VBox*/VBoxLinuxAdditions.run`
- [ ] Tester le GUI fonctionne correctement

### Script de vérification
```bash
#!/bin/bash
# verify-vm-health.sh

echo "=== Vérification de la santé de la VM ==="
echo ""

echo "1. Version Ubuntu:"
grep PRETTY_NAME /etc/os-release

echo ""
echo "2. Sources APT:"
grep -h "^deb " /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null | grep -v "#" | awk '{print $3}' | sort -u

echo ""
echo "3. Test DNS:"
ping -c 1 google.com > /dev/null && echo "✅ DNS OK" || echo "❌ DNS KO"

echo ""
echo "4. Paquets cassés:"
sudo dpkg --configure -a && echo "✅ Pas de problèmes dpkg" || echo "❌ Problèmes dpkg détectés"

echo ""
echo "5. NetworkManager:"
systemctl is-active NetworkManager && echo "✅ NetworkManager actif" || echo "❌ NetworkManager inactif"

echo ""
echo "6. Guest Additions:"
lsmod | grep -q vboxguest && echo "✅ Guest Additions chargées" || echo "❌ Guest Additions manquantes"
```

## Temps estimés

| Étape | Durée |
|-------|-------|
| Télécharger ISO Ubuntu 24.04 | 10-30 min (selon connexion) |
| Créer VM avec create-vm.sh | 1 min |
| Installer Ubuntu 24.04 manuellement | 15 min |
| Exécuter setup-gotk8s-vm.sh | 30-40 min |
| Personnaliser (GoT theme) | 2 min |
| Vérifier santé VM | 5 min |
| Exporter OVA | 10-15 min |
| **TOTAL** | **~1h30-2h** |

## Résultat attendu

✅ OVA fonctionnelle de ~12-15 GB avec:
- Ubuntu 24.04 LTS Noble
- Docker, Vagrant, kubectl, VirtualBox
- Projet GOTK8S complet
- GUI fonctionnelle
- Réseau fonctionnel
- Pas d'erreurs de packages

✅ Setup étudiant: 3-5 minutes (vs 90 minutes sans OVA)
