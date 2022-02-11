variable "environment_name" {
  description = "Name of the environment the cluster is for"
  type        = string
  default     = "dev"
}

locals {
  deployment_name = "nisei-cloud-${var.environment_name}"
}
