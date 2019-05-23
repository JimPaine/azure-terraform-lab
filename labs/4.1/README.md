[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Remote state

As well as using a service principal to run Terraform, which allows us to run it in an automated fashion, we also need to store and manage the state in central place, which allows multiple people and or teams to work together across environments.

So before we create a way to store the state, let's update the Azure Provider to use the service principal from the previous lab.

## Step 1 - Running the Azure Provider with a service principal

To run the provider with the service principal we need to update the provider details in main.tf. Below is an example of what the provider should look like.

```
provider "azurerm" {
  version         = "1.23"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}
```

Update the main.tf file now and add the required variables to variables.tf and lab-4-1.tfvars.

Now provision the environment for this lab with

```
terraform init
```

```
terraform apply -var-file="lab-4-1.tfvars"
```

What this will do now is create a storage account and give our Terraform client access to the BLOB storage account.

## Step 2 - Let's take a look at what it has created for us.


# Next Step
[5.0 Variable Groups](../5.0)
