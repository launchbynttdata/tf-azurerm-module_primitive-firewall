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

output "id" {
  value = azurerm_firewall.firewall.id
}

output "firewall_policy_id" {
  value = azurerm_firewall.firewall.firewall_policy_id
}

output "dns_servers" {
  value = azurerm_firewall.firewall.dns_servers
}

output "ip_configuration" {
  value = azurerm_firewall.firewall.ip_configuration
}

output "management_ip_configuration" {
  value = var.management_ip_configuration
}
