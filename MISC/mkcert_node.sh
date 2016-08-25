#!/bin/bash

CERTDIR=/srv/kubernetes/
NODE_IP=172.16.1.102

mkdir -p ${CERTDIR}/node

mkdir -p $CERTDIR && \
pushd $CERTDIR && \
openssl genrsa -out ./node/${NODE_IP}.key 2048 && \
openssl req -new -key ./node/${NODE_IP}.key -subj "/CN=${NODE_IP}" -out ./node/${NODE_IP}.csr && \
openssl x509 -req -in ./node/${NODE_IP}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ./node/${NODE_IP}.crt -days 10000 && \
popd




