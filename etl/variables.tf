# general variables 

variable "aws_profile" {
  type                    = string
  default                 = "default"
  description             = "Specify an aws profile name to be used for access credentials (run `aws configure help` for more information on creating a new profile)"
}

variable "aws_region" {
  type                    = string
  default                 = "us-east-1"
  description             = "Specify the AWS region to be used for resource creations"
}

variable "aws_env" {
  type                    = string
  default                 = "dev"
  description             = "Specify a value for the Environment tag"
}

variable "app_name" {
  type                    = string
  description             = "Specify an application or project name, used primarily for tagging"
}

variable "app_shortcode" {
  type                    = string
  description             = "Specify a short-code or pneumonic for this application or project"
}

variable "glue_version" {
  type                    = number
  description             = "Glue version"
}

# app variables - for testing redshift

/*
variable "client_vpc_id" {
  type                    = string
  description             = "Specify a VPC ID where Client App resources will be created"
}

variable "client_subnet_ids" {
  type                    = list 
  description             = "Specify a list of Subnet IDs where Client App resources will be deployed"
}

variable "client_ssh_cidr_blocks" {
  type                    = list
  description             = "Specify list of source CIDR blocks to allow SSH access into Client App instances"
}

variable "client_ssh_keypair_name" {
  type                    = string
  description             = "Specify name of an existing keypair to be used for SSH access into Client App instances"
}

variable "lambda_name" {
  type                    = string 
  default                 = "GetKeyLambda"
  description             = "Specify a name to be used for Lambda function"
}

variable "lambda_name2" {
  type                    = string 
  default                 = "MaskStrLambda"
  description             = "Specify a name to be used for Lambda function"
}
*/
