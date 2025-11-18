resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.bastion.public_key_openssh
  tags = merge(local.common_tags, {
    Name = var.ssh_key_name
  })
}

resource "local_file" "private_key" {
  content         = tls_private_key.bastion.private_key_pem
  filename        = "${path.module}/${var.ssh_key_name}.pem"
  file_permission = 0400
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.12-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "task6_custom_image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["task6-custom-vm-image-nginx"]
  }
  owners = [data.aws_caller_identity.current.account_id]
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.task6_custom_image.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_az1.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  key_name                    = aws_key_pair.bastion.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  tags = merge(local.common_tags, {
    Name = "chatroom-bastion"
  })
}

resource "aws_iam_instance_profile" "bastion" {
  name = "chatroom-bastion-instance-profile"
  role = aws_iam_role.bastion_secrets_role.name
}
