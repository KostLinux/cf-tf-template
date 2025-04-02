# Contributing to Cloudflare Terraform Template

Thank you for your interest in contributing to this project! This guide outlines the standards and workflows we follow to maintain high-quality infrastructure code.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Conventional Commits](#conventional-commits)
- [Terraform Best Practices](#terraform-best-practices)
- [Folder Structure](#folder-structure)
- [Code Validation](#code-validation)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. We aim to foster an inclusive and welcoming community.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/cf-tf-template.git`
3. Add the upstream remote: `git remote add upstream https://github.com/ORIGINAL-OWNER/cf-tf-template.git`
4. Create a new branch for your changes: `git checkout -b feat/your-feature-name`

## Development Workflow

1. Make your changes locally
2. Run validation tools (see [Code Validation](#code-validation))
3. Commit your changes using conventional commit format
4. Push to your fork: `git push origin feat/your-feature-name`
5. Create a pull request

## Conventional Commits

All commit messages MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification. Pull requests with non-compliant commit messages will be closed.

Basic format:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Examples:
```
feat: add support for new Cloudflare API
fix: resolve issue with Terraform variable interpolation
docs: update README with new examples
```

## Terraform Best Practices

- Use modules to organize your code
- Write reusable and maintainable code
- Follow naming conventions for resources and variables
- Use `terraform fmt` to format your code
- Use `terraform validate` to check for syntax errors
- Use `terraform plan` to preview changes before applying

## Folder Structure

```
├── modules/
│   ├── example/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── another-example/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── examples/
│   ├── example-usage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── README.md
├── CONTRIBUTING.md
```

## Code Validation

Run the following commands to validate your code:

- `terraform fmt` - Formats your code
- `terraform validate` - Validates your code
- `terraform plan` - Previews changes

## Pull Request Process

1. Ensure your code follows the [Terraform Best Practices](#terraform-best-practices)
2. Ensure your commit messages follow the [Conventional Commits](#conventional-commits) specification
3. Open a pull request with a clear description of your changes
4. Address any feedback or requested changes
5. Once approved, your changes will be merged
