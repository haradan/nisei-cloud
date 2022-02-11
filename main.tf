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

resource "random_pet" "test" {}

output "test-pet" {
  value = random_pet.test.id
}

data "digitalocean_projects" "this" {
}

output "digitalocean-projects" {
  value = jsonencode(data.digitalocean_projects.this.projects)
}
