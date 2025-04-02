variable "dns_zone_name" {
  description = "The name of the DNS zone to create"
  type        = string
}

variable "dns_records_list" {
  type = map(list(object({
    name     = string
    value    = string
    type     = string
    proxied  = bool
    priority = optional(number)
  })))
  description = "Map of DNS records to create"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
}