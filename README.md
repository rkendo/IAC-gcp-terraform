Terraform AWS Multi-Environment Infrastructure
This project demonstrates provisioning AWS infrastructure using Terraform modules, remote state management, and environment-based deployments.

The infrastructure includes networking, compute resources, and secure state management following real-world DevOps practices.

🚀 Architecture
The infrastructure provisions:

Custom AWS VPC
Public and Private Subnets
Internet Gateway
Route Tables
EC2 Instance
Security Group
Terraform Remote State (S3)
State Locking using DynamoDB
image
📂 Project Structure
image
⚙️ Terraform Workflow
Initialize Terraform $ terraform init

Preview infrastructure changes $ terraform plan

Deploy infrastructure $ terraform apply

Destroy infrastructure $ terraform destroy

🔐 Remote State Management
Terraform state is stored securely using:

AWS S3 for remote state storage
DynamoDB for state locking
This ensures safe collaboration when multiple engineers manage the same infrastructure.

📊 Infrastructure Provisioned
Resource	Purpose
VPC	Network isolation
Subnets	Public and private networking
Internet Gateway	Public internet access
Route Tables	Traffic routing
EC2 Instance	Compute infrastructure
Security Group	Instance access control
S3 Bucket	Terraform state storage
DynamoDB	Terraform state locking
🧠 Key DevOps Concepts Demonstrated
Infrastructure as Code
Terraform Modules
Multi-Environment Infrastructure
Remote State Management
AWS Networking
EC2 Compute Provisioning
