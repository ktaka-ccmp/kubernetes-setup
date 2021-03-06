#!/bin/bash 

. ./env

########## Install docker
apt-get update
apt-get install -y aptitude

aptitude -y update 
aptitude -y upgrade

###########

./MISC/mkcert.sh

###########
rsync -av ./rootfs_common/ /
rsync -av ./rootfs_master/ /
gunzip -f /usr/local/bin/hyperkube.gz
gunzip -f /usr/local/bin/etcd.gz
gunzip -f /usr/local/bin/etcdctl.gz

for dir in /usr/service/etcd/env ; do echo ${MASTER_IP} > ${dir}/MASTER_IP ; done

aptitude install -y daemontools-run 

svc -t /etc/service/*

sleep 3
#etcdctl mk  /coreos.com/network/config '{"Network":"10.0.0.0/16","SubnetLen":24,"Backend":{"Type": "vxlan"}}'
#etcdctl mk  /coreos.com/network/config '{"Network":"10.0.0.0/16","SubnetLen":24,"Backend":{"Type": "udp"}}'
etcdctl mk  /coreos.com/network/config '{"Network":"10.0.0.0/16","SubnetLen":24,"Backend":{"Type": "host-gw"}}'
etcdctl get /coreos.com/network/config


###### Install docker registory

aptitude -y install apt-transport-https ca-certificates bridge-utils sudo 

echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
aptitude -y update 
aptitude -y upgrade
aptitude -y install docker-engine

cat<<EOF>/etc/systemd/system/multi-user.target.wants/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd -H fd://  --insecure-registry ${MASTER_IP}:5000
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
service docker restart

service docker status
docker run hello-world

docker run -d -p 5000:5000 -v /var/opt:/var/lib/registry registry \
&& cd TEST/pods/nginx && docker build -t ktaka/nginx . \
&& docker tag ktaka/nginx ${MASTER_IP}:5000/ktaka/nginx \
&& docker push ${MASTER_IP}:5000/ktaka/nginx

######################

sleep 5
watch -n 1 "kubectl get svc -o wide ; kubectl get pod -o wide ;kubectl get node"

