# Configuration Ansible (optionnel)

## Par défaut : Scripts Shell uniquement

Par défaut, le projet utilise uniquement les scripts shell pour le provisioning. **Ansible n'est pas requis** pour utiliser GOK8S.

Les scripts shell font tout le travail nécessaire :
- ✅ Installation des dépendances
- ✅ Configuration du système
- ✅ Déploiement de Kubernetes ou Docker Swarm
- ✅ Installation des outils (Dashboard, Portainer, etc.)

## Option : Activer le provisioning Ansible

Si vous préférez utiliser Ansible pour le provisioning, suivez ces étapes :

### 1. Installer Ansible sur votre machine hôte

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y ansible
```

#### Fedora
```bash
sudo dnf install -y ansible
```

#### macOS
```bash
brew install ansible
```

### 2. Activer le provisioning Ansible

Décommentez les sections Ansible dans les Vagrantfile :

**Pour K8s Cluster** : Éditez `vagrant/k8s-cluster/Vagrantfile`

Remplacez :
```ruby
    # Provisioning Ansible (optionnel - décommenter si Ansible est installé)
    # if File.exist?("../../ansible/playbooks/k8s-setup.yml")
    #   master.vm.provision "ansible" do |ansible|
    #     ...
    #   end
    # end
```

Par :
```ruby
    # Provisioning Ansible
    if File.exist?("../../ansible/playbooks/k8s-setup.yml")
      master.vm.provision "ansible" do |ansible|
        ansible.playbook = "../../ansible/playbooks/k8s-setup.yml"
        ansible.extra_vars = {
          node_type: "master",
          master_ip: MASTER_IP
        }
      end
    end
```

### 3. Vérifier l'installation

```bash
ansible --version
```

Devrait afficher la version d'Ansible installée.

### 4. Relancer le provisioning

```bash
cd vagrant/k8s-cluster
vagrant up --provision
```

## Avantages de chaque approche

### Scripts Shell (par défaut)
- ✅ Pas de dépendance externe
- ✅ Plus simple pour débuter
- ✅ Fonctionne partout
- ✅ Plus rapide pour des petits labs

### Ansible
- ✅ Plus modulaire et réutilisable
- ✅ Idempotent (peut être rejoué sans problème)
- ✅ Meilleure gestion des erreurs
- ✅ Plus adapté pour des déploiements complexes
- ✅ Utile pour apprendre Ansible

## Recommandation

Pour un usage d'apprentissage de Kubernetes/Docker : **utilisez les scripts shell** (configuration par défaut).

Pour apprendre Ansible en plus de K8s/Docker : **activez le provisioning Ansible**.

## Dépannage

### Erreur : "The Ansible software could not be found"

Solution : Le provisioning Ansible est activé mais Ansible n'est pas installé.

Options :
1. **Installer Ansible** (voir ci-dessus)
2. **Désactiver Ansible** : Les sections sont déjà commentées par défaut dans les Vagrantfile

### Conflit entre Shell et Ansible

Si les deux sont activés, ils feront le même travail deux fois. Choisissez l'un ou l'autre :
- Shell : Commentez les sections Ansible
- Ansible : Commentez les provisions shell dans le Vagrantfile

## Utiliser Ansible manuellement

Vous pouvez aussi utiliser Ansible après le déploiement :

```bash
# Après vagrant up
cd ansible
ansible-playbook -i inventory.ini playbooks/k8s-setup.yml

# Ou pour Docker Swarm
ansible-playbook -i inventory.ini playbooks/docker-swarm-setup.yml
```

Assurez-vous que les VMs sont démarrées et que les IPs correspondent à l'inventaire.
