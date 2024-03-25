package common

import (
	"context"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/lib/azure/configure"
	"github.com/launchbynttdata/lcaf-component-terratest/lib/azure/login"
	"github.com/launchbynttdata/lcaf-component-terratest/lib/azure/network"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

const terraformDir string = "../../examples/firewall"
const varFile string = "test.tfvars"

func TestFirewall(t *testing.T, ctx types.TestContext) {
	// Get environment variables
	envVarMap := login.GetEnvironmentVariables()
	clientID := envVarMap["clientID"]
	clientSecret := envVarMap["clientSecret"]
	tenantID := envVarMap["tenantID"]
	subscriptionID := envVarMap["subscriptionID"]

	// Get service principal token
	spt, err := login.GetServicePrincipalToken(clientID, clientSecret, tenantID)
	if err != nil {
		t.Fatalf("Error getting Service Principal Token: %v", err)
	}

	// Get firewalls client
	firewallsClient := network.GetFirewallsClient(spt, subscriptionID)

	// Configure Terraform
	terraformOptions := configure.ConfigureTerraform(terraformDir, []string{terraformDir + "/" + varFile})

	// Get firewall IDs
	firewallIds := terraform.OutputMap(t, ctx.TerratestTerraformOptions(), "firewall_ids")

	// Run tests for each firewall ID
	for range firewallIds {
		t.Run("doesfirewallExist", func(t *testing.T) {
			// Get resource group name
			resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")

			// Get firewall names
			firewallNames := terraform.OutputMap(t, terraformOptions, "firewall_names")

			for _, firewallName := range firewallNames {
				inputFirewallName := strings.Trim(firewallName, "\"[]")

				firewallInstance, err := firewallsClient.Get(context.Background(), resourceGroupName, inputFirewallName)
				if err != nil {
					t.Fatalf("Error getting firewall: %v", err)
				}
				if firewallInstance.Name == nil {
					t.Fatalf("Firewall does not exist")
				}
				assert.Equal(t, strings.ToLower(inputFirewallName), getFirewallName(strings.ToLower(*firewallInstance.Name)))
				assert.NotEmpty(t, (*firewallInstance.IPConfigurations))
			}

		})
	}
}

func getFirewallName(input string) string {
	parts := strings.Split(input, "/")
	return parts[len(parts)-1]
}
