//<editor-fold desc="Credentials">
provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region = "us-east-2"
}

#https://learn.hashicorp.com/terraform/getting-started/install.html - to install terraform
#type 'terraform init' before you start.
#aws_access_key_id = "type your IAM access key id to here"
#aws_secret_access_key = "type your IAM secret access key to here"
#Put above two lines to secret-variables.auto.tfvars file.
#terraform apply to build the app.

module "VPC" {
  source = "./VPC"
  PublicSubnet = module.VPC.PublicSubnet
}

module "SECG" {
  source = "./SECG"
  VpcId = module.VPC.VpcID
}

module "IAM" {
  source = "./IAM"
}

module "EC2" {
  source = "./EC2"
  VpcId = module.VPC.VpcID
  PublicSubnet = module.VPC.PublicSubnet
  UnifiPoller-SecG = module.SECG.UnifiPoller-SecG
  SSM-Instance-Profile = module.IAM.SSM-Instance-Profile
}

