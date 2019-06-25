[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# The Basics

In this exercise we are simply going to create a resource group within Azure. While the steps we take to do this may seem like overkill they will lay the foundations for the rest of the lab environment we will create.

In this directory you will see a file named "main.tf".  Open "main.tf" as this will be where we add the providers and resources for this lab.

## Step 1 - Providers

Let's add the AzureRM resource provider of a specific version. To do this add the following to main.tf

```
provider "azurerm" {
  version = "~> 1.30.1"
}
```

When Terraform goes through the initialisation process it will now know to add this specific provider.

We also want to add the "random" provider, as we have already discussed this will allow us to ensure our resource names and endpoints are unique.

```
provider "random" {
  version = "~> 2.1"
}
```

## Step 2 - Resource Group

Now we have set up the providers we need, we will now create our resource group and link our random generator to it so we get a unique but consistent
value for the life span of our resource group.

While you could easily copy and paste the code example below trying typing it out and get a feel of the VSCode extensions.

```
resource "azurerm_resource_group" "lab" {
  name     = "lab-1-0"
  location = "northeurope"
}

resource "random_id" "lab" {
  keepers = {
    resource_group = "${azurerm_resource_group.lab.name}"
  }

  byte_length = 2
}
```

## Step 3 - Run Terraform

To run Terraform we will need to open the terminal so we can run it locally. To do this right click on the directory for this lab and then click "open in terminal"

### Login to Azure

In the terminal type in the below and hit enter.

```
az login
```

This will open up a browser window and ask you to login.

### Terraform init

Now we have logged into Azure we can now initialise Terraform locally.

```
terraform init
```

This will now look at what providers we are using and download them ready for us to use. You will now see under the lab directory a new folder called ".terraform" open it up and take a look.

### Terraform Apply

Run terraform apply as shown below.

```
terraform apply
```

This will now create a plan and show us the output of the plan. You can see that it shows it wants to create a single resource and not delete or change any, which is good. 

Type in "yes" and hit enter and it will go ahead and create the resource.

You will also now see that we now have a .tfstate while which has been created. Open it up and take a look. This file is where we store the current "known good" state of our environment.

### The results

Open up the portal and if everything worked as expected you will now have a new resource group in your subscription.

# Next Step
[1.1 Adding Resources](../1.1)
