#!/bin/bash

# References:
#    https://www.howtoforge.com/nfs-server-and-client-on-centos-7

yum -y install nfs-utils

STORAGE=/clusterfs

if [ ! -d $STORAGE ]; then
    mkdir -p $STORAGE
    chmod -R 755 $STORAGE
    chown nfsnobody:nfsnobody $STORAGE
    systemctl enable rpcbind
    systemctl enable nfs-server
    systemctl enable nfs-lock
    systemctl enable nfs-idmap
    systemctl start rpcbind
    systemctl start nfs-server
    systemctl start nfs-lock
    systemctl start nfs-idmap
fi

echo "$STORAGE 192.168.2.0/255.255.255.0(rw,sync,no_root_squash,no_all_squash)" >>/etc/exports

systemctl restart nfs-server

firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload

echo
echo "storage server installation complete"

