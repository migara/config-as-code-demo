resource "panos_panorama_device_group" "this" {
  name = "policy-as-code"
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

