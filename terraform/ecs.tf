
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster-stepfunction-example"
}

# resource "aws_ecs_task_definition" "fastapi-example-task" {
#   family                   = "fastapi-example-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"

#   container_definitions = jsonencode([
#     {
#       name      = "fastapi-example"
#       image     = "hebertrfreitas/fastapi-example:latest"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#       healthCheck = {
#         command     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
#         interval    = 30
#         timeout     = 5
#         retries     = 3
#         startPeriod = 0
#       }

#     }
#   ])
# }

# resource "aws_ecs_service" "fastapi-example-service" {
#   name            = "fastapi-example-service"
#   cluster         = aws_ecs_cluster.ecs-cluster.id
#   task_definition = aws_ecs_task_definition.fastapi-example-task.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = var.subnet_ids
#     security_groups = var.security_group_ids
#   }
# }


###### simple-python-worker


resource "aws_ecs_task_definition" "simple-python-worker-task" {
  family                   = "simple-python-worker-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "simple-python-worker"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/stepfunction-example/simple-python-worker:latest"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/simple-python-worker"
          "mode"                  = "non-blocking"
          "awslogs-create-group"  = "true",
          "max-buffer-size"       = "25m"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      #   portMappings = [
      #     {
      #       containerPort = 80
      #       hostPort      = 80
      #     }
      #   ]
      healthCheck = {
        command     = ["CMD-SHELL", "ps -axu | grep 'main.py' | grep -v grep || exit 1"] #need refactor to a real healthcheck
        interval    = 20
        timeout     = 5
        retries     = 3
        startPeriod = 0
      }
      environment = [
        {
          name  = "QUEUE_NAME"
          value = aws_sqs_queue.input_queue.name
        },
        {
          name  = "AWS_DEFAULT_REGION"
          value = "us-east-1"
        },
        {
          name  = "ENABLE_WAIT_FOR_CALLBACK"
          value = "true"
        },
      ]

    }
  ])
}

resource "aws_ecs_service" "simple-python-worker-ecs-service" {
  name            = "simple-python-worker-ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.simple-python-worker-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
}