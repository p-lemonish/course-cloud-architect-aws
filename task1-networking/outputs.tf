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
