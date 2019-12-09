resource "aws_ecr_repository" "terraform_ecs" {
  name = "terraform-ecs"
}

resource "aws_ecs_cluster" "terraform_ecs_cluster" {
  name = "${var.project_name}-Cluster-${terraform.workspace}"
}

resource "aws_ecs_cluster" "terraform_ecs_app_cluster" {
  name = "${var.project_name}-Cluster-${terraform.workspace}"
  tags = var.tags
}

# /*
#   --- Module(s) ---
# */

# module "iam" {
#   source       = "./modules/iam"
#   tags         = var.tags
#   project_name = var.project_name
# }

/*
  --- Task(s) ---
*/
resource "aws_ecs_task_definition" "terraform_ecs_task" {
  family                   = "${var.project_name}-Task-${terraform.workspace}"
  container_definitions    = data.template_file.terraform_ecs_task_template.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
}

/*
  --- ECS Service(s) ---
*/
resource "aws_ecs_service" "terraform_ecs_service" {
  name            = "${var.project_name}-${terraform.workspace}"
  task_definition = aws_ecs_task_definition.terraform_ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.terraform_ecs_service_cluster.id
}
