terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.aws_region
}

provider "random" {
  # Configuration options
}
