[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Outputs

While you are able to use and reference attributes of resources directly or from the terraform state there are occasions when you will need to output specific values, these could be public endpoints or IP addresses.

## Step 1 - Adding an output

You will spot in this lab there is an "output.tf" file, like we discussed in the previous lab Terraform is great by allowing you to work and structure the files in the way that suits you and your team, so while you could put all the variables, resources and outputs in a single file I have found it is nice to be able to have a single file to reference when looking for the outputs.

The syntax for an output is structured like so:

```
output "name" {
    value = "${resourcetype.name.attribute}"
}
```
Based on this add an output which will output the hostname of the function app it will create. The attribute is called "default_hostname"

## Step 2 - Create the lab environment

Now apply the environment and spot the output.

```
terraform init
```

```
terraform apply -var-file="lab-2-1.tfvars"
```

Grab the output value and navigate to the hostname, which should take you to the current hosted function app.


# Next Step
[3.0 Modules](../3.0)