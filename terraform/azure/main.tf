provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-ejemplo-carlosacosta"
  location = "West Europe"
}
