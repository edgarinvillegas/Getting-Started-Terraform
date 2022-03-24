
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

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_subnet" "subnets" {
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet-${count.index}"
  })
  availability_zone = data.aws_availability_zones.disponibles.names[count.index]
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rtb"
  })
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-subnets" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {

  name   = "${local.name_prefix}-nginx_sg"
  vpc_id = aws_vpc.vpc.id
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
  vpc_id = aws_vpc.vpc.id
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


