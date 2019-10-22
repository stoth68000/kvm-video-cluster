#!/bin/bash

# References:
#    https://www.howtoforge.com/nfs-server-and-client-on-centos-7

yum -y install nfs-utils

STORAGE=/clusterfs

if [ ! -d $STORAGE ]; then
    mkdir -p $STORAGE
    echo "192.168.2.167:$STORAGE $STORAGE nfs defaults 0 0" >>/etc/fstab
fi

mount -t nfs 192.168.2.167:/clusterfs /clusterfs

echo
echo "storage mount installation complete"

