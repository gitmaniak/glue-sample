# 
# Create an IAM role for Redshift cluster to assume, to run rsql commands such as COPY, UNLOAD and CREATE EXTERNAL FUNCTION

resource "aws_iam_role" "glue_assume_role" {
  name                = "${var.app_shortcode}_glue_assume_role"

  assume_role_policy  = jsonencode({
    Version           = "2012-10-17",
    Statement         = [
      {
        Action        = [ "sts:AssumeRole" ]
        Principal     = {
          Service     = "glue.amazonaws.com"
        }
        Effect        = "Allow"
        Sid           = "GlueAssumeRolePolicy"
      }
    ]
  })
}

resource "aws_iam_policy" "glue_permissions_policy" {
  name        = "${var.app_shortcode}_glue_permissions_policy"
  path        = "/"
  description = "IAM policy with minimum permissions for Glue Jobs"

  policy = jsonencode({
    Version         = "2012-10-17"
    Statement       = [
      {
        Action      = [
          "s3:*",
        ]
        Resource    = "arn:aws:s3:::*${local.account_id}*"
        Effect      = "Allow"
        Sid         = "AllowS3Access"
      }, 
      {
        Action      = [
          "logs:CreateLogGroup",
        ]
        Resource    = "arn:aws:logs:${var.aws_region}:${local.account_id}:*"
        Effect      = "Allow"
        Sid         = "AllowCloudWatchLogsAccess"
      }, 
      {
        Action      = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource    = "arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:*:*"
        Effect      = "Allow"
        Sid         = "AllowCloudWatchPutLogEvents"
      }, 
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_assume_role_basic_policy" {
  role              = aws_iam_role.glue_assume_role.name
  policy_arn        = aws_iam_policy.glue_permissions_policy.arn
  #policy_arn        = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_assume_role_standard_policy" {
  role              = aws_iam_role.glue_assume_role.name
  policy_arn        = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

#
# Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "glue_etl_log_group" {
  name                    = "/aws-glue/jobs/json_transform"
  retention_in_days       = var.log_retention 
}

#
# Glue Dev Endpoint
resource "aws_glue_dev_endpoint" "example" {
  name              = var.glue_endpoint
  role_arn          = aws_iam_role.glue_assume_role.arn
}

#
# Create Glue ETL job

resource "aws_glue_job" "file_processing" {
  name              = "${var.app_shortcode}_json_transform"
  role_arn          = aws_iam_role.glue_assume_role.arn

  glue_version      = var.glue_version


  command {
    script_location = "s3://${aws_s3_object.glue_job_json_transform.bucket}/${aws_s3_object.glue_job_json_transform.id}"
  }

  default_arguments = {
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue_etl_log_group.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--job-language"                     = "python"
  }
}

