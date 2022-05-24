## VPC 

# ## Temporary use of default vpc
# ## Reference to default_vpc
# ## To use it (e.g. inside a security group definition) : vpc_id = data.aws_vpc.def_vpc.id
# data "aws_vpc" "def_vpc" {
#   default = true
# }

# data "aws_subnets" "def_vpc_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.def_vpc.id]
#   }
# }

module "vpc_asg" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${var.environment}-vpc-asg"
  cidr = "10.34.0.0/16"

  enable_nat_gateway = false
  single_nat_gateway = true

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.34.1.0/24", "10.34.2.0/24"]
  private_subnets = ["10.34.11.0/24", "10.34.12.0/24"]

  enable_ipv6                                    = false
  private_subnet_assign_ipv6_address_on_creation = false
  public_subnet_assign_ipv6_address_on_creation  = false
  public_subnet_ipv6_prefixes                    = [0, 1]
  private_subnet_ipv6_prefixes                   = [2, 3]
  enable_flow_log                                = false
  create_flow_log_cloudwatch_iam_role            = false
  create_flow_log_cloudwatch_log_group           = false
}



## instance target group
resource "aws_lb_target_group" "front" {
  name        = "${var.project}-lb-tg"
  target_type = "instance"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = module.vpc_asg.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 10 ## Faster for test
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Used to test load-balancer with a single test EC2 Instance 
## Test instance based on launch template
# resource "aws_instance" "test1" {
#   launch_template {
#     id = aws_launch_template.app01.id
#     version = "$Latest"

#   }
#   subnet_id = module.vpc_asg.public_subnets[0]
#   vpc_security_group_ids = [aws_security_group.sec_ext.id]
#   tags  = {
#       Name = "test-lb"
#   }
# }
# Associate test instance with target group
# resource aws_lb_target_group_attachment "front_test" {
#   target_group_arn = aws_lb_target_group.front.arn
#   target_id = aws_instance.test_pub.id
#   port = 80
# }

# data "aws_s3_bucket" "log_bucket" {
#   bucket = var.alb_logs_bucket
# }

resource "aws_lb" "front" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sec_alb.id]
  subnets            = module.vpc_asg.public_subnets

  enable_deletion_protection = false

  # dynamic "access_logs" {
  #   for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

  #   content {
  #     enabled = try(access_logs.value.enabled, try(access_logs.value.bucket, null) != null)
  #     bucket  = try(access_logs.value.bucket, null)
  #     prefix  = try(access_logs.value.prefix, null)
  #   }
  # }

  #   tags = {
  #     environment = 
  #   }
}

resource "aws_lb_listener" "front" {
  load_balancer_arn = aws_lb.front.arn
  port              = var.server_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Load Balancer Security groups: allow HTTPS and HTTP allow ICMP ping from allowed external subnets
resource "aws_security_group" "sec_alb" {
  vpc_id = module.vpc_asg.vpc_id
  name   = "${var.project}-front"
  ingress {
    description = "Ping from specific addresses"
    from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.sec_allowed_external
  }
  # ingress {
  #   description = "SSH from specific addresses"
  #   from_port   = "22"
  #   to_port     = "22"
  #   protocol    = "tcp"
  #   cidr_blocks = var.sec_allowed_external
  # }  
  ingress {
    description = "HTTP from specific addresses"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }
  # ingress {
  #   description = "HTTPS from specific addresses"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = var.sec_allowed_external
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-front"
  }
  lifecycle {
    create_before_destroy = true
  }

}

# Web server Security group 
# Security groups: allow HTTP and HTTPS from Load Balancer Security Group
resource "aws_security_group" "sec_web" {
  vpc_id = module.vpc_asg.vpc_id
  name   = "${var.project}-web"
  ingress {
    description = "Temp for testing - SSH from specific addresses"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }
  ingress {
    description = "Ping from specific addresses"
    from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port     = 0
    protocol    = "icmp"
    # cidr_blocks = var.sec_allowed_external
    security_groups = [aws_security_group.sec_alb.id]
  }

  ingress {
    description = "HTTP from specific addresses"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    # cidr_blocks = var.sec_allowed_external
    security_groups = [aws_security_group.sec_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project}-web"
  }
}


