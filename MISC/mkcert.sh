#!/bin/bash

CERTDIR=/srv/kubernetes/
MASTER_IP=172.16.1.101

if [ -d $CERTDIR ] ; then
	echo $CERTDIR already exist.
	exit 0
fi

mkdir -p $CERTDIR && \
pushd $CERTDIR && \
openssl genrsa -out ca.key 2048 && \
openssl req -x509 -new -nodes -key ca.key -subj "/CN=${MASTER_IP}" -days 10000 -out ca.crt && \
openssl genrsa -out server.key 2048 && \
openssl req -new -key server.key -subj "/CN=${MASTER_IP}" -out server.csr && \
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 10000 && \
popd




