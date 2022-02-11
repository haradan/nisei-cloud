terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.17.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "haradan"

    workspaces {
      tags = ["nisei-cloud"]
    }
  }
}

provider "digitalocean" {
}

resource "random_pet" "test" {}

output "test-pet" {
  value = random_pet.test.id
}

data "digitalocean_account" "this" {
}

output "digitalocean-account-status" {
  value = data.digitalocean_account.this.status
}
