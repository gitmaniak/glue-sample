locals {
  azs               = data.aws_availability_zones.available.names
}

# resource "aws_rds_cluster" "default" {
#   cluster_identifier      = "aurora-cluster-demo"
#   engine                  = "aurora-mysql"
#   engine_version          = "5.7.mysql_aurora.2.10.2"
#   availability_zones      = ["us-west-2a", "us-west-2c"]
#   database_name           = "mydb"
#   master_username         = "foo"
#   master_password         = "masterpwd"
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"
#   skip_final_snapshot     = true
# }

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name           = "test-aurora-db-postgres96"
  engine         = "aurora-mysql"
  engine_version = "Default"
  instance_class = "db.r6g.large"
  instances = {
    one = {}
    2 = {
      instance_class = "db.r6g.2xlarge"
    }
  }

  vpc_id  = terraform_remote_state.networking.vpc_id
  subnets = terraform_remote_state.networking.private_subnets

  allowed_security_groups = ["sg-12345678"]
  allowed_cidr_blocks     = ["10.20.0.0/20"]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = "default"
  db_cluster_parameter_group_name = "default"

  enabled_cloudwatch_logs_exports = ["general"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
