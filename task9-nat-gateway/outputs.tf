output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_az1.id, aws_subnet.private_az2.id]
}

output "availability_zones" {
  value = var.availability_zones
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "public_security_group_id" {
  value = aws_security_group.public.id
}

output "private_security_group_id" {
  value = aws_security_group.private.id
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "ssh_key_name" {
  value = aws_key_pair.bastion.key_name
}

output "ssh_private_key_path" {
  value = "${path.module}/${var.ssh_key_name}.pem"
}

output "ssh_command" {
  value = "ssh -i ${var.ssh_key_name}.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}

output "ami_name" {
  value = data.aws_ami.amazon_linux.name
}

output "public_bucket_id" {
  value = aws_s3_bucket.public_storage.id
}

output "protected_bucket_id" {
  value = aws_s3_bucket.protected_storage.id
}

output "private_instance_id" {
  value = aws_instance.private_app.id
}

output "private_instance_private_ip" {
  value = aws_instance.private_app.private_ip
}

output "ssh_to_private_from_bastion" {
  value = "ssh -i ${var.ssh_key_name}.pem ec2-user@${aws_instance.private_app.private_ip}"
}
