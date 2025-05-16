# DEPI DevOps Capstone Project – Infrastructure

This repository contains the complete Infrastructure-as-Code (IaC) setup for the [DEPI\_GP](https://github.com/gimmeursocks/DEPI_GP) microservices-based TODO application. It provisions and manages cloud infrastructure using Terraform, deploys workloads on EKS via Helm, configures EC2 instances via Ansible, and automates CI/CD through GitHub Actions.

> ✅ Designed for scalability, reproducibility, and automation in real-world production settings.

---

## 🗂️ Project Structure

* **Cloud Provider:** AWS
* **IaC Tools:** Terraform, Helm, Ansible
* **CI/CD:** GitHub Actions
* **Kubernetes Addons:** AWS Load Balancer Controller
* **Cloud Databases:** Amazon RDS (PostgreSQL), Amazon DocumentDB (MongoDB-compatible)

---

## ⚙️ Infrastructure Overview

### 🏗️ Terraform Modules

We use custom-built, reusable Terraform modules to provision core cloud resources:

| Module         | Description                                         |
| -------------- | --------------------------------------------------- |
| `networking`   | VPC, subnets (public/private), NAT gateway, routing |
| `security/iam` | IAM roles and policies for EKS, EC2, Jenkins        |
| `eks`          | Amazon EKS cluster with node groups                 |
| `alb_ingress`  | AWS Load Balancer Controller via Helm               |
| `rds`          | PostgreSQL database (for auth-service)              |
| `docdb`        | DocumentDB cluster (for todo-service)               |
| `ecr`          | Container registry for Docker images                |
| `ec2`          | Jenkins master/agent provisioning                   |

---

### 🕸️ Network Architecture

* **VPC CIDR**: Customizable via `var.vpc_cidr`
* **Subnets**: Two public and two private subnets across availability zones
* **Public Subnets**: For load balancers, NAT Gateway, and EKS ingress
* **Private Subnets**: For EKS worker nodes, databases, and internal services
* **Routing**: Public route table with IGW, private route table with NAT

---

## 🚀 CI/CD Automation

### ✅ GitHub Actions

This repository uses GitHub Actions to automate:

* `terraform plan` and `apply`
* Dynamic inventories for ansible
* `ansible-playbook` for EC2 instance provisioning

All changes to infrastructure go through version-controlled, auditable pipelines.

---

### 🧰 Ansible

Ansible is used to provision and configure:

* Jenkins master and agents
* SSH access configuration
* Package installation and system settings on EC2

---

## ☸️ Kubernetes Deployment (via Terraform)

* Helm provider installs:

  * Application Helm chart from [`gimmeursocks/DEPI_GP`](https://github.com/gimmeursocks/DEPI_GP)
  * AWS Load Balancer Controller

---

## 🔐 Security Groups

| SG           | Purpose                                          |
| ------------ | ------------------------------------------------ |
| `default-sg` | Internal DB access (PostgreSQL, DocumentDB)      |
| `ec2-ssh-sg` | SSH access to EC2 (Jenkins) from whitelisted IPs |
| `jenkins-sg` | Jenkins web and JNLP agent communication         |

---
## 📦 Related Repositories

| Repo                                                                          | Description                                                                         |
| ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| [`gimmeursocks/DEPI_GP`](https://github.com/gimmeursocks/DEPI_GP)             | App source code: microservices (FastAPI, Go, TypeScript), Docker images, Helm chart |
| [`gimmeursocks/DEPI_GP_Infra`](https://github.com/gimmeursocks/DEPI_GP_Infra) | Infrastructure code (this repo): EKS, Terraform, Helm, Ansible, CI/CD               |

---
