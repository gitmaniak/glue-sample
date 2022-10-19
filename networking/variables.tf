variable "aws_region" {
  default = "us-east-1"
}

## VPC

variable "vpc_name" {
  description = "VPC for the Legend app"
  type        = string
  default     = "cis-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"

}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "priv_cidr_newbits" {
  description = "number of additional bits with which to extend the cidr prefix"
  type        = number
  default     = 3
}

variable "private_network_acls" {
  description         = "Private Network ACLs"
  type                = map(list(object({
    rule_number = string
    rule_action = string
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_block  = string
  })))
  default             = {
    private_inbound    = [
      {
        rule_number   = 100
        rule_action   = "deny"
        from_port     = 22
        to_port       = 22
        protocol      = "tcp"
        cidr_block    = "0.0.0.0/0"
      },
    ]
    private_outbound   = [
      {
        rule_number   = 100
        rule_action   = "deny"
        from_port     = 22
        to_port       = 22
        protocol      = "tcp"
        cidr_block    = "0.0.0.0/0"
      },
    ]
  }
}

variable "db_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "db_cidr_newbits" {
  description = "number of additional bits with which to extend the cidr prefix"
  type        = number
  default     = 4
}
