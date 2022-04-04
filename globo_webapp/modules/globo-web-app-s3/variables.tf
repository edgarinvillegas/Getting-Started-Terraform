# Bucket name
variable "bucket_name" {
  type = string
  description = "Name of the S3 bucket to create"
}

# ELB service account
variable "elb_service_account_arn" {
  type = string
  description = "ARN of ELB service account"
}

# Common tags
variable "common_tags" {
  type = map(string)
  description = "Map of tags to be applied to all resources"
  default = {}
}

variable "name_prefix" {
  type = string
  description = "Prefix to apply to all resource names"
}