/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create efs                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_efs" {
  source          = "terraform-aws-modules/efs/aws"
  name            = local.labels.wordpress_efs
  throughput_mode = var.wordpress_efs_throughput_mode
  mount_targets = {
    "${data.aws_subnet.subnet_az.availability_zone}" = {
      subnet_id = data.aws_subnet.subnet_az.id
    }
    "${data.aws_subnet.subnet_bz.availability_zone}" = {
      subnet_id = data.aws_subnet.subnet_bz.id
    }
    "${data.aws_subnet.subnet_cz.availability_zone}" = {
      subnet_id = data.aws_subnet.subnet_cz.id
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

  tags = var.tags
}
