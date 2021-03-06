#!/bin/bash 

. ./env

########## Install docker
apt-get update
apt-get install -y aptitude

aptitude -y update 
aptitude -y upgrade
aptitude -y install apt-transport-https ca-certificates bridge-utils sudo 
#aptitude -y install apt-transport-https ca-certificates make bridge-utils sudo gcc git curl

echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
aptitude -y update 
aptitude -y upgrade
#apt-get purge lxc-docker* docker.io*
aptitude -y install docker-engine

service docker status
docker run hello-world

service docker stop

###########
rsync -av ./rootfs_common/ /
rsync -av ./rootfs_node/ /
gunzip -f /usr/local/bin/hyperkube.gz
gunzip -f /usr/local/bin/etcd.gz
gunzip -f /usr/local/bin/etcdctl.gz
gunzip -f /usr/local/bin/flanneld.gz


cat<<EOF>/etc/systemd/system/multi-user.target.wants/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
EnvironmentFile=-/run/flannel/subnet.env
Type=notify
#ExecStart=/usr/bin/docker daemon -H fd:// --bridge=cbr0 --iptables=false --ip-masq=false
ExecStart=/usr/bin/docker daemon -H fd:// --bip=\${FLANNEL_SUBNET} --mtu=\${FLANNEL_MTU} --ip-masq=\${FLANNEL_IPMASQ} --insecure-registry ${MASTER_IP}:5000 
MountFlags=slave
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
service docker start

#iptables -F  -t nat
#ip link set docker0 down 
#ip link delete docker0

ssh-keyscan ${MASTER_IP} >> ~/.ssh/known_hosts
CERT_DIR=/var/lib/kubelet/tls
mkdir -p ${CERT_DIR}
scp ${MASTER_IP}:/srv/pki/${MY_IP}.crt ${CERT_DIR}/kubelet.crt 
scp ${MASTER_IP}:/srv/pki/${MY_IP}.key ${CERT_DIR}/kubelet.key 
scp ${MASTER_IP}:/srv/pki/ca.crt ${CERT_DIR}/

for dir in /usr/service/*/env ; do echo ${MASTER_IP} > ${dir}/MASTER_IP ; done

aptitude install -y daemontools-run 
svc -t /etc/service/*

#iptables -t nat -D POSTROUTING ! -d  10.0.0.0/8 -j MASQUERADE -m addrtype ! --dst-type LOCAL
#iptables -t nat -A POSTROUTING ! -d  10.0.0.0/8 -j MASQUERADE -m addrtype ! --dst-type LOCAL


