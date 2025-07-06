locals {
  bucket_name = "123456789-do-not-delete-bucket-"
  region      = "ap-south-1"
  tags = {
    terraform_managed = "true"
    Department        = "Engineering"
    Team              = "Platfrom Engineering"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_backend" {
  bucket = format("%s-%s", local.bucket_name, data.aws_caller_identity.current.account_id)
  tags   = local.tags
}

resource "aws_kms_key" "s3_encryption_key" {
  description             = "This key is used to encrypt terrafrom backend S3 bucket objects"
  deletion_window_in_days = 7
  tags = merge(
    { "Name" = format("%s-kms-key", local.bucket_name) }, local.tags
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_backend" {
  bucket = aws_s3_bucket.terraform_backend.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_backend" {
  bucket = aws_s3_bucket.terraform_backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_backend" {
  bucket = aws_s3_bucket.terraform_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}