module "cloudflare_dns" {
  source = "./modules/dns"

  cloudflare_api_token = var.cloudflare_api_token
  dns_zone_name        = "venturingintellect.com"
  dns_records_list = {
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
}