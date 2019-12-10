terraform {
  required_version = ">= 0.12"
  backend "s3" {
    # (backend-specific settings...)
  }
}

provider "aws" {
  region = var.region
}

provider "archive" {}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    Owner       = var.owner
    ProjectName = var.project_name
  }

  s3_bucket_name           = "wordpress-${lower(terraform.workspace)}"
}

/*
  --- ECS ---
*/

module "ecs" {
  source       = "./modules/ecs"
  tags         = local.tags
  project_name = var.project_name
  region       = var.region
}
