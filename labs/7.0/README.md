# Using ARM to plug the gaps

So in the overview at the start we mentioned that a negative of Terraform over say over providers, is that it is behind in terms of available resources. This is partly due to a few different reasons.

To work around these gaps Terraform providers a specific resource "azurerm_template_deployment"

```
resource "azurerm_template_deployment" "lab" {
  name                = "ardemo${random_id.lab.dec}"
  resource_group_name = "${azurerm_resource_group.lab.name}"

  template_body = <<ARM
  ARM

  parameters {
  }

  deployment_mode = "Incremental"
}
```

The great thing about this resource is, that it allows us to still build a tree around the resources in the template. Meaning we can create resources dependent on other resources Terraform has created and then use the output from the template to help create other resources Terraform owns, which is great as Terraform still builds and manages the dependency tree. What it isn't great at doing is managing the resources and the state within the template.

While this is a work around and should be used as little as possible, it is much better than saying building the entire environment via ARM templates.

For a live example take a look at: https://github.com/jimpaine/emotion-checker this demo uses terraform to do the majority of the environment and then uses ARM within Terraform to handle the binding of the custom domain name and the certificate.

## Step 1 - So lets give it a go.

Add a file called arm.tf to the /env directory with the following content to the template_body argument. Not the "<<" syntax this allows us to put something like json in over multiple lines and not worry about encoding or escaping the "s.

```
{
    "$schema": "http://schemas.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "resourceName": {
            "type": "string",
            "metadata": {
                "description": "Resource name and prefix for all resources"
            }
        },
        "storageAccountName": {
            "type: "string"
        },
        "location" : {
            "type": "string"
        },
        "planName": {
            "type: "string"
        }
    },
    "resources": [
        {
            "type": "Microsoft.Storage/storageAccounts",
            "name": "[parameters('storageAccountName')]",
            "apiVersion": "2018-07-01",
            "location": "[parameters('location')]",
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "kind": "Storage"
        },       
        {
            "type": "Microsoft.Web/serverfarms",
            "apiVersion": "2016-09-01",
            "name": "[parameters('planName')]",
            "location": "[resourceGroup().location]",
            "sku": {
                "name": "Y1",
                "tier": "Dynamic",
                "size": "Y1",
                "family": "Y",
                "capacity": 0
            },
            "properties": {
                "name": "[parameters('planName')]"
            }
        }
    ]
}
```

## Step 2 - Setting the parameters.

So now we have added the resources via an ARM template within Terraform, we now need to set the parameters required to run the template.

Take a look through the template and add the paramaters as shown below. Keep in mind you may want to use the random provider to ensure the names are unique!

```
resource "azurerm_template_deployment" "lab" {
  name                = "ardemo${random_id.lab.dec}"
  resource_group_name = "${azurerm_resource_group.lab.name}"

  template_body = <<ARM
  {
      ...
  }
  ARM

  parameters {
      key0 = "value"
      key1 = "value"
      key2 = "$(some_terraform_resource.value)"
  }

  deployment_mode = "Incremental"
}
```

## Step 3 - Run it and see!

Now let's push the changes into our git repo and take a look at the environment via the portal!