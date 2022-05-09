module "hello_world_app" {

  source = "../../../../modules/services/hello-world-app"

  server_text = var.server_text

  environment            = var.environment
  ## (RP) The hello-world-app  has no visibility of the data-stores/mysql
  ## (RP) but it needs to know the database parameters 
  ## (RP) We "link" them through the state files (in this case S3) 
  ## (RP) passing these variables will allow this module to obtain the db parameters fom the mysql state
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = true
  ami                = data.aws_ami.ubuntu.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
