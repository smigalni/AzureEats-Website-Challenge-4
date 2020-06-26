terraform {
  backend "azurerm" {
    resource_group_name  = "tstate4"
    storage_account_name = "tstate4"
    container_name       = "tstate4"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  version = "=2.0.0"
  features { }  
}

resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
}

resource "azurerm_sql_server" "server" {
  name                         = var.sqlServerName
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sqlServerUser
  administrator_login_password = var.sqlServerPassword

  tags = {
    Environment = "Challenge4"
  }
}
resource "azurerm_sql_firewall_rule" "db_server_fw" {
  name                = "AllowAccessAzureService"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "db" {
  name                = "mysqldatabase4"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  server_name         = azurerm_sql_server.server.name  
}

resource "azurerm_container_group" "main" {
  name                  = "mongodbnamesergeynet4"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  ip_address_type       = "public"
  dns_name_label        = "aci-label-sergey-net4"
  os_type               = "Linux"

  container {
    name   = "mongodb"
    image  = "mongo:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 27017
      protocol = "TCP"
    }

    environment_variables = {
        MONGO_INITDB_ROOT_USERNAME = var.mongo_user
        MONGO_INITDB_ROOT_PASSWORD = var.mongo_password
    }
  }
}

resource "azurerm_container_registry" "challenge4" {
  name                = "challenge4acrsergey"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = azurerm_resource_group.rg.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "k8sergeynet" {
    name                = var.cluster_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_DS1_v2"
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
        }
    }

    tags = {
        Environment = "Challenge4"
    }
}