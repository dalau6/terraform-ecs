variable "project_name" {
  type        = string
  description = "The name of the project that Terraform is deploying to AWS"
}

variable "owner" {
  type        = string
  description = "The name of the owner of the AWS resources"
}

variable "region" {
  type        = string
  description = "The AWS region where assets will be deployed"
}
