location                       = "uksouth"
admin_ssh_key_path             = "/home/vsts/work/_temp/wowza-ssh-public-key.pub"
service_certificate_thumbprint = "4BD1E66CA94EEF7EA2EAA66569C55EF56C3AE5AF"
service_certificate_kv_url     = "https://vh-infra-core-sbox.vault.azure.net/secrets/wildcard-hearings-reform-hmcts-net/70494b59b00c48c2afc746cca5fdbf8b"
dns_resource_group             = "vh-hearings-reform-hmcts-net-dns-zone"
dns_zone_name                  = "hearings.reform.hmcts.net"
peering_target_subscription_id = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"

schedules = [
  {
    name      = "vm-off",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = false
  }
]