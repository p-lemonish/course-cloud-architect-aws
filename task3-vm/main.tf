terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  profile = "cloud-architect-task3"
}

locals {
  common_tags = {
    Course         = "cloud_architectures_AWS-ICI010AS3AE_3003"
    Implementation = "Chatroom-IaC"
    Task           = "task-3-vm"
    Student        = "patrik"
    DeploymentType = "Terraform"
  }
}
