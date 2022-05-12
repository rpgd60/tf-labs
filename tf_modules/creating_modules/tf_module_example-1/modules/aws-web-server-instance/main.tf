
resource "aws_instance" "web_server_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.web_server_sc]

  tags = {
    Name = var.ec2_instance_name
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Web Server Created with a Terraform Module</div></body></html>" > /var/www/html/index.html
    EOF
}

