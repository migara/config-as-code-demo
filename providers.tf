terraform {
  required_providers {
    panos = {
      source  = "PaloAltoNetworks/panos"
      version = "1.8.0"
    }
  }

  backend "s3" {
    bucket = "regional-training-2021-gh-actions"
    key    = "gh-actions-pac"
  }
}

provider "panos" {}