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
locals {
  resource_group_name  = module.resource_names["resource_group"].minimal_random_suffix
  firewall_name        = module.resource_names["firewall"].minimal_random_suffix
  virtual_network_name = module.resource_names["virtual_network"].minimal_random_suffix
  public_ip_name       = module.resource_names["public_ip"].minimal_random_suffix

  # firewall_map = {
  #   "firewall1" = {
  #     client_name           = var.client_name
  #     environment           = var.environment
  #     location              = var.location
  #     location_short        = var.location_short
  #     logs_destinations_ids = var.logs_destinations_ids
  #     resource_group_name   = local.resource_group
  #     stack                 = var.stack
  #     subnet_cidr           = var.subnet_cidr
  #     virtual_network_name  = local.virtual_network_name

  #     additional_public_ips           = var.additional_public_ips
  #     application_rule_collections    = var.application_rule_collections
  #     custom_diagnostic_settings_name = var.custom_diagnostic_settings_name
  #     custom_firewall_name            = local.firewall_name
  #     extra_tags                      = var.extra_tags
  #     firewall_private_ip_ranges      = var.firewall_private_ip_ranges
  #     ip_configuration_name           = local.ip_configuration_name
  #     network_rule_collections        = var.network_rule_collections
  #     public_ip_custom_name           = local.public_ip_custom_name
  #     public_ip_zones                 = var.public_ip_zones
  #     sku_tier                        = var.sku_tier
  #     zones                           = var.zones
  #   }
  # }

  # network_map = {
  #   "network1" = {
  #     address_space                                         = var.address_space
  #     subnet_prefixes                                       = var.subnet_prefixes
  #     bgp_community                                         = var.bgp_community
  #     ddos_protection_plan                                  = var.ddos_protection_plan
  #     nsg_ids                                               = var.nsg_ids
  #     route_tables_ids                                      = var.route_tables_ids
  #     subnet_delegation                                     = var.subnet_delegation
  #     subnet_enforce_private_link_endpoint_network_policies = var.subnet_enforce_private_link_endpoint_network_policies
  #     subnet_enforce_private_link_service_network_policies  = var.subnet_enforce_private_link_service_network_policies
  #     subnet_service_endpoints                              = var.subnet_service_endpoints
  #     tags                                                  = var.tags
  #     tracing_tags_enabled                                  = var.tracing_tags_enabled
  #     tracing_tags_prefix                                   = var.tracing_tags_prefix

  #     use_for_each        = var.use_for_each
  #     resource_group_name = local.resource_group
  #     vnet_location       = var.location
  #     subnet_names        = []
  #     location            = var.location
  #     vnet_name           = local.virtual_network_name
  #   }
  # }
}
