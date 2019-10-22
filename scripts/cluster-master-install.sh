#!/bin/bash
# Install any deps and reconfigure the system
# to support Kubernetes and Docker.

# References:
#  https://www.linuxtechi.com/install-kubernetes-1-7-centos7-rhel7/

# We need all of the kubernetes machines availabe via hostname.
# Install a new hosts file, with all the master and worker
# nodes listed (or use DNS later).
cp hosts /etc

# Disable selinux now, and after reboots.
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Disable SWAP, Kubernetes doen't want swap on the master else the installation
# pre-flight checks will fail.
swapoff -a
sed -i --follow-symlinks 's!/dev/mapper/centos-swap!#/dev/mapper/centos-swap!g' /etc/fstab

# Generate a master node ssh key pair
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    yes y | ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

# Update firewall rules
if [[ `firewall-cmd --state` = running ]]
then
    echo "Adjusting firewall rules"
    firewall-cmd --permanent --add-port=6443/tcp
    firewall-cmd --permanent --add-port=2379-2380/tcp
    firewall-cmd --permanent --add-port=10250/tcp
    firewall-cmd --permanent --add-port=10251/tcp
    firewall-cmd --permanent --add-port=10252/tcp
    firewall-cmd --permanent --add-port=10255/tcp
    firewall-cmd --reload
fi

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Install Kubernetes and Docker
if [ ! -f /etc/yum.repos.d/kubernetes.repo ]; then
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
fi

yum -y install kubeadm docker

systemctl restart docker && systemctl enable docker
systemctl restart kubelet && systemctl enable kubelet

# Initialize kubernetes stack
kubeadm init

# Configure root to be able to use kubernetes
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# To make the cluster status ready and kube-dns status running,
# deploy the pod network so that containers of different host
# communicated each other.  POD network is the overlay
# network between the worker nodes.
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

echo
echo "Installation complete on kubernetes master"
exit 0

# Build a public key on each worker and deploy MASTER key also
#for WORKER in $CLUSTER_WORKERS
#do
#	echo $WORKER
#	ssh root@$WORKER "yes y | ssh-keygen -t rsa -N \"\" -f ~/.ssh/id_rsa"
#	scp ~/.ssh/id_rsa.pub root@$WORKER:~/.ssh/authorized_keys
#done

