# provider "aws" {
#     region = data.aws_region.current.name
# }
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
