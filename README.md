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



### Task 4: Debugging and Troubleshooting



### Task 5: Talos-Focused Configuration (Optional)




## Resources:
- [https://www.moesif.com/blog/technical/api-development/Building-RESTful-API-with-Flask/]
- [https://www.suse.com/support/kb/doc/?id=000019672]
- [https://medium.com/@aedemirsen/docker-compose-ve-nginx-i%CC%87le-y%C3%BCk-dengeleme-load-balancing-2086123992f9]