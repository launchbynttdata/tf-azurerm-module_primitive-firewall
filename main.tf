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

resource "azurerm_firewall" "firewall" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = var.firewall_policy_id
  dns_servers         = var.dns_servers
  private_ip_ranges   = var.private_ip_ranges
  threat_intel_mode   = var.threat_intel_mode
  zones               = var.zones
  tags                = local.tags

  dynamic "ip_configuration" {
    for_each = var.ip_configuration == null ? [] : var.ip_configuration

    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.public_ip_address_id
      subnet_id            = ip_configuration.value.subnet_id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration == null ? [] : [var.management_ip_configuration]

    content {
      name                 = management_ip_configuration.name
      public_ip_address_id = management_ip_configuration.public_ip_address_id
      subnet_id            = management_ip_configuration.subnet_id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.virtual_hub == null ? [] : [var.virtual_hub]

    content {
      virtual_hub_id  = virtual_hub.virtual_hub_id
      public_ip_count = virtual_hub.public_ip_count
    }
  }
}
