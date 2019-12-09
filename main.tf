provider "azurerm" {
  version = "=1.38.0"
}

resource "azurerm_resource_group" "urban_noise_rg" {
  name     = "urbannoise-db-account-rg"
  location = "West Europe"
}

resource "azurerm_cosmosdb_account" "urbannoise-db-account" {
  name                = "urbannoise-db-account"
  resource_group_name = "${azurerm_resource_group.urban_noise_rg.name}"
  location            = "${azurerm_resource_group.urban_noise_rg.location}"
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200000
  }

  geo_location {
    location          = "North Europe"
    failover_priority = 1
  }

  geo_location {
  location            = "${azurerm_resource_group.urban_noise_rg.location}"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "urban-noise-db" {
  name                = "urban-noise-db"
  resource_group_name = "${azurerm_cosmosdb_account.urbannoise-db-account.resource_group_name}"
  account_name        = "${azurerm_cosmosdb_account.urbannoise-db-account.name}"
}

resource "azurerm_cosmosdb_mongo_collection" "generic-components-collection" {
  name                = "generic-components"
  resource_group_name = "${azurerm_cosmosdb_account.urbannoise-db-account.resource_group_name}"
  account_name        = "${azurerm_cosmosdb_account.urbannoise-db-account.name}"
  database_name       = "${azurerm_cosmosdb_mongo_database.urban-noise-db.name}"

  default_ttl_seconds = "777"
  shard_key           = "uniqueKey"
  throughput          = 400

  indexes {
    key    = "aKey"
    unique = false
  }

  indexes {
    key    = "uniqueKey"
    unique = true
  }
}