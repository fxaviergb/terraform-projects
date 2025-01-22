# Terraform Projects

A collection of Terraform projects demonstrating infrastructure provisioning and management for various scenarios. Examples include:

- Deploying basic cloud infrastructure.
- Setting up multi-tier applications such as the MEAN stack.
- Creating custom AMIs with Packer and provisioning them with Terraform.
- Configuring web servers like NGINX.

## Getting Started

### Prerequisites
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Packer](https://developer.hashicorp.com/packer/downloads) (if using projects involving AMI creation)
- AWS CLI configured with appropriate credentials

Verify installations:
```bash
terraform --version
packer --version
aws --version
```

### Using a Project
1. Navigate to the desired project directory:
   ```bash
   cd <project-directory>
   ```

2. Customize variables in `terraform.tfvars` as needed.

3. Initialize, plan, and apply the Terraform configuration:
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

4. Optionally, destroy resources when finished:
   ```bash
   terraform destroy -auto-approve
   ```

## Contributing
Contributions are welcome! Feel free to submit pull requests for new examples, improvements, or bug fixes.

## License
This repository is licensed under the [MIT License](LICENSE).

## Notes
- Test projects in a sandbox or non-production environment.
- Adjust configurations to match your specific requirements and cloud provider limits.
