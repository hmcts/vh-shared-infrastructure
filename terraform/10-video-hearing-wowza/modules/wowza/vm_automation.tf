locals {
  cert_env     = var.environment == "prod" ? "" : "${var.environment}-"
  domain_env   = var.environment == "prod" ? "" : "${var.environment}."
  wowza_domain = "vh-wowza.${local.domain_env}platform.hmcts.net"
}

resource "random_password" "certPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "random_password" "restPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "random_password" "streamPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}


data "template_file" "cloudconfig" {
  template = file(var.cloud_init_file)
  vars = {
    certPassword            = random_password.certPassword.result
    storageAccountName      = azurerm_storage_account.wowza_recordings.name
    storageContainerName    = azurerm_storage_container.recordings.name
    msiClientId             = azurerm_user_assigned_identity.wowza_storage.client_id
    restPassword            = md5("wowza:Wowza:${random_password.restPassword.result}")
    streamPassword          = md5("wowza:Wowza:${random_password.streamPassword.result}")
    managedIdentityClientId = azurerm_user_assigned_identity.wowza_cert.client_id
    certName                = "wildcard-${local.cert_env}platform-hmcts-net"
    keyVaultName            = data.azurerm_key_vault.acmekv.name
    domain                  = local.wowza_domain
  }
}

data "template_cloudinit_config" "wowza_setup" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}
