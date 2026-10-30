# AWS Jenkins + Terraform + Ansible starter

Creates a small Ubuntu EC2 web server, then installs Nginx and deploys `app/index.html`.

## Prerequisites
- Jenkins agent has AWS CLI credentials/instance role, Terraform, Ansible and the Jenkins `sshagent` step.
- An existing EC2 key pair in the selected AWS region.
- Jenkins credential ID `web-server-ssh-key`, type **SSH Username with private key**, username `ubuntu`, using the matching private key.

## Setup
1. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars`.
2. Set your existing EC2 key pair name and your public IP as `x.x.x.x/32`.
3. Configure the Jenkins job to use this repository and set Script Path to `Jenkinsfile`.
4. Run the pipeline. Review the Terraform plan carefully before approving Apply.
5. Open `http://PUBLIC_IP` using the Terraform output after deployment.

The Jenkins agent's AWS identity needs permissions to create/manage the resources in `terraform/`. This starter uses local Terraform state; configure a remote S3 backend with locking before concurrent/team use.

## Cost and cleanup
EC2 and EBS/network resources may incur charges. When finished, run `terraform destroy` from this project's `terraform/` directory only, and review its plan before confirming. Do not use another project's state.
