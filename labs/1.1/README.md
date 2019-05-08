[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Adding Resources

Now we have created a resource group lets take a look at adding some resources to it. For this portion of the lab we will look at using PaaS Services as this abstracts away a lot of the complexity in creating VNets, NICs and Subnets we would need in an IaaS world. Later examples will show working with these resources.

## Step 1 - Add an App Service Plan

You will notice, inside main.tf, I have already added the basics from the previous lab included to help us move forward quickly. So let's get started by adding the service plan. As mentioned in the previous lab type this out to get a feel for the VSCode extensions.

```
resource "azurerm_app_service_plan" "lab" {
  name                = "lab-plan"
  location            = "${azurerm_resource_group.lab.location}"
  resource_group_name = "${azurerm_resource_group.lab.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
```

The key things to notice here are we are using the "${}" syntax to reference other resources we have created, allowing us to re-use items such as the name and location of the resource group without using variables or having to manually re-construct them each time just as we do in ARM templates.

Now run:

```
terraform init
```

```
terraform apply
```

Refer to the first lab if you need help getting the apply to run.


## Step 2 - Adding additional to an existing environment.

Now we have an environment with a service plan in it, what we want to do now is add a resource without re-creating the environment. So let's do this by adding an Azure Function which uses our plan we just created.

As well as a plan a Function also needs a storage account so lets create both.

```
resource "azurerm_storage_account" "lab" {
  name                     = "lab${random_id.lab.dec}store"
  resource_group_name      = "${azurerm_resource_group.lab.name}"
  location                 = "${azurerm_resource_group.lab.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "lab" {
  name                      = "lab${random_id.lab.dec}"
  location                  = "${azurerm_resource_group.lab.location}"
  resource_group_name       = "${azurerm_resource_group.lab.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.lab.id}"
  storage_connection_string = "${azurerm_storage_account.lab.primary_connection_string}"
  
  version = "~2"
}
```

Once you have added both the storage account and the function re-run:

```
terraform apply
```

What you will notice this time is that we didn't run "terraform init" again. This is because we only need to run it when we initially want to run terraform and then every time we add or change a provider.

What is important this time is that you will spot the output of the plan shows it is going to create some resources and not touch the existing resources.

Open up the portal and validate everything has been created as you expect.

# Next Step
[1.2 Not infra, but environment](../1.2)
