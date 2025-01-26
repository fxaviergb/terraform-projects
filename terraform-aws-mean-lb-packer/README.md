# MEAN Stack Infrastructure Deployment

## Prerequisites
To set up and deploy the infrastructure, ensure you have the following tools installed on your system:

### Windows
- [Packer](https://developer.hashicorp.com/packer/downloads)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [PowerShell](https://learn.microsoft.com/en-us/powershell/)

### macOS
- [Packer](https://developer.hashicorp.com/packer/downloads) (`brew install packer` recommended)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (`brew install terraform` recommended)
- Terminal (default macOS terminal or iTerm2)

### Linux
- [Packer](https://developer.hashicorp.com/packer/downloads)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Shell (e.g., Bash, Zsh)

Verify installation by running the following commands:
```bash
packer --version
terraform --version
```

---

## Manual Installation

### Step 1: Build AMIs using Packer
Navigate to the `packer` directory:
```bash
cd ./packer
```

#### MEAN App AMI
```bash
packer validate mean-app.json
packer build mean-app.json
```
**Result example:** `us-east-1: ami-001f5550f42d325bf`

#### MongoDB AMI
```bash
packer validate mongodb.json
packer build mongodb.json
```
**Result example:** `us-east-1: ami-03e5b40af336b7337`

Copy the generated AMI IDs into `terraform.tfvars`:
```hcl
mean_app_ami = "ami-001f5550f42d325bf"
mongodb_ami  = "ami-03e5b40af336b7337"
```

### Step 2: Deploy Infrastructure using Terraform
Navigate to the `terraform` directory:
```bash
cd ../terraform
```

#### Initialize Terraform
```bash
terraform init
```

#### Plan and Apply Changes
```bash
terraform plan
terraform apply -auto-approve
```

#### Verify Outputs
Check the outputs in terminal. For example:
```bash
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

Outputs:

lb_dns = "mean-lb-1210810691.us-east-1.elb.amazonaws.com"
nat_gateway_public_ip = "44.216.159.168"
private_ips = [
  "10.0.0.19",
  "10.0.1.228",
]
public_ips = [
  "54.226.23.227",
  "54.224.53.94",
]
```

#### Destroy Infrastructure
When finished, clean up resources:
```bash
terraform destroy -auto-approve
```

---

## Automatic Installation

Run the provided PowerShell script for fully automated deployment:
```powershell
.\deploy-mean-stack.ps1 -ExecutionType "all"
```
Run the provided PowerShell script for AMIs creation with Packer:
```powershell
.\deploy-mean-stack.ps1 -ExecutionType "packer"
```
Run the provided PowerShell script for IaC deploy with Terraform:
```powershell
.\deploy-mean-stack.ps1 -ExecutionType "terraform"
```
Ensure the script has execution permissions:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

## Testing the Deployment

### 1. Verify MEAN Application
- Obtain the public DNS or IP of the MEAN app instance from Terraform outputs.
- Access the application in your browser:
  ```
  http://<MEAN_APP_PUBLIC_IP> or http://<LOAD_BALANCER_DNS>
  ```
- Confirm that the application is running and accessible.

### 2. Verify MongoDB
- Connect to the MongoDB instance using a MongoDB client:
  ```bash
  mongo --host <MONGODB_PUBLIC_IP> --port 27017
  ```
- Confirm connectivity and database access.

### 3. Cleanup
After testing, destroy the infrastructure if no longer needed:
```bash
terraform destroy -auto-approve
```

---

## Notes
- Adjust configuration files (`mean-app.json`, `mongodb.json`, and `terraform.tfvars`) as needed for your specific requirements.
- For advanced use cases, consider integrating CI/CD tools for automated deployments.
