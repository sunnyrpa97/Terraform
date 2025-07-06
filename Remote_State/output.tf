output "S3_Bucket_name" {
  value = aws_s3_bucket.terraform_backend.id
}

output "KMS_Key_ARN" {
  value = aws_kms_key.s3_encryption_key.arn
}