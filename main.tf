provider "azurerm" {
  version = "=1.38.0"
}

resource "azurerm_resource_group" "urban_noise_rg" {
  name     = "urbannoise-db-account"
  location = "West Europe"
}

data "azurerm_cosmosdb_account" "urbannoise-db-account-rg" {
  name                = "${azurerm_resource_group.urban_noise_rg.name}"
  resource_group_name = "${azurerm_resource_group.urban_noise_rg.name}"
}

resource "azurerm_cosmosdb_mongo_database" "urban-noise-db" {
  name                = "urban-noise-db"
  resource_group_name = "${data.azurerm_cosmosdb_account.urbannoise-db-account-rg.resource_group_name}"
  account_name        = "${data.azurerm_cosmosdb_account.urbannoise-db-account-rg.name}"
}

resource "azurerm_cosmosdb_mongo_collection" "generic-components-collection" {
  name                = "generic-components"
  resource_group_name = "${data.azurerm_cosmosdb_account.urbannoise-db-account-rg.resource_group_name}"
  account_name        = "${data.azurerm_cosmosdb_account.urbannoise-db-account-rg.name}"
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