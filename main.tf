provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

module "resourcegroup" {
  source         = "./modules/resourcegroup"
  name           = var.name
  location       = var.location
}

#test push