module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name = "etcd cluster"
  depends_on = [ module.ssh_sg.security_group_id,module.elb_etcd.this_elb_id ]
  # Launch configuration
  lc_name = "etcd"

  image_id        = var.ami
  instance_type   = "t2.micro"
  security_groups =  [module.ssh_sg.security_group_id]
  key_name        = var.key_pair

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "etcd-asg"
  vpc_zone_identifier       =  data.aws_subnet_ids.all.ids
  health_check_type         = "EC2"
  min_size                  = 3
  max_size                  = 3
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  load_balancers             = [module.elb_etcd.this_elb_id]

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "etcd"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    cluster = "01"
  }
}
