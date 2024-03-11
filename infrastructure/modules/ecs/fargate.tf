
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_service" "main" {
  name = "${var.app_name}-service"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn

  launch_type   = "FARGATE"
  desired_count = var.ecs_settings.desired_count

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = ["${aws_security_group.ecs_tasks.id}"]
    assign_public_ip = var.ecs_settings.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = var.app_name
    container_port   = var.ecs_settings.container_port
  }
}

resource "aws_ecs_task_definition" "main" {
  family = var.app_name

  // Fargate is a type of ECS that requires awsvpc network_mode
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  // Valid sizes are shown here: https://aws.amazon.com/fargate/pricing/
  memory = var.ecs_settings.memory
  cpu    = var.ecs_settings.cpu

  // Fargate requires task definitions to have an execution role ARN to support ECR images
  execution_role_arn = var.ecs_role_arn
  task_role_arn      = var.ecs_role_arn

  container_definitions = jsonencode([
    {
      "name" : var.app_name,
      "image" : var.container_image_url,
      "memory" : var.ecs_settings.memory,
      "memoryReservation" : var.ecs_settings.memory,
      "essential" : true,
      logConfiguration = {
        logDriver     = "awslogs"
        secretOptions = null
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      },
      "portMappings" : [
        {
          "containerPort" : var.ecs_settings.container_port,
          "hostPort" : var.ecs_settings.container_port
        }
      ],
      environment = [for key, value in var.ecs_settings.env_vars : {
        name  = key
        value = value
      }]
    }
  ])
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.app_name}/ecs"
  retention_in_days = var.log_retention_in_days
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-sg-task"
  description = "Allow TLS inbound traffic on port 80 (http)"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.ecs_settings.container_port
    to_port     = var.ecs_settings.container_port
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
