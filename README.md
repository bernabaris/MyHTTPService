# Infrastructure Deployment and Management Assignment

This assignment evaluates skills in deploying and managing infrastructure, troubleshooting, and applying best practices in a Linux-based, containerized, high-availability environment.

## Table of Contents

- [Task 1: Deploy a Systemd Service](#task-1-deploy-a-systemd-service)
- [Task 2: Docker-Based Application Deployment](#task-2-docker-based-application-deployment)
- [Task 3: Kubernetes Cluster Setup](#task-3-kubernetes-cluster-setup)
- [Task 4: Debugging and Troubleshooting](#task-4-debugging-and-troubleshooting)

---

### Task 1: Deploy a Systemd Service

This task demonstrates how to deploy and manage a simple HTTP server as a service on a Linux system using systemd.

#### Steps

1. **Application Code**
The application is a simple Python HTTP server. My code is in the [my.app](server/myapp.py) file.

2. **Systemd Unit File**
The systemd unit file to manage the HTTP server is in the [myapp.service](systemd/myapp.service) file.

### Task 2: Docker-Based Application Deployment

This task demonstrates how to deploy a multi-container application using Docker. The application consists of two services: a http appp and a Nginx service, both built with Docker.
The [bash](build.sh) script automates the process of building and containerizing the application.

1. **Start the http app and Nginx services, use the following command**
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
9. **Deploy test application on cluster (master node)**
```sh
kubectl run nginx --image=nginx
```

10. **Check if my pod in the pending state**
```sh
kubectl describe pod nginx
```

11. **Allow scheduling of pods on Kubernetes master**
```sh
kubectl taint nodes --all  node-role.kubernetes.io/control-plane-
```

12. **Delete test pod**
```sh
kubectl delete pod nginx
```
13. **Install Helm**
Download your [desired version](https://github.com/helm/helm/releases).
```sh
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
```
```sh
mv linux-amd64/helm /usr/local/bin/helm
```
14. **To prevent port conflicts, docker compose down**
```sh
docker compose -f ./docker/compose/docker-compose.yml down
```

15. **To deploy helm chart**
```sh
helm upgrade http-app ./chart --install --namespace default
```

16. **Forward a local port to the ingress controller:**
```sh
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80
```
### Task 4: Debugging and Troubleshooting

For detailed documentation on the troubleshooting process and fixes, refer to:  
**[debugging-troubleshooting.pdf](./debugging-troubleshooting.pdf)**


## Resources:
- [https://www.moesif.com/blog/technical/api-development/Building-RESTful-API-with-Flask/]
- [https://www.suse.com/support/kb/doc/?id=000019672]
- [https://medium.com/@aedemirsen/docker-compose-ve-nginx-i%CC%87le-y%C3%BCk-dengeleme-load-balancing-2086123992f9]
- [https://hbayraktar.medium.com/how-to-install-kubernetes-cluster-on-ubuntu-22-04-step-by-step-guide-7dbf7e8f5f99]
- [https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises]
- [https://kubernetes.io/releases/]
- [https://medium.com/@shyamsandeep28/scheduling-pods-on-master-nodes-7e948f9cb02c]
- [https://helm.sh/docs/intro/install/]
- [https://github.com/helm/examples.git]
- [https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/]
- [https://kubernetes.github.io/ingress-nginx/deploy/]