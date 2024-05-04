//variables for firewall module
environment           = "demo"
client_name           = "launch"
location              = "East US 2"
location_short        = "eastus2"
logs_destinations_ids = []
stack                 = ""
subnet_cidr           = "10.0.1.0/24"
application_rule_collections = [{
  action   = "Allow"
  name     = "app_rule_collection"
  priority = 100
  rules = [{
    name = "allow_https"
    protocols = [{
      port = "443"
      type = "Https"
    }]
    source_addresses = ["10.0.0.0/16"]
    source_ip_groups = []
    target_fqdns     = ["*.google.com"]
  }]
}]
network_rule_collections = [{
  name     = "network_rule_collection"
  priority = 100
  action   = "Allow"
  rules = [{
    name              = "network_rule"
    source_addresses  = ["10.0.0.0/16"]
    destination_ports = ["53"]
    destination_addresses = [
      "8.8.8.8",
      "8.8.4.4",
    ]
    protocols = [
      "TCP",
      "UDP",
    ]
  }]
}]
//variables for network module
address_space   = ["10.0.0.0/16"]
subnet_prefixes = []
subnet_names    = []
use_for_each    = true
