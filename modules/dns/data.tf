data "cloudflare_zone" "single_zone" {
  count = var.single_zone_name != "" ? 1 : 0
  name  = var.single_zone_name
}

data "cloudflare_zone" "multi_zones" {
  for_each = {
    for zone_name, _ in var.multi_zone_dns_records : zone_name => zone_name
  }
  name = each.key
}