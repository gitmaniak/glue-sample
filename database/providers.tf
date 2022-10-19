terraform {
  backend "s3" {
    bucket = "<acct-id>-tfstate-backend-bucket"
    key    = "data/tfstate.tf"
    region = "us-west-2"
  }
}

# provider "aws" {
#     region = data.aws_region.current.name
# }
