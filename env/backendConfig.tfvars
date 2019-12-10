encrypt = true

bucket = "wordpress-terraform-backends"

dynamodb_table = "terraform-state-lock"

key = "terraform-wordpress/terraform.tfstate"

region = "us-west-2"
