terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = "~> 4.0"

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    null = "~> 3.2.1"
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Owner = var.client
      Camp  = true
    }
  }
}

provider "random" {}
