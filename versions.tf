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
  access_key = "AKIAUPKWME4XVNOALAM2"
  secret_key = "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"
}
