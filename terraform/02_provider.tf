#############################
# Provider and access details
#############################

# Terraform backend
# See: https://learn.hashicorp.com/tutorials/terraform/github-actions
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "remote" {
    organization = "jro"

    workspaces {
      prefix = "quote-service-"
    }
  }
}




provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = var.aws_region
}
