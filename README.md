## Automated Microservices Ecosystem: Multi-Node Jenkins CI/CD on AWS with Kubernetes & Prometheus

This project demonstrates a production-ready DevOps ecosystem designed to host a Voting Application. Moving beyond simple containerization, this architecture implements a complete lifecycle, from raw cloud infrastructure provisioning to real-time observability.<br>

The application itself is a polyglot microservices suite consisting of six distinct components: a Python voting front-end, a Node.js results dashboard, a .NET worker, Redis for task queuing, and Postgres for persistent storage. The code for the application can be found here: https://github.com/dockersamples/example-voting-app.git

### Core Architectural Pillars

*   **Infrastructure as Code (IaC):** Utilized **Terraform** to provision two AWS EC2 instances and create Ansible inventory file.
*   **Configuration Management:** Employed **Ansible** playbooks to automate the installation of the Docker engine, Kubernetes (Minikube), and Jenkins dependencies across the cluster nodes.
*   **Distributed CI/CD:** Implemented a **Jenkins Master-Agent architecture** and automated the complete CI/CD flow using Jenkins pipeline.
*   **Container Orchestration:** Deployed the 6-service stack using **Docker** and **Kubernetes**.
*   **Full-Stack Observability:** Integrated the **Prometheus & Grafana** stack via Helm to scrape real-time metrics and visualizing them through dashboards.

  <img width="2300" height="2000" alt="voting-app-project" src="https://github.com/user-attachments/assets/bc739650-32dd-45b3-b95a-2d1de4ed4dde" />

## Steps to execute the project

### Prerequisites

Before starting, ensure you have the following installed and configured:

*   **AWS Account:** An active AWS account with a configured IAM user possessing `AdministratorAccess`.
*   **AWS CLI:** Installed and configured locally (`aws configure`) to interact with your cloud resources.
*   **Terraform:** Installed to manage and provision the infrastructure.
*   **Ansible:** Installed on your local machine to handle configuration management.
*   **Docker Hub Account:** To push and pull custom microservice images.

### Deployment Steps

#### Step 1: Infrastructure Provisioning
Navigate to the terraform directory and initialize the environment:
```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

#### Step 2: Configuration Management
Create a directory ansible-playbooks and copy the two playbooks into the directory and run the playbook:
```bash
cd ansible-playbooks
ansible-playbook -i hosts.ini install_tools_master.yml
ansible-playbook -i hosts.ini install_tools_agent.yml
```
#### Step 3: CI/CD Pipeline (Jenkins)
Don't write every single click, just the main goals:
*   Access Jenkins at `http://<EC2-jenkins-master-IP>:8080`.
*   Create a new Pipeline job and point it to this GitHub repository.
*   Build the pipeline to deploy the microservices to Kubernetes.

#### Step 4: Accessing the Applications & Monitoring

Once the pipeline has finished, you can access the applications. 

> **Note on Connectivity:** 
> * **Remote Access:** Use the **EC2 Public IP** of your Jenkins Agent instance. Ensure your AWS Security Group allows inbound traffic on the ports listed below.
> * **Local Access (via EC2):** If you are accessing these from within another EC2 instance (or if the ports are not exposed publicly), you must use `kubectl port-forward` to map the service to `0.0.0.0`.

| Service | Address | Access Method |
| :--- | :--- | :--- |
| **Voting App** | `http://<EC2-jenkins-agent-IP>:8000` | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/vote 8000:80` |
| **Result App** | `http://<EC2-jenkins-agent-IP>:8001` | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/result 8001:80` |
| **Grafana** | `http://<EC2-jenkins-agent-IP>:3000` | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/grafana 3000:80` |
