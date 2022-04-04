# aws_elb_service_account
data "aws_elb_service_account" "root" {}

# aws_lb
resource "aws_lb" "nginx" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  # subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  # subnets = aws_subnet.subnets[*].id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = local.common_tags

  access_logs {
    bucket  = module.s3.web_bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }
}

# aws_lb_target_group
resource "aws_lb_target_group" "nginx" {
  name     = "${local.name_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  #vpc_id   = aws_vpc.vpc.id
  vpc_id   = module.vpc.vpc_id

  tags = local.common_tags
}

# aws_lb_listener
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-lb_listener"
  })
}

# aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}


