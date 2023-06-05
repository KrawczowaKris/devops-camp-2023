/*
  ┌───────────────────────────────────────────────────────────────────────┐
  │ create efs                                                            │
  └───────────────────────────────────────────────────────────────────────┘
*/

module "wordpress_efs" {
  source          = "terraform-aws-modules/efs/aws"
  name            = local.labels.wordpress_efs
  throughput_mode = var.efs_throughput_mode
  mount_targets   = {
    "${data.aws_subnet.filtered_subnets[var.availability_zones[0]].availability_zone}" = {
      subnet_id = "${data.aws_subnet.filtered_subnets[var.availability_zones[0]].id}"
    }
    "${data.aws_subnet.filtered_subnets[var.availability_zones[1]].availability_zone}" = {
      subnet_id = "${data.aws_subnet.filtered_subnets[var.availability_zones[1]].id}"
    }
    "${data.aws_subnet.filtered_subnets[var.availability_zones[2]].availability_zone}" = {
      subnet_id = "${data.aws_subnet.filtered_subnets[var.availability_zones[2]].id}"
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
    transition_to_ia = var.efs_transition_to_ia
  }

  attach_policy = false

  tags = var.tags
}
