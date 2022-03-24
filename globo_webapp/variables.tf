variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "naming_prefix" {
  default = "globoweb"
}

//variable "subnet_cidr" {
//  default = [
//    "10.0.1.0/24",
//  "10.0.2.0/24"]
//}

variable "subnet_count" {
  default     = 2
  description = "Number of subnets"
}

variable "instance_count" {
  default     = 2
  description = "Number of instances"
}


variable "http_port" {
  type        = number
  description = "Port for the nginx web server"
  default     = 80
}

variable "webserver_instance_type" {
  default = "t2.micro"
}

variable "company" {
  default = "Globomantics"
}
variable "project" {
  type = string
}
variable "billing_code" {
  type = string
}