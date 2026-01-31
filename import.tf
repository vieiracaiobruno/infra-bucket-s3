# Import blocks for existing S3 bucket resources
# These will be used if the resources already exist in AWS
# Terraform will skip import if resources are already in state

import {
  to = aws_s3_bucket.main
  id = var.bucket_name
}

import {
  to = aws_s3_bucket_versioning.main
  id = var.bucket_name
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.main
  id = var.bucket_name
}

import {
  to = aws_s3_bucket_public_access_block.main
  id = var.bucket_name
}
