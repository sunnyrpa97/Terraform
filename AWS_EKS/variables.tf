variable "region" {
  description = "The AWS region where resources will be created."
  type        = string
  validation {
    condition = contains([
      "us-east-1", "us-east-2", "us-west-1", "us-west-2",
      "ca-central-1", "ca-west-1",
      "eu-central-1", "eu-central-2", "eu-west-1", "eu-west-2", "eu-west-3",
      "eu-north-1", "eu-south-1", "eu-south-2",
      "ap-east-1", "ap-south-1", "ap-south-2", "ap-southeast-1", "ap-southeast-2",
      "ap-southeast-3", "ap-southeast-4", "ap-northeast-1", "ap-northeast-2", "ap-northeast-3",
      "sa-east-1",
      "af-south-1",
      "me-central-1", "me-south-1",
      "il-central-1",
      "ap-southeast-5", "ap-southeast-6"
    ], var.region)
    error_message = "Invalid AWS region. Please specify a valid AWS region."
  }
}

variable "vpc_name" {
  description = "The name to assign to the VPC."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.vpc_name))
    error_message = "VPC name can only contain letters, numbers, hyphens, and underscores."
  }

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_azs" {
  description = "List of availability zones where the subnets will be created."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "intra_subnets" {
  description = "List of CIDR blocks for intra (internal-only) subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Boolean flag to enable or disable the creation of NAT gateways."
  type        = bool
}

variable "single_nat_gateway" {
  description = "If true, creates a single shared NAT gateway instead of one per AZ."
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "If true, creates one NAT gateway in each availability zone."
  type        = bool
}

variable "enable_vpn_gateway" {
  description = "Boolean flag to enable or disable the creation of a VPN gateway."
  type        = bool
}

variable "enable_flow_log" {
  description = "Boolean flag to enable or disable VPC flow logs."
  type        = bool
}

variable "tags" {
  description = "A map of tags to apply to all resources that support tagging."
  type        = map(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.cluster_name))
    error_message = "EKS cluster name can only contain letters, numbers, and hyphens."
  }
  validation {
    condition     = can(regex("^[a-zA-Z]", var.cluster_name))
    error_message = "EKS cluster name must start with a letter."
  }

  validation {
    condition     = !can(regex("-$", var.cluster_name))
    error_message = "EKS cluster name cannot end with a hyphen."
  }
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  validation {
    condition     = can(regex("^1\\.[0-9]{2}$", var.cluster_version))
    error_message = "EKS cluster version must be in format 1.XX (e.g., 1.32, 1.33)."
  }
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS cluster control plane endpoint is publicly accessible."
  type        = bool
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Whether to grant full administrative permissions to the cluster creator."
  type        = bool
}

variable "managed_node_group_name" {
  description = "Name of the managed node group within the EKS cluster."
  type        = string
}

variable "ami_type" {
  description = "AMI type to use for the managed node group (e.g., 'AL2_x86_64', 'BOTTLEROCKET_x86_64')."
  type        = string
  validation {
    condition = contains([
      "AL2_x86_64",
      "AL2_x86_64_GPU",
      "AL2_ARM_64",
      "CUSTOM",
      "BOTTLEROCKET_ARM_64",
      "BOTTLEROCKET_x86_64",
      "BOTTLEROCKET_ARM_64_FIPS",
      "BOTTLEROCKET_x86_64_FIPS",
      "BOTTLEROCKET_ARM_64_NVIDIA",
      "BOTTLEROCKET_x86_64_NVIDIA",
      "WINDOWS_CORE_2019_x86_64",
      "WINDOWS_FULL_2019_x86_64",
      "WINDOWS_CORE_2022_x86_64",
      "WINDOWS_FULL_2022_x86_64",
      "AL2023_x86_64_STANDARD",
      "AL2023_ARM_64_STANDARD",
      "AL2023_x86_64_NEURON",
      "AL2023_x86_64_NVIDIA",
      "AL2023_ARM_64_NVIDIA"
    ], var.ami_type)
    error_message = "Invalid AMI type. Must be one of the supported EKS AMI types."
  }
  # See: https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
}

variable "instance_types" {
  description = "List of EC2 instance types to use for the managed node group."
  type        = list(string)
}

variable "managed_ng_min_size" {
  description = "Minimum number of nodes in the managed node group."
  type        = number
}

variable "managed_ng_max_size" {
  description = "Maximum number of nodes in the managed node group."
  type        = number
}

variable "managed_ng_desired_size" {
  description = "Desired number of nodes in the managed node group."
  type        = number
}

variable "create_managed_node_group" {
  description = "Whether to create a managed node group as part of the EKS cluster."
  type        = bool
}