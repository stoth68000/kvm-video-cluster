#!/bin/bash

virt-install \
--virt-type=kvm \
--name centos7-1810-minimal-base \
--ram 2048 \
--vcpus=2 \
--os-variant=centos7.0 \
--cdrom=/var/lib/libvirt/boot/CentOS-7-x86_64-Minimal-1810.iso \
--network=bridge=br0,model=virtio \
--graphics vnc,listen=0.0.0.0,port=5900 \
--disk path=/var/lib/libvirt/images/centos7-vm0.qcow2,size=20,bus=virtio,format=qcow2

