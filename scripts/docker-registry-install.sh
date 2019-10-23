#!/bin/bash -x

# References:
#  https://ahmermansoor.blogspot.com/2019/04/configure-secure-registry-docker-distribution-centos-7.html
#  https://www.linuxtechi.com/setup-docker-private-registry-centos-7-rhel-7/
#  https://ahmermansoor.blogspot.com/2019/03/configure-private-docker-registry-centos-7.html

yum -y install docker

if [ ! -d /etc/docker/certs.d/docker-distribution-01.example.com:5000 ]; then
  mkdir -p /etc/docker/certs.d/docker-registry.example.com:5000
  echo "We need the private key from our docker server, enter the root password and we'll SCP it"
  scp root@docker-registry:/etc/pki/tls/registry.crt /etc/docker/certs.d/docker-registry.example.com\:5000/
fi

docker pull alpine
docker tag alpine docker-registry.example.com:5000/alpine

# You can test a push of the newly tagged alpine to our private repro with:
#docker login  docker-registry.example.com:5000
#docker push   docker-registry.example.com:5000/alpine
#docker logout docker-registry.example.com:5000

echo
echo "private SECURE dockery registry references installed"
