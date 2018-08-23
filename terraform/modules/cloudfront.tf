resource "aws_cloudfront_distribution" "cf" {
  enabled = true
  is_ipv6_enabled = true
  aliases = ["${var.dns}"]
  comment = "${var.name}"

  origin {
      domain_name = "${aws_alb.alb.dns_name}"
      origin_id = "${aws_alb.alb.name}"

      custom_origin_config {
          http_port = 80
          https_port = 443
          origin_keepalive_timeout = 5
          origin_protocol_policy = "match-viewer"
          origin_read_timeout = 60
          origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
  }

  origin {
    domain_name = "${var.bucket_domain}"
    origin_id   = "S3-${var.bucket}"

    #s3_origin_config {
    #  origin_access_identity = ""
    #}
  }

  restrictions {
      geo_restriction {
          restriction_type = "none"
      }
  }

  viewer_certificate {
      cloudfront_default_certificate = false
      acm_certificate_arn = "${var.cf_certificate_arn}"
      minimum_protocol_version = "TLSv1"
      ssl_support_method = "sni-only"
  }

  default_cache_behavior {
      allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
      cached_methods   = ["HEAD", "GET", "OPTIONS"]
      target_origin_id = "${aws_alb.alb.name}"

      forwarded_values {
          query_string = true

          cookies {
              forward = "all"
          }

          headers = ["Accept", "Accept-Language", "Authorization", "CloudFront-Forwarded-Proto", "Host", "Origin", "Referer", "User-agent"]
      }

      viewer_protocol_policy = "redirect-to-https"
      min_ttl = 0
      max_ttl = 0
      default_ttl = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/production/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${var.bucket}"

    forwarded_values {
      query_string = false
      headers = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/production/uploads/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-${var.bucket}"

    forwarded_values {
      query_string = false
      headers = ["Origin"]
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  #logging_config {
  #    bucket = "${var.bucket}"
  #    include_cookies = "true"
  #    #prefix = "cf/"
  #}
}
