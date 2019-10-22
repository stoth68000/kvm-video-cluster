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
    firewall-cmd --permanent --add-port=10250/tcp
    firewall-cmd --permanent --add-port=10255/tcp
    firewall-cmd --permanent --add-port=30000-32767/tcp
    firewall-cmd --permanent --add-port=6783/tcp
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

# Initialize kubernetes stack, join this VM to the cluster
kubeadm join --token annsfc.ymnjwsbc1le3ccsl --discovery-token-unsafe-skip-ca-verification k0:6443

echo
echo "Installation complete on kubernetes worker"
exit 0

