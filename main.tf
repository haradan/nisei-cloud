terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
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
