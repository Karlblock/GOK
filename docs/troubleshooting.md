# Guide de dépannage GOK8S

Ce guide couvre les problèmes courants et leurs solutions.

## Table des matières

1. [Problèmes de démarrage Vagrant](#problèmes-de-démarrage-vagrant)
2. [Problèmes Kubernetes](#problèmes-kubernetes)
3. [Problèmes Docker Swarm](#problèmes-docker-swarm)
4. [Problèmes réseau](#problèmes-réseau)
5. [Problèmes de performances](#problèmes-de-performances)

## Problèmes de démarrage Vagrant

### Erreur: "VBoxManage: error: Could not find a controller"

**Symptôme:** Échec du démarrage avec erreur de contrôleur VirtualBox

**Solution:**
```bash
# Réinitialiser la VM
vagrant destroy -f
vagrant up
```

### Erreur: "The guest machine entered an invalid state"

**Symptôme:** La VM ne démarre pas ou reste bloquée

**Solution:**
```bash
# Vérifier les logs VirtualBox
VBoxManage showvminfo nom_de_la_vm

# Vérifier que la virtualisation est activée dans le BIOS
egrep -c '(vmx|svm)' /proc/cpuinfo
# Devrait retourner > 0

# Réinstaller les additions invité
vagrant plugin install vagrant-vbguest
vagrant vbguest --do install
```

### Erreur: "Timed out while waiting for the machine to boot"

**Symptôme:** Timeout lors du démarrage de la VM

**Solution:**
```bash
# Augmenter le timeout dans le Vagrantfile
config.vm.boot_timeout = 600

# Ou désactiver temporairement le pare-feu
sudo systemctl stop firewalld  # Fedora/RHEL
sudo ufw disable              # Ubuntu/Debian
```

## Problèmes Kubernetes

### Les nœuds sont en état "NotReady"

**Symptôme:** `kubectl get nodes` affiche NotReady

**Diagnostic:**
```bash
vagrant ssh master
kubectl describe node nom_du_noeud
kubectl get pods -n kube-system
```

**Solutions:**

1. **Problème CNI:**
```bash
# Réappliquer le CNI
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml

# Vérifier les pods calico
kubectl get pods -n kube-system | grep calico
```

2. **Problème containerd:**
```bash
vagrant ssh nom_du_noeud
sudo systemctl status containerd
sudo systemctl restart containerd
```

3. **Problème de certificats:**
```bash
# Sur le master
sudo kubeadm token create --print-join-command

# Sur le worker, rejoindre à nouveau
sudo kubeadm reset
# Puis exécuter la nouvelle commande de join
```

### Pods en état "Pending"

**Symptôme:** Les pods ne démarrent pas

**Diagnostic:**
```bash
kubectl describe pod nom_du_pod
kubectl get events --sort-by='.lastTimestamp'
```

**Solutions:**

1. **Ressources insuffisantes:**
```bash
# Vérifier les ressources
kubectl describe nodes
kubectl top nodes

# Modifier config.yaml pour augmenter RAM/CPU
# Puis:
vagrant reload
```

2. **Problème de volumes:**
```bash
# Vérifier les PV/PVC
kubectl get pv,pvc
kubectl describe pvc nom_du_pvc
```

### Dashboard inaccessible

**Symptôme:** Impossible d'accéder au dashboard Kubernetes

**Solution:**
```bash
# Vérifier que le dashboard est déployé
kubectl get pods -n kubernetes-dashboard

# Recréer le token
kubectl -n kubernetes-dashboard create token admin-user

# Créer un proxy
kubectl proxy --address='0.0.0.0' --accept-hosts='.*'
```

### Erreur: "Unable to connect to the server"

**Symptôme:** kubectl ne peut pas se connecter au cluster

**Solution:**
```bash
# Vérifier que le master est accessible
ping 192.168.56.10

# Copier à nouveau le kubeconfig
vagrant ssh master -c 'cat /home/vagrant/.kube/config' > ~/.kube/gok8s-config

# Vérifier la connectivité API
curl -k https://192.168.56.10:6443
```

## Problèmes Docker Swarm

### Nœuds en état "Down"

**Symptôme:** `docker node ls` affiche des nœuds Down

**Solution:**
```bash
# Sur le nœud concerné
vagrant ssh worker1
sudo systemctl status docker
sudo systemctl restart docker

# Si ça ne fonctionne pas, rejoindre à nouveau
docker swarm leave
# Sur le manager, obtenir le token
docker swarm join-token worker
# Puis exécuter la commande sur le worker
```

### Services ne démarrent pas

**Symptôme:** `docker service ps nom_service` montre des échecs

**Diagnostic:**
```bash
docker service ps nom_service --no-trunc
docker service logs nom_service
```

**Solutions:**

1. **Problème d'image:**
```bash
# Vérifier que l'image existe
docker pull nom_image

# Sur tous les nœuds
docker image ls
```

2. **Problème de réseau:**
```bash
# Recréer le réseau overlay
docker network rm nom_reseau
docker network create --driver overlay nom_reseau
```

### Portainer inaccessible

**Solution:**
```bash
# Vérifier le service
docker service ls | grep portainer
docker service logs portainer

# Recréer le service
docker service rm portainer
# Puis re-déployer depuis le script
```

## Problèmes réseau

### Impossible d'accéder aux services via IP

**Symptôme:** Pas de connexion à 192.168.56.x

**Solution:**
```bash
# Vérifier l'interface réseau
vagrant ssh master
ip addr show

# Sur l'hôte, vérifier les interfaces VirtualBox
VBoxManage list hostonlyifs

# Recréer l'interface si nécessaire
VBoxManage hostonlyif remove vboxnet0
vagrant reload
```

### DNS ne fonctionne pas dans les pods

**Solution:**
```bash
# Vérifier CoreDNS
kubectl get pods -n kube-system | grep coredns
kubectl logs -n kube-system coredns-xxxx

# Redémarrer CoreDNS
kubectl rollout restart deployment/coredns -n kube-system
```

### Problèmes de connectivité entre pods

**Solution:**
```bash
# Tester la connectivité
kubectl run test --image=busybox -it --rm -- sh
# Dans le pod:
nslookup kubernetes.default
ping autre-service

# Vérifier les NetworkPolicies
kubectl get networkpolicies
kubectl describe networkpolicy nom_policy
```

## Problèmes de performances

### VMs très lentes

**Solutions:**

1. **Augmenter les ressources:**
```yaml
# Modifier config.yaml
master:
  memory: 4096  # au lieu de 2048
  cpus: 4       # au lieu de 2
```

2. **Activer le mode paravirtualisation:**
```ruby
# Dans le Vagrantfile
vb.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
```

3. **Désactiver les features inutiles:**
```ruby
vb.customize ["modifyvm", :id, "--audio", "none"]
vb.customize ["modifyvm", :id, "--usb", "off"]
```

### Lenteur du réseau

**Solution:**
```ruby
# Dans le Vagrantfile, utiliser virtio
config.vm.provider "virtualbox" do |vb|
  vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
  vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
end
```

## Nettoyage complet

Si tout le reste échoue, nettoyage complet :

```bash
# Détruire toutes les VMs
cd GOK8S
./scripts/cleanup.sh

# Nettoyer Vagrant
vagrant global-status --prune
rm -rf ~/.vagrant.d/tmp/*

# Nettoyer VirtualBox
VBoxManage list vms
VBoxManage list hostonlyifs

# Redémarrer à zéro
./scripts/install.sh
```

## Logs utiles

### Vagrant
```bash
# Logs détaillés
VAGRANT_LOG=info vagrant up
```

### Kubernetes
```bash
# Logs kubelet
vagrant ssh master
sudo journalctl -u kubelet -f

# Logs API server
kubectl logs -n kube-system kube-apiserver-master
```

### Docker
```bash
# Logs Docker daemon
vagrant ssh manager
sudo journalctl -u docker -f
```

## Obtenir de l'aide

Si vous rencontrez un problème non documenté ici :

1. Consultez les issues GitHub du projet
2. Vérifiez les logs détaillés
3. Créez une issue avec :
   - Description du problème
   - Logs complets
   - Sortie de `vagrant --version`, `vboxmanage --version`
   - Votre système d'exploitation
