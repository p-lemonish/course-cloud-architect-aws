resource "aws_secretsmanager_secret" "demo" {
  name = "chatroom-demo-secret-1"

  tags = merge(local.common_tags, {
    Name = "chatroom-demo-secret"
  })
}

resource "aws_secretsmanager_secret_version" "demo_value" {
  secret_id = aws_secretsmanager_secret.demo.id
  secret_string = jsonencode({
    username = "admin"
    password = "meg4CorpoAdminNeverLeaked!1!"
  })
}

resource "aws_iam_role" "bastion_secrets_role" {
  name = "chatroom-bastion-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "chatroom-bastion-secrets-role"
  })
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy" "bastion_read_secret" {
  name = "chatroom-bastion-read-secret"
  role = aws_iam_role.bastion_secrets_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadDemoSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:chatroom-*"
      }
    ]
  })
}
