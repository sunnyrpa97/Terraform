locals {
  vpc_flow_logs_bucket = "vpc-flow-logs-s3-${random_pet.this.id}"

}

module "vpc" {
  source                    = "terraform-aws-modules/vpc/aws"
  version                   = "5.21.0"
  name                      = var.vpc_name
  cidr                      = var.vpc_cidr
  azs                       = var.vpc_azs
  private_subnets           = var.private_subnets
  public_subnets            = var.public_subnets
  intra_subnets             = var.intra_subnets
  enable_nat_gateway        = var.enable_nat_gateway
  single_nat_gateway        = var.single_nat_gateway
  one_nat_gateway_per_az    = var.one_nat_gateway_per_az
  enable_vpn_gateway        = var.enable_vpn_gateway
  enable_flow_log           = var.enable_flow_log
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = module.s3_bucket.s3_bucket_arn
  tags                      = var.tags
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# S3 Bucket

resource "random_pet" "this" {
  length = 4
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "~> 3.0"
  bucket        = local.vpc_flow_logs_bucket
  policy        = data.aws_iam_policy_document.flow_log_s3.json
  force_destroy = true
  tags          = var.tags
}

data "aws_iam_policy_document" "flow_log_s3" {
  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.vpc_flow_logs_bucket}/AWSLogs/*"]
  }
  statement {
    sid = "AWSLogDeliveryAclCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.vpc_flow_logs_bucket}"]
  }
}

resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "eks-vpc-endpoint-sg"
  vpc_id      = module.vpc.vpc_id

  ingress = []

  # Allow HTTPS from all private subnets

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EKS Endpoint
resource "aws_vpc_endpoint" "eks" {
  service_name       = "com.amazonaws.${var.region}.eks"
  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.vpc_endpoints.id]

}

# ECR Endpoint
# ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  service_name       = "com.amazonaws.${var.region}.ecr.api"
  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.vpc_endpoints.id]
}

# ECR Docker Registry
resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name       = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.vpc_endpoints.id]
}


# S3 endpoint
resource "aws_vpc_endpoint" "s3" {
  service_name    = "com.amazonaws.${var.region}.s3"
  vpc_id          = module.vpc.vpc_id
  route_table_ids = module.vpc.private_route_table_ids
}

resource "aws_vpc_endpoint" "ec2" {
  service_name       = "com.amazonaws.${var.region}.ec2"
  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.vpc_endpoints.id]

}

resource "aws_vpc_endpoint" "secretsmanager" {
  service_name       = "com.amazonaws.${var.region}.secretsmanager"
  vpc_id             = module.vpc.vpc_id
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.vpc_endpoints.id]

}


# Elastic Load Balancing v2 (ALB/NLB)
resource "aws_vpc_endpoint" "elbv2" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpc_endpoints.id]

}


resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.vpc_endpoints.id]

}