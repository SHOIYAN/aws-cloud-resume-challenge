terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-user"
}

# ----------------------------- S3 Bucket ----------------------------- #


# S3 bucket to store frontend files
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "crc-chall3ng3-bucket" # Updated bucket name
}

# CloudFront Origin Access Identity (OAI) for S3 access
resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  comment = "OAI for S3 bucket access in CRC-Challenge"
}

# Bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.s3_oai.iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

# Upload all files in the front-end folder to S3
resource "aws_s3_object" "frontend_files" {
  for_each = fileset("${path.module}/../Front-end", "**/*")

  bucket = aws_s3_bucket.frontend_bucket.id
  key    = each.value
  source = "${path.module}/../Front-end/${each.value}"
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")

}

# ----------------------------- CloudFront ----------------------------- #

# CloudFront Distribution
resource "aws_cloudfront_distribution" "portfolio_distribution" {
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = "frontend_bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"


  # Set CNAME (alternative domain name)
  aliases = ["portfolio.shoiyan.com"] 

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "frontend_bucket"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Custom Error Response for 404 Not Found
  custom_error_response {
    error_code            = 404
    response_page_path    = "/error.html"
    response_code         = 200
    error_caching_min_ttl = 300
  }

  # Configure HTTPS with ACM certificate
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}



# ----------------------------- Route 53 ----------------------------- #

# ACM certificate for CloudFront
resource "aws_acm_certificate" "certificate" {
  domain_name       = "portfolio.shoiyan.com"
  validation_method = "DNS"
  

  tags = {
    Name = "PortfolioCertificate"
  }
}

# ACM certificate validation record
resource "aws_route53_record" "cert_validation" {
  for_each = { for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => dvo }

  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

# ACM certificate validation completion
resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Route 53 zone data lookup for 'shoiyan.com'
data "aws_route53_zone" "main_zone" {
  name = "shoiyan.com"
}

# Route 53 record pointing to CloudFront
resource "aws_route53_record" "cloudfront_alias" {
  zone_id = data.aws_route53_zone.main_zone.zone_id # Use 'data' here
  name    = "portfolio.shoiyan.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
