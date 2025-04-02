# Cloudflare Terraform Template

A robust infrastructure-as-code solution for managing Cloudflare resources using Terraform with integrated CI/CD capabilities.

## Features

- **DNS Management**: Built-in module for managing DNS records in Cloudflare
- **CI/CD Pipeline**: Automated GitHub Actions workflow for infrastructure deployment
- **Security Checks**: Integrated TFLint and TFSec for code quality and security validation
- **AWS S3 Backend**: Remote state management using an encrypted S3 bucket
- **Dependency Management**: Automated updates via Dependabot for Terraform providers and GitHub Actions

## Architecture

This template provides:

1. **Terraform Modules**:
   - `dns`: Manage Cloudflare DNS zones and records with proxying capabilities

2. **CI/CD Pipeline**:
   - Linting and security scanning
   - Plan and apply stages
   - Protected deployment to production

3. **Infrastructure Initialization**:
   - CloudFormation template for bootstrapping AWS resources
   - Scripts for backend initialization

## Prerequisites

- AWS account with appropriate permissions
- Cloudflare account with an API token
- GitHub account for CI/CD pipeline
- Terraform ~> 1.11.3

## Getting Started

### 1. Setup AWS Resources

Deploy the CloudFormation template to create the required AWS resources:

```bash
aws cloudformation deploy \
  --template-file cloudformation/terraform.yml \
  --stack-name cloudflare-terraform \
  --capabilities CAPABILITY_NAMED_IAM
```

After successfully deploying the CloudFormation stack, you need to create access keys for the Terraform IAM user:

1. Go to the AWS Management Console
2. Navigate to IAM > Users > [terraform-user-name]
3. Select the "Security credentials" tab
4. Click "Create access key"
5. Select "Other" as the use case
6. Add a description tag (optional)
7. Click "Create access key"
8. **IMPORTANT**: Save the Access Key ID and Secret Access Key securely - this is the only time you'll see the secret key
9. These credentials will be used for both local development and GitHub Actions

### 2. Local Development

#### 2.1 Install Required Tools

- [Terraform](https://www.terraform.io/downloads.html) (version ~> 1.11.3)
- [AWS CLI](https://aws.amazon.com/cli/)
- [TFLint](https://github.com/terraform-linters/tflint) (optional, for local linting)
- [TFSec](https://github.com/aquasecurity/tfsec) (optional, for local security scanning)

#### 2.2 Configure AWS CLI

```bash
aws configure
```

Enter your AWS access key, secret key, default region (e.g., us-east-1), and output format (json).

#### 2.3 Set Environment Variables

```bash
# For Cloudflare API token
export TF_VAR_cloudflare_api_token=your_cloudflare_api_token

# Optional: Configure S3 backend details
export TF_BACKEND_BUCKET=your-terraform-state-bucket
export TF_BACKEND_KEY=custom/path/terraform.tfstate
export TF_BACKEND_REGION=us-west-2
```

The init script will use these environment variables if set, or fall back to defaults.

#### 2.4 Initialize Terraform

Run the initialization script:

```bash
./init.sh
```

Or manually initialize with environment variables:

```bash
terraform init -reconfigure \
  -backend-config="bucket=${TF_BACKEND_BUCKET:-venturing-terraform-init-encrypted-bucket}" \
  -backend-config="key=${TF_BACKEND_KEY:-terraform.tfstate}" \
  -backend-config="region=${TF_BACKEND_REGION:-us-east-1}"
```

#### 2.5 Plan and Apply Changes

```bash
# Preview changes
terraform plan

# Apply changes
terraform apply
```

#### 2.6 Local Development Workflow

1. Make changes to Terraform files
2. Run `terraform fmt` to format your code
3. Run `terraform validate` to validate syntax
4. Run `terraform plan` to preview changes
5. Run `terraform apply` to apply changes

### 3. GitHub Actions Integration

#### 3.1 Create a New Repository from This Template

1. Click the "Use this template" button or manually push code to a new GitHub repository

#### 3.2 Configure Repository Secrets

Add the following secrets to your GitHub repository:

1. Navigate to your repository on GitHub
2. Go to Settings > Secrets and variables > Actions
3. Add the following repository secrets:
   - `AWS_ACCESS_KEY_ID`: IAM user access key
   - `AWS_SECRET_ACCESS_KEY`: IAM user secret key
   - `CLOUDFLARE_API_TOKEN`: Cloudflare API token with appropriate permissions

#### 3.3 Customize S3 Backend Configuration

The CI/CD pipeline uses environment variables for storing Terraform state. Update these in:

1. `.github/workflows/deploy.yml` - Look for the `env:` section at the top:

```yaml
env:
    TF_VAR_cloudflare_api_token: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    TF_BACKEND_BUCKET: your-terraform-state-bucket
    TF_BACKEND_KEY: terraform.tfstate
    TF_BACKEND_REGION: us-east-1
```

This approach keeps configuration centralized and makes it easy to modify backend settings.

#### 3.4 Using GitHub Environment Variables

You can also configure these values as GitHub Actions variables instead of editing the workflow file:

1. Navigate to your repository on GitHub
2. Go to Settings > Secrets and variables > Actions
3. Select the "Variables" tab
4. Add the following repository variables:
   - `TF_BACKEND_BUCKET`: Your S3 bucket name
   - `TF_BACKEND_KEY`: Path to state file
   - `TF_BACKEND_REGION`: AWS region

This allows you to change the configuration without committing changes to the workflow file.

#### 3.5 Workflow Behavior

- **Pull Requests**: The workflow runs linting, security scans, and plans (without applying)
- **Push to master**: The workflow runs all checks and automatically applies changes
- **Push to other branches**: The workflow runs all checks but doesn't apply changes

#### 3.6 Monitoring Workflow Runs

1. Navigate to the "Actions" tab in your GitHub repository
2. View workflow runs, their statuses, and logs
3. For failed runs, check the logs for error messages

#### 3.7 Triggering Workflows Manually

You can manually trigger the workflow:
1. Navigate to the "Actions" tab
2. Select the "Terraform CI/CD" workflow
3. Click "Run workflow"
4. Optionally specify different environment variables for this run

### 4. Configure DNS Records

Edit `main.tf` to configure your DNS records:

```hcl
module "cloudflare_dns" {
  source = "./modules/dns"

  cloudflare_api_token = var.cloudflare_api_token
  dns_zone_name        = "your-domain.com"
  dns_records_list = {
    "example" = [
      {
        name    = "www.your-domain.com"
        value   = "your-target.example.com"
        type    = "CNAME"
        proxied = true
      }
    ]
  }
}
```

## DNS Record Configuration

The DNS module supports the following record types:
- A
- AAAA
- CNAME
- TXT
- MX (requires a priority value)
- and other Cloudflare-supported record types

Example configuration with multiple record types:

```hcl
dns_records_list = {
  "web" = [
    {
      name    = "www"
      value   = "203.0.113.10"
      type    = "A"
      proxied = true
    }
  ],
  "mail" = [
    {
      name     = "your-domain.com"
      value    = "mail-server.example.com"
      type     = "MX"
      proxied  = false
      priority = 10
    }
  ]
}
```

## CI/CD Workflow

The GitHub Actions workflow (`deploy.yml`) performs:

1. **Validation**:
   - TFLint for Terraform best practices
   - TFSec for security scanning

2. **Planning**: 
   - Runs on all branches and PRs

3. **Application**:
   - Applies changes only on merge to master

## Maintenance

### Dependabot Integration

The repository includes Dependabot configuration to:
- Update Terraform providers weekly
- Update GitHub Actions dependencies weekly

### Manual Updates

Update Terraform version in:
- `.github/workflows/deploy.yml`
- `provider.tf`
- `modules/dns/provider.tf`

## Contributing

Please see our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests. All contributors are expected to:

- Follow Terraform best practices
- Use conventional commit format for all commits
- Pass all code validation checks (TFLint, TFSec, Terraform fmt)
- Adhere to the established folder structure

## Troubleshooting

### Common Issues

1. **Access Denied to S3 Bucket**:
   - Verify IAM user permissions
   - Check AWS credentials in GitHub secrets
   - Ensure the S3 bucket name in `TF_BACKEND_BUCKET` exists and is accessible

2. **Cloudflare API Errors**:
   - Ensure API token has appropriate zone permissions
   - Verify zone name is correct

3. **State Lock Issues**:
   - If a previous run failed, you may need to release the state lock:
   ```bash
   terraform force-unlock LOCK_ID
   ```

4. **GitHub Actions Workflow Issues**:
   - Check secret names match exactly with what's used in the workflow file
   - Ensure GitHub repository has the proper permissions to access secrets
   - Verify that environment variables are correctly defined

5. **Local vs. CI/CD Inconsistencies**:
   - Ensure you're using the same Terraform version locally as in CI/CD
   - Make sure your AWS CLI is properly configured with the same credentials
   - Use the same backend configuration variables in both environments

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
