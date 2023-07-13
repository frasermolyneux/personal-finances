environment = "prd"
instance    = "01"

primary_location = "uksouth"
locations        = ["uksouth"]

subscription_id = "957a7d34-8562-4098-bb4c-072e08386d07"

log_analytics_subscription_id     = "d68448b0-9947-46d7-8771-baa331a3063a"
log_analytics_resource_group_name = "rg-platform-logging-prd-uksouth-01"
log_analytics_workspace_name      = "log-platform-prd-uksouth-01"

tags = {
  Environment = "prd",
  Workload    = "personal-finances",
  DeployedBy  = "GitHub-Terraform",
  Git         = "https://github.com/frasermolyneux/personal-finances"
}
