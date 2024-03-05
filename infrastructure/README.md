# AWS System architecture provided with Terragrunt

## Overview

![System Architecture](./docs/sys-architecture.png)

This README provides information on how to use Terragrunt to manage your infrastructure using the provided folder structure. Before proceeding, make sure you have the AWS CLI configured with appropriate credentials to access your AWS account.

## Folder Structure

The Terragrunt configurations are organized into the following directory structure:

```
infrastructure/
├── modules/
│   ├── app/
│   ├── dns/
│   ├── rds/
│   ├── e2e/
├── tenants/
│   ├── shs/
│     ├── tenant.hcl
│     ├── environments/
│        ├── adapter/
│        │   ├── adapter.hcl
│        │   ├── integration/
│        │   │   ├── terragrunt.hcl
│        │   ├── qualitative/
│        │   │   ├── terragrunt.hcl
│        │   ├── production/
│        │   │   ├── terragrunt.hcl
│        ├── integration/
│        │   ├── environment.hcl
│        │   ├── common/
│        │   │   ├── terragrunt.hcl
│        │   ├── e2e/
│        │   │   ├── terragrunt.hcl
│        │   ├── org_admin_app/
│        │   │   ├── terragrunt.hcl
│        │   ├── storybook/
│        │   │   ├── terragrunt.hcl
│        ├── qualitative/
│        │   │...
│        ├── production/
│        │   │...
│   ├── siemens/
│     ├── tenant.hcl
│     ├── environments/
│       ├── ..
```

- **modules/**: This directory contains reusable Terragrunt modules that define infrastructure components. These modules promote code reusability and maintainability by encapsulating specific functionality.

- **tenants/**: This directory holds configuration files for tenants and specific environment configurations. Each environment represents a single AWS account

- **adapter/**: This is a special case because the adapter account

## Prerequisites

Before using Terragrunt with this project, ensure that:

1. You have Terragrunt installed on your local machine. You can download it from the [Terragrunt GitHub repository](https://github.com/gruntwork-io/terragrunt) and follow the installation instructions.

2. You have AWS CLI installed on your local machine and configured with appropriate AWS credentials. You can configure AWS CLI by running `aws configure` and providing your AWS Access Key ID, Secret Access Key, region, and output format.

## Usage

1. **Apply Changes**: To apply changes using Terragrunt, navigate to the specific environment you want to work with. For example, if you're working with the `integration` environment, go to `infrastructure/tenants/**/environments/integration/`.

   ```bash
   cd infrastructure/tenants/siemens/environments/integration/org_admin_app
   ```

   Run the following command to apply the infrastructure changes for that environment:

   ```bash
   terragrunt apply
   ```

2. **Apply All**: To deploy the entire `integration` environment, you can use the following command in a parent folder:

   ```bash
   cd infrastructure/tenants/siemens/environments/integration
   terragrunt run-all apply
   ```

   **Be aware that the `run-all` command will instantly apply changes without asking for confirmation!**

## Creating Ephemeral Environments:

If you want to create an ephemeral environment based on an existing one, follow these steps:

- Copy the `org_admin_app` folder to a new folder with a unique name, e.g., `jfe-1234`.

  ```
  cd infrastructure/tenants/siemens/environments/integration
  mkdir jfe-123
  cp org_admin_app/terragrunt.hcl jfe-1234/terragrunt.hcl
  ```

- Set the environment variable `$FROM_ENV` to the name of the new folder:

  ```bash
  export FROM_ENV=jfe-1234
  ```

Terragrunt will automatically create all resources with the environment variable as a prefix.

- Ensure the frontend application environment is updated with the correct prefix (environment.review.ts)

- Ensure the e2e baseUrl is updated with correct prefix

## Terragrunt Modules

Terragrunt modules, located in the `modules/` directory, are designed to encapsulate specific infrastructure components or configurations. Modules promote code reuse and maintainability. You can use these modules in your environment configurations by referencing them with the `source` attribute in your `terragrunt.hcl` files.

For example, to use the `app` module in your environment configuration, you can add the following to your `terragrunt.hcl` file:

```hcl
remote_state {
  backend = "s3"
  config = {
    bucket         = "my-terraform-bucket"
    key            = "${path_relative_to_include()}/app/terraform.tfstate"
    region         = "eu-central-1"
  }
}
```

Each module may have its own specific variables and outputs, which should be documented within the module itself or its README.

## Conclusion

With this folder structure and Terragrunt setup, you can efficiently manage your AWS infrastructure using Terragrunt, promote code reusability with modules, and ensure your AWS CLI is properly configured to interact with AWS services.
