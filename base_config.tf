resource "panos_panorama_device_group" "this" {
  name        = var.device_group_name
  description = "example device group for policy as code demo"
}

resource "panos_antivirus_security_profile" "example" {
  name         = "av"
  device_group = panos_panorama_device_group.this.name
  description  = "example AV profile"

  decoder { name = "smtp" }
  decoder { name = "smb" }
  decoder { name = "pop3" }
  decoder { name = "imap" }
  decoder { name = "http" }
  decoder { name = "http2" }
  decoder {
    name   = "ftp"
    action = "reset-both"
  }
  application_exception {
    application = "hotmail"
    action      = "alert"
  }
}

resource "panos_panorama_template" "this" {
  name        = "${var.device_group_name} TPL"
  description = "${var.device_group_name} template"
}

resource "panos_panorama_template_stack" "this" {
  name        = "${var.device_group_name} TPL STK"
  description = "${var.device_group_name} TPL STK"
  templates   = [panos_panorama_template.this.name]
}

resource "panos_panorama_virtual_router" "this" {
  template    = panos_panorama_template.this.name
  name        = "vr"
  static_dist = 15
}

resource "panos_panorama_static_route_ipv4" "this" {
  for_each       = { for rt in yamldecode(file("./routes.yml")) : rt.name => rt }
  template       = panos_panorama_template.this.name
  virtual_router = panos_panorama_virtual_router.this.name
  name           = each.key
  destination    = each.value.destination
  next_hop       = each.value.next_hop
}
