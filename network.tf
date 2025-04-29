locals {
  network_spec = {
    network1 = {
      location         = "eastus"
      address_space    = ["10.0.0.0/16"]
      subnets = {
        subnet1 = {
          address_prefix = "10.0.1.0/24"
        }
        subnet2 = {
          address_prefix = "10.0.2.0/24"
        }
      }
    }
    network2 = {
      location         = "westus"
      address_space    = ["10.1.0.0/16"]
      subnets = {
        subnet1 = {
          address_prefix = "10.1.1.0/24"
        }
      }
    }
  }
}

resource "azurerm_resource_group" "network" {
  for_each = local.network_spec
  name     = "rg-${each.key}"
  location = each.value.location
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = local.network_spec
  name                = "vnet-${each.key}"
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = azurerm_resource_group.network[each.key].name
}

resource "azurerm_subnet" "subnet" {
  for_each = {
    for network_name, network in local.network_spec :
    for subnet_name, subnet in network.subnets :
    "${network_name}-${subnet_name}" => {
      vnet_name         = "vnet-${network_name}"
      resource_group    = "rg-${network_name}"
      address_prefix    = subnet.address_prefix
      subnet_name       = subnet_name
    }
  }

  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group
  virtual_network_name = each.value.vnet_name
  address_prefixes     = [each.value.address_prefix]
}
