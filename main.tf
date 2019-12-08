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

/*
  --- ECS ---
*/

module "ecs" {
  source       = "./modules/ecs"
  project_name = var.project_name
  region       = var.region
}
