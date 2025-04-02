module "cloudflare_dns" {
  source = "./modules/dns"

  cloudflare_api_token = var.cloudflare_api_token
  
  # Single zone configuration
  single_zone_name    = "venturingintellect.com"
  single_zone_dns_records_list = {
    "gh_pages" = [
      {
        name    = "venturingintellect.com"
        value   = "venturing-intellect.github.io"
        type    = "CNAME"
        proxied = true
      }
    ]
    "challenges" = [
      {
        name    = "25womenintech-challenge.venturingintellect.com"
        value   = "venturing-intellect.github.io"
        type    = "CNAME"
        proxied = true
      }
    ]
  }
  
  # Multi-zone configuration
  multi_zone_dns_records = {
    "example1.com" = {
      "gh_pages" = [
        {
          name    = "example1.com"
          value   = "user.github.io"
          type    = "CNAME"
          proxied = true
        }
      ],
      "challenges" = [
        {
          name    = "challenge.example1.com"
          value   = "user.github.io"
          type    = "CNAME"
          proxied = true
        }
      ]
    },
    "example2.com" = {
      "mail" = [
        {
          name     = "example2.com"
          value    = "mail.example2.com"
          type     = "MX"
          proxied  = false
          priority = 10
        }
      ],
      "www" = [
        {
          name    = "www.example2.com"
          value   = "185.199.108.153"
          type    = "A"
          proxied = true
        }
      ]
    }
  }
}