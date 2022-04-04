
# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.webserver_instance_type
  # subnet_id              = aws_subnet.subnets[count.index % var.subnet_count].id
  subnet_id              = module.vpc.public_subnets[count.index % var.subnet_count]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-instance-${count.index}"
  })
  # iam_instance_profile = aws_iam_instance_profile.nginx_profile.name
  iam_instance_profile = module.s3.instance_profile.name
  # depends_on           = [aws_iam_role_policy.allow_s3_all]
  depends_on           = [module.s3]

  user_data = templatefile("${path.module}/startup_script.tpl", {
    # s3_bucket_name = aws_s3_bucket.web_bucket.id
    s3_bucket_name = module.s3.web_bucket.id
  })
}