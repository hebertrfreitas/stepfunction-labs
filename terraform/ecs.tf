
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster-stepfunction-example"
}

resource "aws_ecs_task_definition" "fastapi-example-task" {
  family                   = "fastapi-example-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "fastapi-example"
      image     = "hebertrfreitas/fastapi-example:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 0
      }
      
    }
  ])
}

resource "aws_ecs_service" "fastapi-example-service" {
  name            = "fastapi-example-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.fastapi-example-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
  }
}