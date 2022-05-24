## Locals


locals {
  account_id         = data.aws_caller_identity.current.account_id
  user_data_rendered = templatefile("${path.module}/user-data.tpl", { port = var.server_port })
}

## Instance profile

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

## Launch Template
resource "aws_launch_template" "app01" {
  name        = var.project
  description = "launch_temp_${var.project}"
  iam_instance_profile {
    arn = aws_iam_instance_profile.ssm_profile.arn
  }
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sec_web.id]
  key_name               = var.key_name
  user_data              = base64encode(local.user_data_rendered)
  #   ebs_optimized          = var.ebs_optimized
  #default_version = 1
  update_default_version = true
  #   block_device_mappings {
  #     device_name = data.aws_ami.amazon_linux_x86.root_device_name
  #     ebs {
  #       volume_size = var.ebs_size
  #     }
  #   }
  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-myasg"
    }
  }
}



resource "aws_autoscaling_group" "asg01" {
  vpc_zone_identifier = [module.vpc_asg.public_subnets[0], module.vpc_asg.public_subnets[1]]
  target_group_arns   = [aws_lb_target_group.front.arn]
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  name                = "${var.project}-asg"
  # default_cooldown = 120

  launch_template {
    id      = aws_launch_template.app01.id
    version = "$Latest" ## this will not support instance refresh
  }
  health_check_type = "EC2"
  ## Note no charge per AWS Docs : https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-instance-monitoring.html#as-enable-group-metrics
  metrics_granularity = "1Minute"

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  lifecycle {
    ignore_changes        = [desired_capacity, target_group_arns]
    create_before_destroy = true
  }

  tags = [{
    "trigger_tag" = "3"
  }]
}

###### Target Tracking Scaling Policies ######
## Average CPU utlization
resource "aws_autoscaling_policy" "track_cpu" {
  count                     = var.target_autoscaling_track_cpu ? 1 : 0
  name                      = "${var.project}-track-cpu"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.asg01.id
  estimated_instance_warmup = 180 # default: default ASG cooldown (300 seconds)
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.asg_target_tracking_cpu
  }
}

# Tracking Policy - ALB Requests
resource "aws_autoscaling_policy" "alb_requests" {
  count                     = var.target_autoscaling_track_lbreq ? 1 : 0
  name                      = "${var.project}-track-alb-requests"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.asg01.id
  estimated_instance_warmup = 180
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.front.arn_suffix}/${aws_lb_target_group.front.arn_suffix}"
    }
    target_value = var.asg_target_alb_requests
  }
}


## Cloudwatch sample alarm
# resource "aws_cloudwatch_metric_alarm" "foobar" {
#   alarm_name                = "terraform-test-foobar5"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "80"
#   alarm_description         = "Test metric alarm for ec2 cpu utilization"
#   insufficient_data_actions = []
# }


resource "aws_cloudwatch_metric_alarm" "foobar2" {
  alarm_name          = "asg-avg-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg01.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  # alarm_actions     = [aws_autoscaling_policy.bat.arn]
}