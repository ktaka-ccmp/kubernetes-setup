#!/bin/bash 

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

###########
rsync -av ./rootfs_common/ /
rsync -av ./rootfs_minion/ /
gunzip -f /usr/local/bin/hyperkube.gz
gunzip -f /usr/local/bin/etcd.gz
gunzip -f /usr/local/bin/etcdctl.gz

iptables -F  -t nat
ip link set docker0 down 
ip link delete docker0

#ip link add name cbr0 type bridge 
#ip link set dev cbr0 mtu 1460
#ip add add 10.3.0.1/16 dev cbr0
#ip link set dev cbr0 up 
#iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -m addrtype ! --dst-type LOCAL -j MASQUERADE

cat<<EOF>/etc/systemd/system/multi-user.target.wants/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
EnvironmentFile=-/etc/default/docker
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
#ExecStart=/usr/bin/docker daemon -H fd:// $DOCKER_OPTS
ExecStart=/usr/bin/docker daemon -H fd:// --bridge=cbr0 --iptables=false --ip-masq=false
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

service docker restart 

aptitude install -y daemontools-run 

svc -t /etc/service/*

