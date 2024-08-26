# Terraform AWS IAM Identity Center Module

## Getting Started

1. Enable IAM Identity Center on the desired AWS account.
2. Create at least one user via the aws-identity-center-users Terraform module.
3. Follow the instructions on the email to set a password and immediately register an MFA.
4. Select a user password from within *IAM Identity Center -> Users -> first_user and press *Reset password*.
5. Setup the aws-identity-center-group Terraform module.
6. Setup the aws-identity-center-permission-set Terraform module.
7. Finally don't forget to edit the AWS access portal URL.

## Multi-Account Setup

- If doing a multi-account setup with delegation you must specify the instance_arn and instance_store_id in the Terraform module aws-identity-center-permission-set.
- When selecting AWS accounts you can't specify the aws management account from within the delegated aws account, which makes sense as it's a root account.
