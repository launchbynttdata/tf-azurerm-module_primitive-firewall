// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "firewall" {
  source = "../.."

  name                = local.firewall_name
  resource_group_name = local.resource_group_name

  location = var.location
  sku_tier = "Standard"
  ip_configuration = [{
    name                 = "Data"
    subnet_id            = module.network.vnet_subnets_name_id["AzureFirewallSubnet"]
    public_ip_address_id = null
  }]
  management_ip_configuration = {
    name                 = "Management"
    subnet_id            = module.network.vnet_subnets_name_id["AzureFirewallManagementSubnet"]
    public_ip_address_id = module.public_ip.id
  }

  tags = local.tags

  depends_on = [module.resource_group]
}


module "public_ip" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/public_ip/azurerm"
  version = "~> 1.0"

  name                = local.public_ip_name
  resource_group_name = local.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags

  depends_on = [module.resource_group]
}

module "network" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/virtual_network/azurerm"
  version = "~> 2.0"

  resource_group_name = local.resource_group_name
  use_for_each        = true

  vnet_name       = local.virtual_network_name
  vnet_location   = var.location
  address_space   = ["172.16.0.0/16"]
  subnet_names    = ["AzureFirewallSubnet", "AzureFirewallManagementSubnet"]
  subnet_prefixes = ["172.16.0.0/26", "172.16.0.64/26"]

  tags = local.tags

  depends_on = [module.resource_group]
}

module "resource_group" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = local.resource_group_name
  location = var.location

  tags = local.tags
}

module "resource_names" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}
