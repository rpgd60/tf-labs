profile = "tfadmin1"
region  = "eu-west-1"

project     = "acme02"
environment = "dev"


instance_type = "t2.micro"

sec_allowed_external = ["0.0.0.0/0"]
key_name             = "tf-course"

num_instances = 2