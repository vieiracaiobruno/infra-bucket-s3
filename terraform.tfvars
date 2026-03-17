# Example terraform.tfvars file
# Copy this to terraform.tfvars and customize with your values

# Prefixo do bucket S3 — a AWS adiciona um sufixo único automaticamente
bucket_name = "acoes-bolsa"

# AWS Region
aws_region = "us-east-1"

# Environment
environment = "prod"

# Enable versioning
enable_versioning = true

# Note: To enable prevent_destroy protection, uncomment the lifecycle block in main.tf
