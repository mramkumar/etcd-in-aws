variable "aws-region" {
  default = "us-east-1"
}

variable "key_pair" {
  default = "bastion"
}

variable "ami" {
  default = "ami-0747bdcabd34c712a"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
