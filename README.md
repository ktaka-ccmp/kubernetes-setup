# kubernetes-setup

## Setup

### On Master

```
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup 
MASTER_IP=${MASTER_IP} ./master.sh
```

### On Node

```
apt-get update && apt-get install -y git \
&& ssh-keyscan github.com >> ~/.ssh/known_hosts \
&& git clone git@github.com:ktaka-ccmp/kubernetes-setup.git \
&& cd kubernetes-setup 
MASTER_IP=${MASTER_IP} ./node.sh
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

