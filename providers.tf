terraform {
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.8.0"
    }
  }

  backend "s3" {
    bucket = "config-as-code-demo"
    key    = "gh-actions-pac"
  }
}

provider "panos" {}
