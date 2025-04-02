variable "single_zone_name" {
  description = "The name of the DNS zone to create (single zone mode)"
  type        = string
  default     = ""
}

variable "single_zone_dns_records_list" {
  type = map(list(object({
    name     = string
    value    = string
    type     = string
    proxied  = bool
    priority = optional(number)
  })))
  description = "Map of DNS records to create for a single zone"
  default     = {}
}

variable "multi_zone_dns_records" {
  type = map(
    map(list(object({
      name     = string
      value    = string
      type     = string
      proxied  = bool
      priority = optional(number)
    })))
  )
  description = "Map of zone names to records map for managing multiple zones"
  default     = {}
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
}