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

variable "name" {
  description = "Specifies the name of the Firewall. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "sku_name" {
  description = "SKU name of the Firewall. Possible values are `AZFW_Hub` and `AZFW_VNet`, defaults to `AZFW_VNet`. Changing this forces a new resource to be created."
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition     = contains(["AZFW_Hub", "AZFW_VNet"], var.sku_name)
    error_message = "sku_name must contain either 'AZFW_Hub' or 'AZFW_VNet'."
  }
}

variable "sku_tier" {
  description = "SKU tier of the Firewall. Possible values are `Basic`, `Standard`, and `Premium`."
  type        = string

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must contain either 'Basic', 'Standard', or 'Premium'."
  }
}

variable "firewall_policy_id" {
  description = "The ID of the Firewall Policy applied to this Firewall."
  type        = string
  default     = null
}

variable "ip_configuration" {
  description = "An IP configuration block to configure public IPs and subnets associated with this firewall. The Subnet used for the Firewall must have the name `AzureFirewallSubnet` and the subnet mask must be at least a /26. Any Public IPs must have a Static allocation and Standard SKU. One and only one ip_configuration object may contain a `subnet_id`. A public ip address is required unless a `management_ip_configuration` block is specified."
  type = list(object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  }))
  default = null
}

variable "dns_proxy_enabled" {
  description = "Whether DNS proxy is enabled. It will forward DNS requests to the DNS servers when set to `true`. It will be set to `true` if `dns_servers` was provided with a non-empty list."
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  type        = list(string)
  default     = null
}

variable "private_ip_ranges" {
  description = "An optional list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  type        = list(string)
  default     = null
}

variable "management_ip_configuration" {
  description = "An IP Configuration block to configure force-tunnelling of traffic to be performed by the firewall. The Management Subnet used for the Firewall must have the name `AzureFirewallManagementSubnet` and the subnet mask must be at least a /26. The Public IP must have a `Static` allocation and `Standard` SKU. Adding or removing this block or changing the `subnet_id` in an existing block forces a new resource to be created. Changing this forces a new resource to be created."
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
  default = null
}

variable "threat_intel_mode" {
  description = "The operation mode for threat intelligence-based filtering. Possible values are: `Off`, `Alert` and `Deny`. Defaults to `Alert`."
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.threat_intel_mode)
    error_message = "threat_intel_mode must contain either 'Off', 'Alert', or 'Deny'."
  }
}

variable "virtual_hub" {
  description = "Configuration to use a firewall with a Microsoft-managed Virtual Hub."
  type = object({
    virtual_hub_id  = string
    public_ip_count = optional(number, 1)
  })
  default = null
}

variable "zones" {
  description = "Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
