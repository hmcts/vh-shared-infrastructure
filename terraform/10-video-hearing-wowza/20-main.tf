data "azurerm_client_config" "current" {
}

#--------------------------------------------------------------
# VH - Resource Group
#--------------------------------------------------------------

data "azurerm_resource_group" "vh-infra-core" {
  name = "vh-infra-core-${var.environment}"
}

#--------------------------------------------------------------
# VH - Key Vault Lookup
#--------------------------------------------------------------

data "azurerm_key_vault" "vh-infra-core" {
  name                = "vh-infra-core-${var.environment}"
  resource_group_name = data.azurerm_resource_group.vh-infra-core.name
}

data "azurerm_key_vault_certificate" "vh-wildcard" {
  name         = "wildcard-hearings-reform-hmcts-net"
  key_vault_id = data.azurerm_key_vault.vh-infra-core.id
}

output "certificate_thumbprint" {
  value = data.azurerm_key_vault_certificate.vh-wildcard.thumbprint
}


#--------------------------------------------------------------
# VH - Wowza
#--------------------------------------------------------------

data "azurerm_private_dns_zone" "core-infra-intsvc" {
  provider            = azurerm.private-endpoint-dns
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

#data "azurerm_private_dns_zone" "reform-hearings-dns" {
#  provider              = azurerm.hearings-dns
#  name                  = "hearings.reform.hmcts.net"
#  resource_group_name   = "vh-hearings-reform-hmcts-net-dns-zone"
#}

module "wowza" {
  source                      = "./modules/wowza"
  environment                 = var.environment
  location                    = var.location
  service_name                = "vh-infra-wowza-${var.environment}"
  key_vault_id                = data.azurerm_key_vault.vh-infra-core.id
  address_space               = lookup(var.workspace_to_address_space_map, var.environment, "")
  private_dns_zone_group      = data.azurerm_private_dns_zone.core-infra-intsvc.id
  private_dns_zone_group_name = data.azurerm_private_dns_zone.core-infra-intsvc.name
  network_client_id           = var.network_client_id
  network_client_secret       = var.network_client_secret
  network_tenant_id           = var.network_tenant_id
  tags                        = local.common_tags


  #hearings_dns_zone              = data.azurerm_private_dns_zone.reform-hearings-dns.id
}

#provider "azurerm" {
#  alias = "private-endpoint-dns"
#  features {}
#  hearings_dns_zone              = data.azurerm_private_dns_zone.hearings-dns.name
#  private_dns_zone_group         = data.azurerm_private_dns_zone.core-infra-intsvc.id
#  #hearings_dns_zone              = data.azurerm_private_dns_zone.reform-hearings-dns.name
#}

#commented out as I'd rather make these changes in a new PR
#resource "azurerm_dns_a_record" "wowza" {
#  provider = azurerm.dns
#
#  name                = "vh-infra-wowza-${var.environment}"
#  zone_name           = var.dns_zone_name
#  resource_group_name = var.dns_resource_group
#  ttl                 = 300
#  records             = [module.wowza.public_ip_address]
#}
#