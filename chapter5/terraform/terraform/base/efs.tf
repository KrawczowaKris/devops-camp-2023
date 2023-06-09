/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create efs                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_efs" {
  source          = "terraform-aws-modules/efs/aws"
  version         = "1.1.1"
  name            = local.labels.wordpress_efs
  throughput_mode = var.wordpress_efs_throughput_mode
  mount_targets = {
    for subnet in data.aws_subnet.subnets :
    subnet.availability_zone => {
      subnet_id = subnet.id
    }
  }
  security_group_name        = local.labels.wordpress_efs_sg
  security_group_description = "Security group for EFS"
  security_group_rules = {
    vpc = {
      description              = "Open nfs with ec2 instance"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    }
  }

  lifecycle_policy = {
    transition_to_ia = var.wordpress_efs_transition_to_ia
  }

  attach_policy = false
}
