terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-example-for-eks-230798"        # replace
    key            = "platform/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table" # create this beforehand
    encrypt        = true
  }
}
