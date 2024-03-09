resource "aws_iam_role" "ecs_role" {
  name = "${var.app_name}_ecs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role = aws_iam_role.ecs_role.name

  // This policy adds logging + ecr permissions
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "dynamodb_access_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = var.dynamodb_access_policy_arn
}
