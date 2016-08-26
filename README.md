# kubernetes-setup

## Setup

### On Master

```
export MASTER_IP=$(hostname -i)
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup \
&& ./master.sh
```

### On Node

```
export MASTER_IP=${MASTER_IP}

apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup \
&& ./node.sh
```

or...

```
export MASTER_IP=${MASTER_IP}

rsync -ae ssh ktaka@${MASTER_IP}:~/kubernetes-setup ./ && cd kubernetes-setup && ./node.sh 
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

