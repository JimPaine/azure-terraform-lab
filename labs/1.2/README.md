[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Not infra, but environment

So while the common term used for tooling like Terraform or ARM is Infra as Code it is important to understand that it's a lot more than creating VMs and networks. I personally refer to it as environment as code, mainly because it helps me visually it as something that also includes the setting of things like connections strings, secrets and stuff that people like myself (devs) tend to copy around and forget about. Being able to set things like application settings that are specific to the environment rather than the code also means there is less change and complexity when we run through the application life cycle. 

A good example of this would be a SQL connection string.  In production, its unlikely that the SQL connection string would need to change when the application gains new features and is actually dependant on the environment it lives in.

## Step 1 - Spin up the lab

Let's kick off by creating our environment for this lab.

```
terraform init
```

```
terraform apply
```

If you need some help with this step refer back to lab 1.0

## Step 2 - Add some config

Take a look at the main.tf file and you will see it is basically what we have created so far through the lab. So what we are going to do is add some application settings, showing that it isn't just about the underlying tin but also show how Terraform works with changes to resources.

This is what the current function looks like. 

```
resource "azurerm_function_app" "lab" {
  name                      = "lab${random_id.lab.dec}"
  location                  = "${azurerm_resource_group.lab.location}"
  resource_group_name       = "${azurerm_resource_group.lab.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.lab.id}"
  storage_connection_string = "${azurerm_storage_account.lab.primary_connection_string}"
  
  version = "~2"
}
```

Now update this resource to include some application settings

```
resource "azurerm_function_app" "lab" {
  
  ...  

  app_settings = {
      ABC = "XYZ"
  }
}
```

While this setting is a bit pointless as we move through the labs we will start to add things like SQL or CosmosDB in and this is exactly how it will be included in our resource. So let's go ahead and apply this change:

```
terraform apply
```

Take note of the plan output and the fact it highlights 1 resource will be changed.

## Step 3 - Validate the change.

Now Terraform has finished running open up the portal and validate that the application setting has been added and that this has all been down without an application even being written.

While we are here let's change this value to something else, say "123"

Now from the terminal re-run, what do you think will happen and why?

```
terraform apply
```

# Next Step
[1.3 Deletions](../1.3)
