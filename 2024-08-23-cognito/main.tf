terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
  required_version = ">= 1.2.0"
}
provider "aws" {
  region  = var.region
}



resource "aws_cognito_user_pool" "pool" {
  name = split("@", var.user_mail_address)[1]
  user_pool_tier = "LITE"
  username_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${lower(split("_", aws_cognito_user_pool.pool.id)[1])}mw" # so my millions of followers don't clash
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name = "Tailscale"
  user_pool_id = aws_cognito_user_pool.pool.id
  callback_urls                        = ["https://login.tailscale.com/a/oauth_response"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username = var.user_mail_address
  attributes = {
    email          = var.user_mail_address
    email_verified = true
  }
}


output "login_url" {
    description = "Cognito login URL"
    value = "https://${aws_cognito_user_pool.pool.domain}.auth.${var.region}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.client.id}&response_type=code&scope=email+openid+profile&redirect_uri=https%3A%2F%2Flogin.tailscale.com%2Fa%2Foauth_response"
}
