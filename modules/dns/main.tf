resource "cloudflare_record" "record" {
  for_each = {
    for record in flatten([
      for key, records in var.dns_records_list : [
        for idx, r in records : {
          key    = "${key}-${idx}"
          record = r
        }
      ]
    ]) : record.key => record.record
  }

  zone_id  = data.cloudflare_zone.zone.id
  name     = each.value.name
  content  = each.value.type == "TXT" ? "\"${each.value.value}\"" : each.value.value
  type     = each.value.type
  ttl      = each.value.proxied ? 1 : 300
  proxied  = each.value.proxied
  priority = each.value.priority
}