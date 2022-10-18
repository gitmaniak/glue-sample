# create S3 bucket for data files

locals {
  json_transform_script   = "${path.module}/../../altchd/src/glue/scripts/json_transform.py"
  simple_sample_input     = "${path.module}/../../samples/simple_sample_input.json"
}

resource "aws_s3_bucket" "glue_jobs" {
  bucket                  = "${var.app_shortcode}-glue-jobs-${local.account_id}"

  tags                    = local.common_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_files_config" {
  bucket                  = aws_s3_bucket.glue_jobs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm       = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "glue_jobs_bucket_policy" {
  statement {
    actions               = [ "s3:GetObject", "s3:PutObject", "s3:DeleteObject" ]
    resources             = [ "${aws_s3_bucket.glue_jobs.arn}/*" ]

    principals {
      type                = "AWS"
      identifiers         = [ local.account_id ]
    }
  }

  statement {
    actions               = [ "s3:ListBucket" ]
    resources             = [ aws_s3_bucket.glue_jobs.arn ]

    principals {
      type                = "AWS"
      identifiers         = [ local.account_id ]
    }
  }
}

resource "aws_s3_bucket_policy" "glue_jobs" {
  bucket                  = aws_s3_bucket.glue_jobs.id
  policy                  = data.aws_iam_policy_document.glue_jobs_bucket_policy.json 
}

# glue etl - json transform
resource "aws_s3_object" "glue_job_json_transform" {
  bucket                  = aws_s3_bucket.glue_jobs.id
  key                     = "glue/scripts/json_transform.py"
  source                  = local.json_transform_script
  source_hash             = filemd5(local.json_transform_script)
}

# glue etl - json transform - sample input json
resource "aws_s3_object" "glue_job_json_transform_sample_input" {
  bucket                  = aws_s3_bucket.glue_jobs.id
  key                     = "samples/input/simple_sample_input.json"
  source                  = local.simple_sample_input
  source_hash             = filemd5(local.simple_sample_input)
}
