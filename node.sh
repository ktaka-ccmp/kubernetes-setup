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

service docker stop

###########
rsync -av ./rootfs_common/ /
rsync -av ./rootfs_node/ /
gunzip -f /usr/local/bin/hyperkube.gz
gunzip -f /usr/local/bin/etcd.gz
gunzip -f /usr/local/bin/etcdctl.gz
gunzip -f /usr/local/bin/flanneld.gz

iptables -F  -t nat
ip link set docker0 down 
ip link delete docker0

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

aptitude install -y daemontools-run 

svc -t /etc/service/*

