# Deploy Hashistack on AWS using Terraform & Ansible.
This repo contains IaC for setting up Hashistack in AWS cloud.
## Tech Stack
- IaC: Ansible, Terraform, [Terraform Cloud](https://app.terraform.io/)
- Infra: AWS, EC2, S3, Ubuntu OS
- SW: Consul, Docker, Nomad, ~Vault~c
## The Big Picture
![Picture](./images/pic.png)

## Usage
### Prerequisites
* Configure [AWS CLI creds](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

### Run locally
1. Clone the repo
2. Edit the vars.tf for ...
   1. AWS (region?)
   2. Hashistack cluster config
3. Create S3 bucket and edit backend.tf respectively

NOTE. If you changed AWS region, please make sure to change the ami_id variable as well. You can check [here](https://cloud-images.ubuntu.com/locator/ec2/) to find respective Ubuntu ami ID for your AWS region.

4. Apply the terraform code.

    terraform init
    terraform validate
    terraform plan -out tf_plan.out
    terraform apply tf_plan.out

Terraform apply will make sure it will provision all required infrastructure and calls Ansible to install/configure Hashistack cluster on top of it.

NOTE. In orer to ssh to the Bastion host, please use "hashi_cluster.pem" key in your project folder. The key is generated during the provisioning and added to the Bastion host too, and the key will be used when running Ansible part.
### or use Terraform Cloud
Terraform Cloud is a cloud-based platform provided by HashiCorp that facilitates the management and collaboration of Terraform configurations for infrastructure provisioning.

1. Fork the repo
2. Login to Terraform Cloud (or [create account](https://app.terraform.io/public/signup/account) at first)
3. Create workspace & project
4. [Connect project](https://developer.hashicorp.com/terraform/cloud-docs/vcs/github-app) to your Github repository
5. Trigger a run

![TFC](./images/tfc.png)

NOTE. In order to ssh to the Bastion host, copy the private key from terraform output.

## HashiCorp Docs
- [Vault](https://developer.hashicorp.com/vault/docs/install)
- [Consul](https://developer.hashicorp.com/consul/downloads)
- [Nomad](https://developer.hashicorp.com/nomad/docs/install)
