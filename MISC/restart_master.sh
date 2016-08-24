#!/bin/bash

rsync -av ./rootfs_common/ /
rsync -av ./rootfs_master/ /
gunzip -f /usr/local/bin/hyperkube.gz
gunzip -f /usr/local/bin/etcd.gz
gunzip -f /usr/local/bin/etcdctl.gz

svc -t /etc/service/*

