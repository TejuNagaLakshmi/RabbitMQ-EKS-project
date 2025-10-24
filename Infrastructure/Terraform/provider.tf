terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Using a stable version of the AWS provider
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}
