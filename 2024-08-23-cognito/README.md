[2024-08-23 - Using Tailscale with Cognito on your own domain (for free!)](https://mwinters.net/blog/techblah-using-tailscale-with-cognito-on-your-own-domain-for-free/)

**Usage:**
1) Edit variables.tf to set `user_mail_address` and possibly `region` if you prefer a different one.
1) `terraform init` and `terraform plan` and `terraform apply`.  The temporary password will be emailed to you, and the login URL will be provided as a terraform output.
1) Continue from Step 4 in the blog post!

*Note:* The first time you run this, the `login_url` output may be be missing the initial domain, thanks to eventual consistency at AWS.  Just run `terraform apply` again to get the correct url.