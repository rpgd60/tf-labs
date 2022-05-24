profile = "tfadmin1"
region  = "eu-west-1"

project     = "acme02"
environment = "dev"

## App and instance info
instance_type = "t2.micro"
key_name      = "tf-course"

sec_allowed_external = ["0.0.0.0/0"]
access_logs          = false

server_port = 8080

## Autoscaling group main parameters
asg_desired_capacity = "1"
asg_min_size         = "1"
asg_max_size         = "6"

## Autoscaling policies
asg_target_alb_requests        = 400
asg_target_tracking_cpu        = 70
target_autoscaling_track_cpu   = true
target_autoscaling_track_lbreq = true

## SSM stuff
use_ssm = false
