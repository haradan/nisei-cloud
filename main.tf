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
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
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

variable "digitalocean_token" {
  description = "Access token for DigitalOcean"
  type        = string
  sensitive   = true
}

provider "digitalocean" {
  token = var.digitalocean_token
}
