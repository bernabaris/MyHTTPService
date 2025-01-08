# Infrastructure Deployment and Management Assignment

This assignment evaluates skills in deploying and managing infrastructure, troubleshooting, and applying best practices in a Linux-based, containerized, high-availability environment.

## Table of Contents

- [Task 1: Deploy a Systemd Service](#task-1-deploy-a-systemd-service)
- [Task 2: Docker-Based Application Deployment](#task-2-docker-based-application-deployment)
- [Task 3: Kubernetes Cluster Setup](#task-3-kubernetes-cluster-setup)
- [Task 4: Debugging and Troubleshooting](#task-4-debugging-and-troubleshooting)
- [Task 5: Talos-Focused Configuration (Optional)](#task-5-talos-focused-configuration-optional)

---

### Task 1: Deploy a Systemd Service

This task demonstrates how to deploy and manage a simple HTTP server as a service on a Linux system using systemd.

#### Steps

1. **Application Code**
The application is a simple Python HTTP server. My code is in the [my.app](server/myapp.py) file.

2. **Systemd Unit File**
The systemd unit file to manage the HTTP server is in the [myapp.service](systemd/myapp.service) file.

### Task 2: Docker-Based Application Deployment

This task demonstrates how to deploy a multi-container application using Docker. The application consists of two services: a backend service and a Nginx service, both built with Docker.
The [bash](build.sh) script automates the process of building and containerizing the application.

1. **Start the backend and Nginx services, use the following command**
```sh
docker compose -f ./docker/compose/docker-compose.yml up -d
```

### Task 3: Kubernetes Cluster Setup

1. **Update and Upgrade Ubuntu (all nodes)**
```sh
sudo apt update && sudo apt upgrade -y
```

2. **Disable Swap (all nodes)**
```sh
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

3. **Add Kernel Parameters (all nodes)**
```sh
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
```
```sh
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
```
```sh
sudo sysctl --system
```
4. **Install Containerd Runtime (all nodes)**
```sh
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
```
```sh
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
```sh
sudo apt update
sudo apt install -y containerd.io
```
```sh
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
```
```sh
sudo systemctl restart containerd
sudo systemctl enable containerd
```
5. **Add Apt Repository for Kubernetes (all nodes)**
```sh
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

6. **Install Kubectl, Kubeadm, and Kubelet (all nodes)**
```sh
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
7. **Initialize Kubernetes Cluster with Kubeadm (master node)**
```sh
sudo kubeadm init
```
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

8. **Install Calico**
```sh
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml -O
kubectl apply -f calico.yaml
```
```sh
kubectl get nodes
```
### Task 4: Debugging and Troubleshooting



### Task 5: Talos-Focused Configuration (Optional)




## Resources:
- [https://www.moesif.com/blog/technical/api-development/Building-RESTful-API-with-Flask/]
- [https://www.suse.com/support/kb/doc/?id=000019672]
- [https://medium.com/@aedemirsen/docker-compose-ve-nginx-i%CC%87le-y%C3%BCk-dengeleme-load-balancing-2086123992f9]
- [https://hbayraktar.medium.com/how-to-install-kubernetes-cluster-on-ubuntu-22-04-step-by-step-guide-7dbf7e8f5f99]
- [https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises]
- [https://kubernetes.io/releases/]