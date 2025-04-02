#!/bin/bash

# Exit if any command fails
set -e

# Allow customizing the backend configuration through environment variables
TF_BACKEND_BUCKET=${TF_BACKEND_BUCKET:-venturing-terraform-init-encrypted-bucket}
TF_BACKEND_KEY=${TF_BACKEND_KEY:-terraform.tfstate}
TF_BACKEND_REGION=${TF_BACKEND_REGION:-us-east-1}

# Initialize the backend
terraform init -reconfigure \
    -backend-config="bucket=${TF_BACKEND_BUCKET}" \
    -backend-config="key=${TF_BACKEND_KEY}" \
    -backend-config="region=${TF_BACKEND_REGION}"

# Terraform Validate
terraform validate

# Terraform format
terraform fmt -recursive

echo "Remote backend provisioned and initialized successfully!"