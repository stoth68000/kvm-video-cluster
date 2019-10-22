#!/bin/bash

. ./$1
NEW_NAME=$NEW_HOSTNAME

echo "Creating $NEW_HOSTNAME as $NEW_IPADDR"

sudo virsh shutdown $NEW_NAME
sudo virsh destroy $NEW_NAME
sudo virsh undefine $NEW_NAME

sudo virt-clone --original centos7-1810-minimal-base --name $NEW_NAME --auto-clone

perl -spi -e "s!IPADDR=.*\$!IPADDR=$NEW_IPADDR!g" ifcfg-eth0
sudo chown stoth:stoth hostname
echo $NEW_HOSTNAME >hostname
sudo chown root:root hostname
sudo chown root:root ifcfg-eth0
sudo virt-copy-in -d $NEW_NAME ifcfg-eth0 /etc/sysconfig/network-scripts
sudo virt-copy-in -d $NEW_NAME vm-install.sh /root
sudo virt-copy-in -d $NEW_NAME resolv.conf /etc
sudo virt-copy-in -d $NEW_NAME hostname /etc
