variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "pixel_instance_type" {
  description = "EC2 instance type for pixel servers (see sizing docs)"
  type        = string
  default     = "c7g.4xlarge"
}

variable "flink_instance_type" {
  description = "EC2 instance type for Flink/EMR nodes"
  type        = string
  default     = "c7g.4xlarge"
}

variable "aerospike_instance_type" {
  description = "EC2 instance type for Aerospike nodes"
  type        = string
  default     = "i4i.8xlarge"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (update with your AMI)"
  type        = string
  default     = "ami-xxxxxxxxxxxxxxxxx" # TODO: Replace with valid AMI
} 