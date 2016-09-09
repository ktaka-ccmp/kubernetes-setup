#!/bin/bash 

pip install markupsafe ansible
pip install cryptography

HOSTS_FILE=./hosts
HOSTS=$(sed "/^\[.*\]$/d" $HOSTS_FILE|sort -u )

for hst in $HOSTS ; do
	ssh-keygen -R $hst
	ssh-keygen -R $(getent ahostsv4 $hst|cut -f 1 -d " "|uniq)
	ssh-keyscan $hst >> ~/.ssh/known_hosts
done

for hst in $HOSTS ; do
	ssh $hst "hostname; uptime" || exit
done

ansible-playbook -i ./hosts ./main.yml -vv
ansible-playbook -i ./hosts ./node.yml -vv

