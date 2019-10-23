#!/bin/bash

yum -y install docker
sed -i --follow-symlinks 's/-driver overlay2/-driver devicemapper/g' /etc/sysconfig/docker-storage

