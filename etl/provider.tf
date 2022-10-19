terraform {
  required_version        = ">= 1.1.0"
  required_providers {
    aws                   = ">= 4.29.0"
  }
}

provider "aws" {
  profile                 = var.aws_profile
  region                  = var.aws_region
}

locals {
  aws_region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "<acct-id>-tfstate-backend-bucket"
    key    = "network/tfstate.tf"
    region = local.aws_region
  }
}
