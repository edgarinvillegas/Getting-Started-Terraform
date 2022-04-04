
##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_availability_zones" "disponibles" {
  state = "available"
}
##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "=3.10.0"

  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.disponibles.names, 0, (var.subnet_count))
  public_subnets  = [ for subnet in range(var.subnet_count) : cidrsubnet(var.vpc_cidr, 8, subnet) ]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {

  name   = "${local.name_prefix}-nginx_sg"
  # vpc_id = aws_vpc.vpc.id
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags

  # HTTP access from anywhere
  ingress {
    from_port = var.http_port
    to_port   = var.http_port
    protocol  = "tcp"
    cidr_blocks = [
    var.vpc_cidr]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}

# ALB security group
resource "aws_security_group" "alb_sg" {
  name   = "${local.name_prefix}-nginx_alb_sg"
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags

  # HTTP access from anywhere
  ingress {
    from_port = var.http_port
    to_port   = var.http_port
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
}


