module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name        = "etcd-ssh"
  description = "etcd-ssh"
  vpc_id      =  data.aws_vpc.default.id

  ingress_with_self = [
    {
      rule = "all-all"
    },
    {
      from_port   = 2379
      to_port     = 2379
      protocol    = 6
      description = "Service name"
      self        = true
    },
    {
      from_port = 2380
      to_port   = 2380
      protocol  = 6
      self      = true
    },
  ]


  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  computed_ingress_with_source_security_group_id = [
   {
     from_port   = 2379
     to_port     = 2379
     protocol    = "tcp"
     description = "etcd ports"
     source_security_group_id = module.lb_sg.security_group_id
   }
 ]
  number_of_computed_ingress_with_source_security_group_id = 1
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "User-service ports (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    },
  ]


}


module "lb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  name        = "etcd-lb"
  description = "etcd-lb"
  vpc_id      =  data.aws_vpc.default.id
  ingress_with_cidr_blocks = [
    {
      from_port   = 2379
      to_port     = 2379
      protocol    = "tcp"
      description = "etcd ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "User-service ports (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
