// Cloudwatch log group
resource "aws_cloudwatch_log_group" "wordpress_log_group" {
  name              = "ecs/${var.project_name}-${terraform.workspace}"
  retention_in_days = 14
  tags              = var.tags
}

resource "aws_ecr_repository" "wordpress_ecs" {
  name = "${lower(var.project_name)}-${lower(terraform.workspace)}"
  tags = var.tags
}

resource "aws_ecs_cluster" "wordpress_ecs_cluster" {
  name = "${var.project_name}-Cluster-${terraform.workspace}"
  tags = var.tags
}

data "template_file" "wordpress_service_task_template" {
  template = file("${path.module}/templates/task_template.json")

  vars = {
    repository_url = aws_ecr_repository.wordpress_ecs.repository_url
    container_name = "${var.project_name}-Task-${terraform.workspace}"
    log_group      = aws_cloudwatch_log_group.wordpress_log_group.name
    region         = var.region
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
