variable "project_name" {
  description = "Project name"
  type        = string
  default     = "template-starter"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Custom domain name (e.g., example.com)"
  type        = string
}
