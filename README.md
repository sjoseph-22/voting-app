## Automated Microservices Ecosystem: Multi-Node Jenkins CI/CD on AWS with Kubernetes & Prometheus

This project demonstrates a production-ready DevOps ecosystem designed to host a Voting Application. Moving beyond simple containerization, this architecture implements a complete lifecycle, from raw cloud infrastructure provisioning to real-time observability.<br>

The application itself is a polyglot microservices suite consisting of six distinct components: a Python voting front-end, a Node.js results dashboard, a .NET worker, Redis for task queuing, and Postgres for persistent storage. The code for the application can be found here: https://github.com/dockersamples/example-voting-app.git

### Core Architectural Pillars

*   **Infrastructure as Code (IaC):** Utilized **Terraform** to provision two AWS EC2 instances.
*   **Configuration Management:** Employed **Ansible** playbooks to automate the installation of the Docker engine, Kubernetes (Minikube), and Jenkins dependencies across the cluster nodes.
*   **Distributed CI/CD:** Implemented a **Jenkins Master-Agent architecture** and automated the complete CI/CD flow using Jenkins pipeline.
*   **Container Orchestration:** Deployed the 6-service stack using **Docker** and **Kubernetes**.
*   **Full-Stack Observability:** Integrated the **Prometheus & Grafana** stack via Helm to scrape real-time metrics and visualizing them through dashboards.

  <img width="2699" height="2400" alt="voting-app-project" src="https://github.com/user-attachments/assets/bc739650-32dd-45b3-b95a-2d1de4ed4dde" />
