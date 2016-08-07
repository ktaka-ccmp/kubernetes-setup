#!/bin/bash 

########## Install docker
apt-get update
apt-get install -y aptitude

aptitude -y update 
aptitude -y upgrade

###########
rsync -av ./rootfs_common/ /
rsync -av ./rootfs_master/ /
gunzip -f /usr/local/bin/hyperkube.gz
gunzip -f /usr/local/bin/etcd.gz
gunzip -f /usr/local/bin/etcdctl.gz

aptitude install -y daemontools-run 

svc -t /etc/service/*

sleep 3
etcdctl mk /coreos.com/network/config '{"Network":"10.0.0.0/16","SubnetLen": 24}'
etcdctl get /coreos.com/network/config

sleep 5
watch -n 1 "kubectl get svc -o wide ; kubectl get pod -o wide ;kubectl get node"
