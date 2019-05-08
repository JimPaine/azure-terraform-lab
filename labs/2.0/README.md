[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Variables

A key part of making something re-usable across different environments and teams is to be able to inject different values in, such as names, locations and SKUs. If you look in this lab you will see we have a new empty file called "variables.tf". A great thing about Terraform is you can structure and name the files however you like and the Terraform executable will scan the directory and build the tree. 

For now we will add all the variables we need into the variable.tf file making it our single place to go to reference all of the required inputs to build our environment.

## Step 1 - Adding and using variables

To define a variable you can use the following syntax

```
variable "name" {
  type = "string"
  default = "ABC"
}
```

With this in mind add the following to variables.tf

| Name      | Type   | Default |
|:---------:|:------:|:-------:|
| sku-tier  | string |         |
| sku-size  | string |         |

To use the variables we need to use the following syntax:

```
resource "type" "name" {
    ...
    item = "${var.name}"
    ...
}
```

Using the above syntax update the Service plan in "main.tf" to use the variables you have declared by replacing the hard-coded strings.

## Step 2 - Run 

Once you have saved the changes from the previous step initialise and apply the environment

```
terraform init
```

```
terraform apply
```

What you will notice is that it prompts you for the values to use for the variables. While this is fine as we are running interactively. Go ahead and use the following values:

| Name      | Value      |
|:---------:|:----------:|
| sku-tier  | "Standard" |
| sku-size  | "S1"       |

## Step 3 - Re-run inline

While the previous step was great for running interactively most of the time we want to be able to run Terrafrom non-interactively, to do this we can run the apply like so:

```
terraform apply -var="sku-tier=Standard" -var="sku-size=S1"
```

Run the above apply command and while no changes will be made to the environment notice how it no longer prompts you for the variables.

## Step 4 - Working with lots of variables

What you will find pretty quickly when building out large environments is that injecting lots of variables into the command-line can get pretty messy. To improve on this we can use variable files. The extension for variable files in Terraform is ".tfvars"

Lets get started by adding a file to the current lab directory called "lab-2-0.tfvars"

The syntax for this file is: 

```
variable-name="variable-value"
```

Based on this go ahead and added the variables from the previous steps.

## Step 4 - Re-run with tfvars

Now we have created a variables file we can re-run our apply like so:

```
terraform apply -var-file="lab-2-0.tfvars"
```

Now when injecting a large number of values per environment we can simply do it with a single file per environment rather than each individually.

# Next Step
[2.1 Outputs](../2.1)
