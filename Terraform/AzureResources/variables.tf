variable "appServiceName" {
  description = "The name of app service"
}

variable "appServicePlanName" {
  description = "The name of app service plan"
}

variable "sqlServerUser" {
  description = "The administrator login user"
}

variable "sqlServerPassword" {
  description = "The administrator login password"
}

variable "sqlServerName" {
  description = "The sql server name"
}

variable "resourceGroupName" {
  description = "The name of resource group"
}

variable "mongo_user" {
  description = "The administrator login user"
}

variable "mongo_password" {
  description = "The administrator login user password"
}

variable "location" {
  description = "Location"
}

variable "subscriptionId" {
  description = "Subscription id"
}

variable "tenantId" {
  description = "Tenant id"
}

variable "client_id" {
  description = "Client id"
}

variable "client_secret" {
  description = "Client secret"
}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8stestsergey"
}

variable cluster_name {
    default = "k8stest"
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "westeurope"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}