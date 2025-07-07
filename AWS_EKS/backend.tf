terraform {
  backend "s3" {
    bucket       = ""

    # This defines the path and filename within the S3 bucket where the state file will be saved
    key          = "dev/project/terraform.tfstate"

    region       = "ap-south-1"
    
    # This attribute will be use to lock the state file.
    use_lockfile = true
  }
}