location = "uksouth"

dns_resource_group = "vh-hearings-reform-hmcts-net-dns-zone"
dns_zone_name      = "hearings.reform.hmcts.net"

peering_target_subscription_id = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"

schedules = [
  {
    name      = "vm-on",
    frequency = "Day"
    interval  = 1
    run_time  = "06:00:00"
    start_vm  = true
  }
]