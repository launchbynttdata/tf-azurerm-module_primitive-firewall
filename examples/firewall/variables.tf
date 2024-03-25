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

//variables required by firewall module
variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "location" {
  description = "Azure region to use"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "logs_destinations_ids" {
  description = "List of destination resources IDs for logs diagnostic destination. Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set. If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character."
  type        = list(string)
  default     = []
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "subnet_cidr" {
  description = "The address prefix to use for the firewall's subnet"
  type        = string
}

variable "additional_public_ips" {
  type = list(object(
    {
      name                 = string,
      public_ip_address_id = string
  }))
  description = "List of additional public ips' ids to attach to the firewall."
  default     = []
}

variable "application_rule_collections" {
  type = list(object(
    {
      name     = string,
      priority = number,
      action   = string,
      rules = list(object(
        { name             = string,
          source_addresses = list(string),
          source_ip_groups = list(string),
          target_fqdns     = list(string),
          protocols = list(object(
            { port = string,
          type = string }))
        }
      ))
  }))
  description = "Create an application rule collection"
  default     = null
}

variable "custom_diagnostic_settings_name" {
  type        = string
  description = "Custom name of the diagnostics settings, name will be 'default' if not set."
  default     = "default"
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra tags to add"
  default     = {}
}

variable "firewall_private_ip_ranges" {
  type        = list(string)
  description = "A list of SNAT private CIDR IP ranges, or the special string `IANAPrivateRanges`, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  default     = ["IANAPrivateRanges"]
}

variable "network_rule_collections" {
  type = list(object({
    name     = string,
    priority = number,
    action   = string,
    rules = list(object({
      name                  = string,
      source_addresses      = list(string),
      source_ip_groups      = optional(list(string)),
      destination_ports     = list(string),
      destination_addresses = list(string),
      destination_ip_groups = optional(list(string)),
      destination_fqdns     = optional(list(string)),
      protocols             = list(string)
    }))
  }))
  description = "Create a network rule collection"
  default     = null
}


variable "public_ip_zones" {
  type        = list(number)
  description = "(Optional)Public IP zones to configure."
  default     = [1, 2, 3]
}

variable "sku_tier" {
  type        = string
  description = "SKU tier of the Firewall. Possible values are `Premium` and `Standard`"
  default     = "Standard"
}

variable "zones" {
  type        = list(number)
  description = "(Optional)Specifies a list of Availability Zones in which this Azure Firewall should be located. Changing this forces a new Azure Firewall to be created."
  default     = null
}

//variables required by resource names module
variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus2")
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
      region     = "eastus"
    }
    hub_vnet = {
      name       = "hubvnet"
      max_length = 80
      region     = "eastus"
    }
    firewall = {
      name       = "fw"
      max_length = 80
      region     = "eastus"
    }
    public_ip = {
      name       = "pip"
      max_length = 80
      region     = "eastus"
    }
    hub_vnet_ip_configuration = {
      name       = "ipconfig"
      max_length = 80
      region     = "eastus"
    }
  }
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  default     = "000"
  type        = string
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  default     = "000"
  type        = string
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "network"
}

//variables required by network module
variable "address_space" {
  description = "The address space that is used the virtual network."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "The address prefixes to use for the subnet."
  type        = list(string)
}

variable "bgp_community" {
  description = "The BGP community to use for the virtual network."
  type        = string
  default     = null
}

variable "ddos_protection_plan" {
  description = "The DDoS protection plan to associate with the virtual network."
  type = object(
    {
      enable = bool
      id     = string
    }
  )
  default = null
}

variable "nsg_ids" {
  description = "The IDs of the network security groups to associate with the subnet."
  type        = map(string)
  default     = {}
}

variable "route_tables_ids" {
  description = "The IDs of the route tables to associate with the subnet."
  type        = map(string)
  default     = {}
}

variable "subnet_delegation" {
  description = "The subnet delegation to associate with the subnet."
  type        = map(map(any))
  default     = {}
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  description = "Controls if private link endpoint network policies should be enforced on the subnet."
  type        = map(bool)
  default     = {}
}

variable "subnet_enforce_private_link_service_network_policies" {
  description = "Controls if private link service network policies should be enforced on the subnet."
  type        = map(bool)
  default     = {}
}

variable "subnet_service_endpoints" {
  description = "value of the service endpoints to associate with the subnet."
  type        = map(list(string))
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "tracing_tags_enabled" {
  description = "Controls if tracing tags should be enabled on the subnet."
  type        = bool
  default     = false
}

variable "tracing_tags_prefix" {
  description = "The prefix to use for the subnet tracing tag."
  type        = string
  default     = ""
}

variable "use_for_each" {
  description = "Controls if the subnet should be created for each."
  type        = bool
}
