## Bucket
variable "bucket_name" {
  description = "tfstate backend bucket Name"
  type        = string
  default     = "tfstate-backend-bucket"
}

variable "bucket_sse_algorithm" {
  type        = string
  description = "Encryption algorithm to use on the S3 bucket. Currently only AES256 is supported"
  default     = "AES256"
}

variable "assume_policy_by" {
  type        = string
  description = "A map that allows you to specify additional AWS principles that will be added to the backend roles assume role policy"
  default     = "role/Admin"
}

variable "aws_region_tfbackend" {
  type        = string
  description = "AWS Region of the S3 bucket to store terraform backend"
  default     = "us-east-1"
}


## KMS Key for Encrypting S3 Buckets

variable "kms_key_alias" {
  description = "The alias for the KMS key as viewed in AWS console. It will be automatically prefixed with `alias/`"
  type        = string
  default     = "tf-remote-state-key"
}

variable "kms_key_description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = "The key used to encrypt the remote state bucket."
}

variable "kms_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days."
  type        = number
  default     = 30
}

variable "kms_key_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  type        = bool
  default     = true
}


## Tags

variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default = {
    Terraform = "true"
  }
}


## Optionally specifying a fixed iam policy name

variable "override_terraform_iam_policy_name" {
  description = "override terraform iam policy name to disable policy_prefix and create policy with static name"
  type        = bool
  default     = true
}

variable "terraform_iam_policy_name" {
  description = "If override_terraform_iam_policy_name is true, use this policy name instead of dynamic name with policy_prefix"
  type        = string
  default     = "terraform-backend-state"
}


## IAM Policy for Executing Terraform with Remote States

variable "terraform_iam_policy_create" {
  description = "Specifies whether to terraform IAM policy is created."
  type        = bool
  default     = true
}

variable "terraform_iam_policy_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  type        = string
  default     = "terraform"
}


## DynamoDB Table for State Locking

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  type        = string
  default     = "tf-remote-state-lock"
}

variable "dynamodb_table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  type        = string
  default     = "PROVISIONED"
}

variable "dynamodb_enable_server_side_encryption" {
  description = "Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK)"
  type        = bool
  default     = false
}

variable "dynamodb_read_capacity" {
  description = "Read capacity units for DynamoDB table"
  type        = number
  default     = 20
}

variable "dynamodb_write_capacity" {
  description = "Write capacity units for DynamoDB table"
  type        = number
  default     = 20
}
