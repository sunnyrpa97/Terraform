# Terraform Backend S3 Bucket with KMS Encryption

This Terraform configuration creates an **S3 bucket** with **KMS encryption** to be used as a **remote backend for Terraform state**. It is pre-configured for best practices such as versioning and public access blocking.

## 📦 What This Module Does

- Creates a highly secure **AWS S3 bucket** configured with:
  - **Server-side encryption** utilizing a custom-managed **AWS KMS key.**
  - **Bucket versioning** enabled to preserve historical versions of your Terraform state.
  - **Full public access blocking** to prevent unintended exposure of your state files.
- Outputs:
  - The Amazon Resource Name (ARN) of the created KMS key.
  - The name of the provisioned S3 bucket.

## 🚀 Usage Instructions

To integrate and deploy this Terraform backend module, follow these steps:

1. Clone this repository or incorporate the module into your existing Terraform project structure.
2. Initialize your Terraform working directory:

   ```
   terraform init
   ```

3. Apply the configuration to create the AWS resources:

   ```
   terraform apply
   ```

## 🔧 Customization

You can customize the properties of the Terraform backend resources by modifying the `locals` block within the `main.tf` file.
### 🔄 Parameters to Customize

- **`region`**: Specifies the AWS region where the S3 bucket and KMS key will be deployed (e.g., `us-east-1`, `eu-west-2`).
- **`bucket_name`**: Defines a globally unique name for your S3 bucket.
- **`tags`**: Allows you to apply key-value pairs for tagging your AWS resources. These tags are useful for cost tracking, organizational purposes, and policy enforcement.

### 📝 Example Configuration

Edit the `locals` block in `main.tf` as shown below:

```
locals {
  region      = "us-west-2"
  bucket_name = "my-custom-terraform-backend"
  tags = {
    terraform_managed = "true"
    Department        = "Engineering"
    Team              = "DevOps"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.s3_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.terraform_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.terraform_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.terraform_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.terraform_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_KMS_Key_ARN"></a> [KMS\_Key\_ARN](#output\_KMS\_Key\_ARN) | The ARN of the AWS KMS key used for S3 bucket encryption. |
| <a name="output_S3_Bucket_name"></a> [S3\_Bucket\_name](#output\_S3\_Bucket\_name) | The name of the S3 bucket created for Terraform state. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->