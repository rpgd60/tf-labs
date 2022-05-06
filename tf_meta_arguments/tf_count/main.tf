## Locals

locals {
  server_list = [for i in range(0, var.num_instances) : format("svr-%s", i)]
  num_azs = length(data.aws_availability_zones.azs.names)
}


resource "aws_instance" "test1" {
  count                  = length(local.server_list)
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.def_vpc_subnets.ids[count.index % local.num_azs]
  vpc_security_group_ids = [aws_security_group.sec_web.id]
  key_name               = var.key_name
  tags = {
    Name = "${var.project}-${local.server_list[count.index]}"
  }
}


# Security group for web server in public subnet 

resource "aws_security_group" "sec_web" {
  vpc_id = data.aws_vpc.def_vpc.id
  name   = "sec-web"
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
    cidr_blocks = var.sec_allowed_external
    # security_groups = [aws_security_group.sec_alb.id]
  }

  ingress {
    description = "TCP Port 5000 from specific addresses"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
    # security_groups = [aws_security_group.sec_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sec-web"
  }
}



