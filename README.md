# kubernetes-setup

## Setup

### On Master

```
echo export MASTER_IP=$(hostname -i)
export MASTER_IP=$(hostname -i);  script=./master.sh
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup \
&& $script
```

### On Node

```
export MASTER_IP=${MASTER_IP}

script=./node.sh
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup \
&& $script
```

or...

```
export MASTER_IP=${MASTER_IP}

script=./node.sh
rsync -ae ssh ktaka@${MASTER_IP}:~/kubernetes-setup ./ && cd kubernetes-setup && $script
```

### How to monitor whole cluster

```
watch -n 1 "kubectl get svc -o wide ; kubectl get pod -o wide ;kubectl get node"
```


## for flannel branch

### On Master

```
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup \
&& git checkout flannel \
&& ./master.sh
```

### On Node

```
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup \
&& git checkout flannel \
&& ./node.sh
```

