[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Modules

Modules are a way we can package up a directory, not only is this a great way to define and re-use terraform it is also a great way to structure files by creating an abstraction over multiple resources. Let's take our Azure Function we have been working with so far, to create the function we have needed the following

- Azure Service Plan
- Storage Account
- Azure Function

While this example there isn't that many dependent resources for something simple like a VM you would need more:

- VNet
- Subnet
- IP
- Nic
- VM
- Storage

## Step 1 - Creating a module

A module requires variables, outputs and resources and should be wrapped up in a directory with a README.md. Take a look in this lab directory, there is a sub-directory called "function" this module takes in some variables creates an Azure Function App along with all its dependencies and outputs some values.

## Step 2 - Using a module

To use a module we need to add a reference to it from our parent Terraform files. In the example below, you can see we create a reference to a module in a certain directory and set a variable value.

```
module "name" {
  source = "./dir"

  variable = value
}
```

Based on the syntax above modify the main.tf file in this lab to create a reference to the function module also in this lab. 

#### Hint

You may want to refer to the README.md within the module to understand what variables it requires.

## Step 3 - Initialise the environment

Using a terminal opened at the root of the lab directory, run the following.

```
terraform init
```

You'll notice now that the init stage also grabs the source for the referenced module.

![module init](/docs/images/module-init.PNG)

```
terraform apply
```

And though we only defined the resource group in our parent Terraform file it still picks up and creates all required resource

![module apply](/docs/images/module-apply.PNG)

## Step 4 - Outputs

From the previous run you will have spotted that the function hostname hasn't been output from the apply command. This is because the output is available to the parent but currently we have chosen to not output it from the parent. Lets fix this by adding an output.tf

In the output.tf file you just created add the following

```
output "hostname" {
    value = "${module.function.hostname}"
}
```

Now re-apply Terraform

```
terraform apply
```

While this shows you can output the outputs of a module what is also great is that it means we can use the outputs from one module as inputs to another, which really lets us get clever with the way we build out abstractions for resources in Azure.

# Next Step
[4.0 Silently run](../4.0)
