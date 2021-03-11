resource "panos_panorama_security_rule_group" "this" {
  
  device_group = panos_panorama_device_group.this

  dynamic "rule" {
    for_each = { for policy in yamldecode(file("./policy.yml")): policy.name => policy }
    content {
      name = rule.key
      source_zones = lookup(rule.value, "source_zones", ["any"])
      source_addresses = lookup(rule.value, "source_addresses", ["any"])
      source_users = lookup(rule.value, "source_users", ["any"])
      hip_profiles = lookup(rule.value, "hip_profiles", ["any"])
      destination_zones = lookup(rule.value, "destination_zones", ["any"])
      destination_addresses = lookup(rule.value, "destination_addresses", ["any"])
      applications = lookup(rule.value, "applications", ["any"])
      services = lookup(rule.value, "services", ["application-default"])
      categories = lookup(rule.value, "categories", ["any"])
      action = lookup(rule.value, "action", "allow")
    }
  }
}
