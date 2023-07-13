variable "environment" {
  default = "dev"
}

variable "instance" {
  default = "01"
}

variable "primary_location" {
  default = "uksouth"
}

variable "locations" {
  default = ["uksouth", "ukwest"]
}

variable "subscription_id" {}

variable "log_analytics_subscription_id" {}
variable "log_analytics_resource_group_name" {}
variable "log_analytics_workspace_name" {}

variable "tags" {
  default = {}
}
