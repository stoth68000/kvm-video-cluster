#!/bin/bash -x

# References:
#  https://www.linuxtechi.com/setup-docker-private-registry-centos-7-rhel-7/
#  https://ahmermansoor.blogspot.com/2019/03/configure-private-docker-registry-centos-7.html

sudo yum -y install docker

sed -i --follow-symlinks 's!seccomp.json \\!seccomp.json --insecure-registry docker-registry.example.com:5000 \\!g' /usr/lib/systemd/system/docker.service

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

docker pull registry

docker stop docker-registry
docker rm docker-registry

docker run -dit -p 5000:5000 --name registry registry

docker pull busybox

docker tag busybox:latest docker-registry.example.com:5000/busybox
docker push docker-registry.example.com:5000/busybox

echo
echo "private INSECURE dockery registry installation complete"
