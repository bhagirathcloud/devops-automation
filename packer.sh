# Package script to install jenkins, git, docker, helm, terraform

sudo apt-get update -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y && sudo apt-get install packer -y
sudo apt-add-repository ppa:ansible/ansible -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt-get update -y

sudo apt-get install zip unzip git -y 


sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

# Terraform installation
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update -y && sudo apt-get install terraform -y
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

sudo useradd -m -s /bin/bash -p $(perl -e 'print crypt($ARGV[0], "password")' devops) devops
sudo echo 'summit  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#   PasswordAuthentication yes/   PasswordAuthentication yes/g' /etc/ssh/ssh_config
sudo echo 'summit  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sudo service ssh reload

# Helm Installation
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y
sudo apt-get install build-essential make -y

# Jenkins Installation
sudo apt-get install docker.io -y
sudo usermod -aG docker ${USER}
sudo mkdir -p /var/jenkins_home

sudo chmod 777 /var/jenkins_home
cp -r jenkins-in-docker-with-k8s-terraform/jobs /var/jenkins_home/
cp -r jenkins-in-docker-with-k8s-terraform/hudson.tasks.Shell.xml /var/jenkins_home/
cp -r jenkins-in-docker-with-k8s-terraform/* .
sudo docker build -t jenkins-lts .
sudo docker run -d --name=jenkins-master --restart=always -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home jenkins-lts:latest

# Kubectl and EKSCTL setup
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
sudo mv kubectl /usr/local/bin; chmod ugo+x /usr/local/bin/kubectl

