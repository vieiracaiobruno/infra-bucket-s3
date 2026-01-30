# Example terraform.tfvars file
# Copy this to terraform.tfvars and customize with your values

# REQUIRED: S3 bucket name must be globally unique across all AWS accounts
# Consider using a pattern like: <org>-<project>-<env>-<random>
bucket_name = "infra-bucket-s3"

# AWS Region
aws_region = "us-east-1"

# Environment
environment = "prod"

# Enable versioning
enable_versioning = true

# Note: To enable prevent_destroy protection, uncomment the lifecycle block in main.tf
