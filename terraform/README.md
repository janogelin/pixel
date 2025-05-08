# Terraform Deployment for Pixel Traffic System

This directory contains Terraform configuration files to deploy the pixel traffic system infrastructure on AWS, based on the sizing and architecture specifications.

## Structure
- `main.tf` — Root Terraform configuration and provider setup
- `vpc.tf` — VPC, subnets, route tables, NAT/Internet Gateways
- `security.tf` — Security groups, NACLs, and firewall rules
- `alb.tf` — Application Load Balancers
- `autoscaling.tf` — EC2 Auto Scaling Groups and Launch Templates
- `msk.tf` — Amazon MSK (Kafka) cluster
- `flink.tf` — Flink/EMR cluster
- `iceberg.tf` — S3/Iceberg/Nessie resources
- `s3.tf` — S3 buckets and prefix structure
- `aerospike.tf` — Aerospike cluster (EC2-based)
- `kms.tf` — KMS keys and encryption resources
- `secrets.tf` — AWS Secrets Manager resources
- `cloudwatch.tf` — Monitoring, dashboards, and alarms
- `variables.tf` — Input variables for sizing and configuration
- `outputs.tf` — Outputs for integration and reference

## Using Terraform Workspaces

Terraform workspaces allow you to manage multiple environments (e.g., dev, staging, prod) using the same configuration. Each workspace has its own state and can have different variable values.

### Basic Workflow

1. **Initialize Terraform:**
   ```sh
   terraform init
   ```
2. **Create a new workspace:**
   ```sh
   terraform workspace new dev
   terraform workspace new prod
   ```
3. **Select a workspace:**
   ```sh
   terraform workspace select dev
   ```
4. **Apply configuration in the selected workspace:**
   ```sh
   terraform apply
   ```
5. **Switch between workspaces as needed:**
   ```sh
   terraform workspace select prod
   terraform apply
   ```

### Tips
- Use workspace-specific variable files (e.g., `terraform.tfvars.dev`, `terraform.tfvars.prod`) and pass them with `-var-file`:
  ```sh
  terraform apply -var-file="terraform.tfvars.dev"
  ```
- Each workspace maintains its own state file, so resources are isolated per environment.
- You can list all workspaces with:
  ```sh
  terraform workspace list
  ```

## Notes
- AMI IDs, instance types, and other AWS-specific resources are stubbed and should be updated for your environment.
- All resources are sized according to the recommendations in the specs directory.
- This is a starting point; customize as needed for your project and compliance requirements. 