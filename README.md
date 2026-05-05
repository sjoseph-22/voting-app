## Automated Microservices Ecosystem: Multi-Node Jenkins CI/CD on AWS with Kubernetes & Prometheus

This project demonstrates a production-ready DevOps ecosystem designed to host a Voting Application. Moving beyond simple containerization, this architecture implements a complete lifecycle, from raw cloud infrastructure provisioning to real-time observability.<br>

The application itself is a polyglot microservices suite consisting of six distinct components: a Python voting front-end, a Node.js results dashboard, a .NET worker, Redis for task queuing, and Postgres for persistent storage. The code for the application can be found here: https://github.com/dockersamples/example-voting-app.git

### Core Architectural Pillars

*   **Infrastructure as Code (IaC):** Utilized **Terraform** to provision two AWS EC2 instances.
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
*   **Terraform:** Installed (v1.0+) to manage and provision the infrastructure.
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
Update the `inventory` file with your EC2 Public IPs and run the playbook:
```bash
ansible-playbook -i inventory setup-tools.yml
