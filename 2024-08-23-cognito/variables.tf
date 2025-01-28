variable "region" {
  description = "Which AWS region to use"
  type        = string
  default     = "us-east-2"
}

variable "user_mail_address" {
  description = "Email address of the user you'll be signing up for Tailscale with"
  type        = string
  default     = "me@example.com"
}