variable aws_access_key {
  type = string
  description = "AWS access key"
  sensitive = true
}

variable aws_secret_key {
  type = string
  description = "AWS secret key"
  sensitive = true
}

variable aws_region {
  type = string
  default = "us-west-1"
}

variable vpc_cidr { default = "10.0.0.0/16" }

variable subnet_cidr { default = "10.0.0.0/24" }

variable http_port {
  type = number
  description = "Port for the nginx web server"
  default = 80
}

variable webserver_instance_type { default = "t2.micro" }

variable company { default = "Globomantics" }
variable project { type = string }
variable billing_code { type = string }