module "elb_etcd" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb-etcd"

  subnets         = data.aws_subnet_ids.all.ids
  security_groups = [module.lb_sg.security_group_id]
  internal        = false

  listener = [
    {
      instance_port     = 2379
      instance_protocol = "TCP"
      lb_port           = 2379
      lb_protocol       = "TCP"
    },
  ]

  health_check = {
    target              = "HTTP:2379/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
