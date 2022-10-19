resource "aws_dynamodb_table" "terraform_state_lock" {
 name           = var.dynamodb_table_name
 read_capacity  = var.dynamodb_read_capacity
 write_capacity = var.dynamodb_write_capacity
 hash_key       = "LockID"
 billing_mode   = var.dynamodb_table_billing_mode

 attribute {
   name = "LockID"
   type = "S"
 }
 
 server_side_encryption {
    enabled     = var.dynamodb_enable_server_side_encryption
    kms_key_arn = aws_kms_key.this.arn
  }

  point_in_time_recovery {
    enabled = true
  }

}
