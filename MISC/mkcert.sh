#!/bin/bash

. ./env

CERTDIR=/srv/kubernetes
PKIDIR=/srv/pki

for DIR in $CERTDIR $PKIDIR ; do
if [ -d $DIR ] ; then
	echo $DIR already exist.
        mv $DIR $DIR.$(date +"%Y%m%d%H%M" -r $DIR)
fi
done

mkdir -p $PKIDIR || exit 1
cd $PKIDIR

openssl genrsa -out ca.key 2048 
openssl req -x509 -new -nodes -key ca.key -subj "/CN=${MASTER_IP}" -days 10000 -out ca.crt 

for ip in $IPRANGE ; do 

ip=${IPPREFIX}.${ip}

cat<<EOF > $ip.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
IP.1 = ${ip}
IP.1 = 10.254.0.1
EOF

openssl genrsa -out $ip.key 2048 
openssl req -new -key $ip.key -subj "/CN=$ip" -out $ip.csr -config $ip.cnf 
openssl x509 -req -in $ip.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out $ip.crt -days 10000  -extensions v3_req -extfile $ip.cnf

cat $ip.crt ca.crt > $ip.crt.bundle

done

mkdir -p $CERTDIR || exit 1

cp $PKIDIR/ca.crt $CERTDIR/ca.crt
cp $PKIDIR/${MASTER_IP}.key $CERTDIR/server.key
cp $PKIDIR/${MASTER_IP}.crt $CERTDIR/server.crt


