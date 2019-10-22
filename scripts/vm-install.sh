#!/bin/bash

sudo yum -y update
sudo yum -y groupinstall "Development Tools"
sudo yum -y install mesa-libGL-17.2.3-8.20171019.el7
sudo yum -y install epel-release
sudo yum repolist
sudo yum -y install dkms
sudo yum -y install kernel-devel
sudo yum -y install mlocate
sudo yum -y install screen
sudo yum -y install net-tools
sudo yum -y install valgrind
sudo yum -y install mediainfo
sudo yum -y install sysstat
sudo yum -y install tcpdump
sudo yum -y install json-c
sudo yum -y install wget
sudo yum -y install nfs-utils parallel
sudo updatedb

sudo systemctl enable sysstat
sudo systemctl start sysstat
sudo systemctl disable firewalld
sudo systemctl stop firewalld

