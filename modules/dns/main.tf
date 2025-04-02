# Single zone records
resource "cloudflare_record" "record" {
  for_each = var.dns_zone_name != "" ? {
    for record in flatten([
      for key, records in var.dns_records_list : [
        for idx, r in records : {
          key    = "${key}-${idx}"
          record = r
        }
      ]
    ]) : record.key => record.record
  } : {}

  zone_id  = data.cloudflare_zone.single_zone[0].id
  name     = each.value.name
  content  = each.value.type == "TXT" ? "\"${each.value.value}\"" : each.value.value
  type     = each.value.type
  ttl      = each.value.proxied ? 1 : 300
  proxied  = each.value.proxied
  priority = each.value.priority
}

# Multi-zone records
resource "cloudflare_record" "multi_zone_records" {
  for_each = {
    for record in flatten([
      for zone_name, zone_records in var.multi_zone_dns_records : [
        for group_key, group_records in zone_records : [
          for idx, r in group_records : {
            zone_name = zone_name
            key       = "${zone_name}-${group_key}-${idx}"
            record    = r
          }
        ]
      ]
    ]) : record.key => record
  }

  zone_id  = data.cloudflare_zone.multi_zones[each.value.zone_name].id
  name     = each.value.record.name
  content  = each.value.record.type == "TXT" ? "\"${each.value.record.value}\"" : each.value.record.value
  type     = each.value.record.type
  ttl      = each.value.record.proxied ? 1 : 300
  proxied  = each.value.record.proxied
  priority = each.value.record.priority
}