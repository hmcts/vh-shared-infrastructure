# Uncomment defaults to run locally/supply values
variable "location" {
  type = string
}

variable "build_agent_vnet" {
  type    = list(string)
  default = []
}

variable "vh_tenant_id" {
  type    = string
  default = ""
}

variable "vh_client_id" {
  type    = string
  default = ""
}

#tfsec:ignore:general-secrets-sensitive-in-variable
variable "vh_client_secret" {
  type    = string
  default = ""
}

variable "dns_tenant_id" {
  type    = string
  default = ""
}

variable "dns_client_id" {
  type    = string
  default = ""
}

#tfsec:ignore:general-secrets-sensitive-in-variable
variable "dns_client_secret" {
  type    = string
  default = ""
}

variable "dns_subscription_id" {
  type    = string
  default = ""
}

locals {
  variable "dns_zone_mapping" {
    description = "mapping for endpoint dns"
    default = {
      "sqlServer" = "privatelink.database.windows.net",
      "redisCache" = "privatelink.redis.cache.windows.net",
      "signalr" = "privatelink.service.signalr.net",
      "vault" = "privatelink.vaultcore.azure.net"
    }
  }
}
