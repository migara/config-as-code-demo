terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
      version = "1.8.0"
    }
  }

  backend "remote" {
    organization = "migara"
    workspaces {
      name = "policy-as-code"
    }
  }
}

provider "panos" {}