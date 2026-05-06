## Automated Microservices Ecosystem: Multi-Node Jenkins CI/CD on AWS with Kubernetes & Prometheus

This project demonstrates a production-ready DevOps ecosystem designed to host a Voting Application. Moving beyond simple containerization, this architecture implements a complete lifecycle, from raw cloud infrastructure provisioning to real-time observability.<br>

The application itself is a polyglot microservices suite consisting of six distinct components: a Python voting front-end, a Node.js results dashboard, a .NET worker, Redis for task queuing, and Postgres for persistent storage. The code for the application can be found here: https://github.com/dockersamples/example-voting-app.git

### Core Architectural Pillars

*   **Infrastructure as Code (IaC):** Utilized **Terraform** to provision two AWS EC2 instances and create Ansible inventory file.
*   **Configuration Management:** Employed **Ansible** playbooks to automate the installation of the Docker engine, Kubernetes (Minikube), and Jenkins dependencies across the cluster nodes.
*   **Distributed CI/CD:** Implemented a **Jenkins Master-Agent architecture** and automated the complete CI/CD flow using Jenkins pipeline.
*   **Container Orchestration:** Deployed the 6-service stack using **Docker** and **Kubernetes**.
*   **Observability:** Integrated the **Prometheus & Grafana** stack via Helm to scrape real-time metrics and visualizing them through dashboards.

  <img width="2300" height="2000" alt="voting-app-project" src="https://github.com/user-attachments/assets/bc739650-32dd-45b3-b95a-2d1de4ed4dde" />

## Steps to execute the project

### Prerequisites

Before starting, ensure you have the following installed and configured:

*   **AWS Account:** An active AWS account with a configured IAM user possessing `AdministratorAccess`.
*   **AWS CLI:** Installed and configured locally (`aws configure`) to interact with your cloud resources.
*   **Terraform:** Installed to manage and provision the infrastructure.
*   **Docker:** To build and push microservice images.
*   **Kubernetes:** To deploy containers and manage them.
*   **Helm:** Kubernetes package manager to install Prometheus and Grafana.
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
*   Access Jenkins at `http://<EC2-jenkins-master-IP>:8080`.
*   Create a new Pipeline job and point it to this GitHub repository.
*   Build the pipeline to deploy the microservices to Kubernetes.

Enable Automated Triggers (GitHub Webhook):
* To ensure the pipeline runs automatically on every git push:

- In Jenkins: Under your Job Configuration, check the box for "GitHub hook trigger for GITScm polling".
- In GitHub: Go to your Repository Settings > Webhooks > Add webhook.
- Payload URL: Enter `http://<EC2-jenkins-master-IP>:8080/github-webhook/`.
- Content type: Set to application/json.
- Event: Select "Just the push event" and click Add webhook.

#### Step 4: Installing Prometheus and Grafana using Helm

Use the below links to install Prometheus and Grafana:<br>
`https://medium.com/@gayatripawar401/deploy-prometheus-and-grafana-on-kubernetes-using-helm-5aa9d4fbae66`


#### Step 5: Accessing the Applications & Monitoring

Once the pipeline has finished, you can access the applications. 

Since we are deploying are kubernetes pods in an EC2 instance, we need to use `kubectl port-forward`

| Service | Port-forward | Access Method |
| :--- | :--- | :--- |
| **Voting App** | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/vote-service 8000:8080` | `http://<EC2-jenkins-agent-IP>:8000` |
| **Result App** | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/result-service 8001:8081` | `http://<EC2-jenkins-agent-IP>:8001` |
| **Prometheus** | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/prometheus-server-ext 9090:80`  | `http://<EC2-jenkins-agent-IP>:9090` |
| **Grafana** | Port-forward: `kubectl port-forward --address 0.0.0.0 svc/grafana-ext 9091:80` | `http://<EC2-jenkins-agent-IP>:9091` |

Use the Grafana IP to access the dashboard:

##### Get Grafana Login Credentials:
By default, the username is `admin`. To retrieve the auto-generated password, run:
```bash
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
Select data-source as **Prometheus** and use any pre-built templates for making dashboards.

<img width="959" height="442" alt="grafana" src="https://github.com/user-attachments/assets/10dd4352-74a0-4cfa-8da2-0ef908fc32e2" />

#### Step 6: Cleanup
To avoid ongoing AWS charges, destroy the infrastructure when finished:
```bash
terraform destroy -auto-approve
```






