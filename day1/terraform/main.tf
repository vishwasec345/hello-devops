# Day 1 demo: Infrastructure as Code with Terraform.
# Uses only the "local" provider, so no cloud account or credentials are needed.
# The "infrastructure" is a folder of files on this machine, but the workflow
# (init > plan > apply > change > destroy) is exactly the same as for AWS or Azure.

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# Inputs: change these to change the infrastructure.
variable "environment" {
  description = "Which environment we are building"
  type        = string
  default     = "dev"
}

variable "servers" {
  description = "How many web servers to create"
  type        = number
  default     = 2
}

# One config file per "server": web-1.txt, web-2.txt, ...
resource "local_file" "server" {
  count    = var.servers
  filename = "${path.module}/infra-${var.environment}/web-${count.index + 1}.txt"
  content  = <<-EOT
    name        = web-${count.index + 1}
    environment = ${var.environment}
    app         = hello-devops
  EOT
}

# A summary page for the environment.
resource "local_file" "readme" {
  filename = "${path.module}/infra-${var.environment}/README.txt"
  content  = "Environment '${var.environment}' has ${var.servers} web server(s). Built by Terraform, do not edit by hand.\n"
}

# Outputs: printed after every apply.
output "server_files" {
  value = local_file.server[*].filename
}
