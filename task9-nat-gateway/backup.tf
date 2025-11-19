resource "aws_backup_vault" "bastion_vault" {
  name = "bastion-backup-vault"
  tags = merge(local.common_tags, {
    Name = "bastion-backup-vault"
  })
}

resource "aws_iam_role" "backup_service_role" {
  name = "bastion-backup-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(local.common_tags, {
    Name = "bastion-backup-service-role"
  })
}

resource "aws_iam_role_policy_attachment" "backup_service_role_attach" {
  role       = aws_iam_role.backup_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_plan" "bastion_daily" {
  name = "bastion-daily-backup-plan"
  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.bastion_vault.name
    schedule          = "cron(0 1 * * ? *)"
    lifecycle {
      delete_after = 7
    }
  }
  tags = merge(local.common_tags, {
    Name = "bastion-daily-backup-plan"
  })
}

resource "aws_backup_selection" "bastion_selection" {
  name         = "task-bastion-backup-selection"
  iam_role_arn = aws_iam_role.backup_service_role.arn
  plan_id      = aws_backup_plan.bastion_daily.id

  resources = [
    aws_instance.bastion.arn
  ]
}

