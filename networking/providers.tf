# provider "aws" {
#     region = data.aws_region.current.name
# }


terraform {
  backend "s3" {
    bucket = "<acct-id>-tfstate-backend-bucket"
    key    = "network/tfstate.tf"
    region = "us-west-2"
  }
}
