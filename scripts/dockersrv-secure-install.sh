#!/bin/bash -x

# References:
#  https://www.linuxtechi.com/setup-docker-private-registry-centos-7-rhel-7/
#  https://ahmermansoor.blogspot.com/2019/03/configure-private-docker-registry-centos-7.html
#  https://ahmermansoor.blogspot.com/2019/04/configure-secure-registry-docker-distribution-centos-7.html

yum -y install docker docker-distribution httpd-tools

if [ ! -f /etc/pki/tls/private/registry.key ]; then
  openssl req -newkey rsa:2048 -nodes -sha256 -x509 -days 365 -keyout /etc/pki/tls/private/registry.key -out /etc/pki/tls/registry.crt
fi

if [ ! -f /etc/docker-distribution/dockerpasswd ]; then
  htpasswd -c -B /etc/docker-distribution/dockerpasswd stoth
fi

cat <<EOF >/etc/docker-distribution/registry/config.yml
version: 0.1
log:
  fields:
    service: registry
storage:
    cache:
        layerinfo: inmemory
    filesystem:
        rootdirectory: /var/lib/registry
http:
    addr: `hostname`:5000
    tls:
        certificate: /etc/pki/tls/registry.crt
        key: /etc/pki/tls/private/registry.key
auth:
    htpasswd:
        realm: example.com
        path: /etc/docker-distribution/dockerpasswd
EOF

systemctl start docker-distribution
systemctl enable docker-distribution

firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload

echo
echo "private secure dockery registry installation complete"
