module "s3" {
  source = "./modules/globo-web-app-s3"
  bucket_name = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  name_prefix = local.s3_bucket_name #local.name_prefix
  common_tags = local.common_tags
}

# aws_s3_bucket_object
resource "aws_s3_bucket_object" "website_objects" {
  for_each = {
    website = "/website/index.html"
    graphic = "/website/Globo_logo_Vert.png"
  }
  bucket = module.s3.web_bucket.id
  key    = each.value
  source = ".${each.value}"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-s3object-${each.key}"
  })
}

