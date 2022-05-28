# Security group for web server in public subnet 

resource "aws_security_group" "sec_web" {
  # vpc_id = module.vpc.id
  vpc_id = data.aws_vpc.def_vpc.id
  # vpc_id = aws_vpc.vpc.id
  name   = "sec-web-${var.project}"
  ingress {
    description = "Ping from specific addresses"
    from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.sec_allowed_external
  }

  ingress {
    description = "TCP Port 80 from specific addresses"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }

  ingress {
    description = "TCP Port 443 from specific addresses"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name =  "sec-web-${var.project}"
  }
}

 
