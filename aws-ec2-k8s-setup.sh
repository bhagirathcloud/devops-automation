#This script will deploy k8s on AWS instance

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo apt-get update
sudo apt-get install docker.io -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo hostnamectl set-hostname "master"
sudo apt-get install -y kubelet=1.20.5-00 kubeadm=1.20.5-00 kubectl=1.20.5-00
sudo apt-mark hold kubelet kubeadm kubectl
sudo echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo kubeadm init --node-name master --pod-network-cidr=10.0.1.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo curl https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O
kubectl apply -f kube-flannel.yml
kubectl taint nodes master node-role.kubernetes.io/master-
