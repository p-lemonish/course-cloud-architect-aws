variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}
