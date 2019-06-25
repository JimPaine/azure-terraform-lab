[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Deletions

Now we have seen how we can make changes to resources by adding items such as application settings to them and how when they are modified outside of Terraform we can still pick up the changes, lets take a look at what happens when we delete resources from Terraform.

## Step 1 - Initialise the current lab

```
terraform init
```

```
terraform apply
```

## Step 2 - Remove settings

So we know from the previous lab this is what our current function looks like:

```
resource "azurerm_function_app" "lab" {
  name                      = "lab${random_id.lab.dec}"
  location                  = "${azurerm_resource_group.lab.location}"
  resource_group_name       = "${azurerm_resource_group.lab.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.lab.id}"
  storage_connection_string = "${azurerm_storage_account.lab.primary_connection_string}"
  
  version = "~2"

  app_settings = {
    ABC = "XYZ"
  }
}
```

Lets remove the ABC setting and see how terraform handles this when we apply the change to the environment.

```
resource "azurerm_function_app" "lab" {
  
  ...

  app_settings = {
  }
}
```

When you have removed the setting run:

```
terraform apply
```

## Step 3 - Some changes cause deletions

So while the previous step deleted an applications setting it actually only modified our resource. It is important to understand that some changes will cause the resource to be re-created, meaning the existing one is deleted completly. Lets take a look at what this means.

Based on what our current function looks like lets change its name:

```
resource "azurerm_function_app" "lab" {
  name                      = "lab${random_id.lab.dec}demo"
  
  ...
}
```

Run apply and note the output of the plan

```
terraform apply
```


# Next Step
[1.4 Destroy](../1.4)