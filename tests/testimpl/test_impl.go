package common

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork/v5"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestFirewall(t *testing.T, ctx types.TestContext) {

	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionID) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID is not set in the environment variables ")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	clientFactory, err := armnetwork.NewClientFactory(subscriptionID, cred, nil)
	if err != nil {
		t.Fatalf("Unable to get clientFactory: %e\n", err)
	}

	// Get firewalls client
	firewallsClient := clientFactory.NewAzureFirewallsClient()

	// Get firewall IDs
	firewallIds := terraform.OutputMap(t, ctx.TerratestTerraformOptions(), "firewall_ids")

	// Run tests for each firewall ID
	for range firewallIds {
		t.Run("doesFirewallExist", func(t *testing.T) {
			// Get resource group name
			resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")

			// Get firewall names
			firewallNames := terraform.OutputMap(t, ctx.TerratestTerraformOptions(), "firewall_names")

			for _, firewallName := range firewallNames {
				inputFirewallName := strings.Trim(firewallName, "\"[]")
				t.Logf("Checking firewall: %s", inputFirewallName)

				firewallInstance, err := firewallsClient.Get(context.Background(), resourceGroupName, inputFirewallName, nil)
				if err != nil {
					t.Fatalf("Error getting firewall: %v", err)
				}
				t.Logf("Firewall Name: %s", *firewallInstance.Name)
				if firewallInstance.Name == nil {
					t.Fatalf("Firewall does not exist")
				}
				assert.Equal(t, strings.ToLower(inputFirewallName), strings.ToLower(*firewallInstance.Name))
				//assert.NotEmpty(t, (*firewallInstance.AzureFirewall.))
			}

		})
	}
}
