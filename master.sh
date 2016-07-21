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

aptitude install -y daemontools-run 

svc -t /etc/service/*
