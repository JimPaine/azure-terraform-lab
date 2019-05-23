[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Variable Groups

A key part of Infra as Code is the part where we treat code as code. This includes storing the files in source control and build CI / CD pipelines from this. As we already have this stored in source control lets start with building pipelines.

## Step 1 - Create variable groups

Navigate to the dev.azure.com project you imported into earlier and open up the library as shown below.

![library](/docs/images/library.PNG)

Then add a new variable group

![add variable group](/docs/images/variablegroup.PNG)

And populate the name, select link from key vault and add the secrets we added earlier

![terraform client](/docs/images/TerraGroup.PNG)

## Step 2 - Add another variable group  

Add a second group in the same way this time, this time with the Terraform State.

## Ensure the Variable Groups are called "TerraformClient" and "TerraformState"

# Next Step
[5.1 CI / CD Pipeline](../5.1)
