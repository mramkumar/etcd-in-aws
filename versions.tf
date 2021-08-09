terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

}

provider "aws" {
  region = var.aws-region
  access_key = "AKIA4WCN3RXZONXTGF46"
  secret_key = "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"
}
