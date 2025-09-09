# 🚀 Data Platform on AWS

## 📌 Overview
This project provisions a **Data Analytics Platform** on AWS using modern DevOps and Data Engineering tools.  
It provides a foundation for internal developer teams to build and manage **ETL pipelines, data storage, and analytics workloads** in a secure and scalable way.

**Core Features:**
- **Airflow on EKS** (orchestration & scheduling)
- **Redshift Serverless** (data warehouse)
- **S3 Buckets** (data lake: raw, configs, logs)
- **KMS Encryption**
- **IAM Roles for Service Accounts (IRSA)**
- **Terraform Infrastructure as Code**
- **Helm + Argo CD for GitOps Deployments**

---

## 🏗️ Architecture

**Data Flow:**
1. **Raw Data** → Stored in S3 (`raw`, `configs`, `airflow-logs`)
2. **Airflow DAGs** → Run inside EKS (with IRSA for secure AWS access)
3. **ETL Jobs** → Extract & Transform → Load into Redshift
4. **Redshift Serverless** → Stores curated fact/dimension tables
5. **BI Tools** (QuickSight, Tableau, Power BI) → Connect to Redshift
6. **Spectrum** (Optional) → Query S3 raw data directly

---

## 📂 Repository Structure

platform/
├── terraform/
│ ├── modules/ # Reusable modules
│ │ ├── vpc/
│ │ ├── eks/
│ │ ├── redshift/
│ │ ├── s3_data/
│ │ ├── kms/
│ │ ├── ecr/
│ │ └── iam_irsa/
│ └── envs/
│ ├── dev/
│ │ └── main.tf
│ └── prod/
├── apps/
│ └── argocd/
│ └── bootstrap/
│ └── argocd-app.yaml
│ └── values.yaml
├── charts/
│ └── airflow/
│ 
└── .github/
└── workflows/
└── terraform-apply.yaml
└── terraform.yaml
└── terraform-destroy.yaml
└── deploy-argocd.yaml


