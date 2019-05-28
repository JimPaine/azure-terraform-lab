[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# CI / CD Pipeline

Now we have our Infra as Code stored in source control and secure variable groups sourced from key vault we will now build out our pipeline for our environment. This will be what we use to run and execute the Terraform just like we have been locally.

# Step 1 - Backend

We have already created a storage account to store the state for Terraform now we need to add a backend.tf file which configures Terraform to use our storage account.

On the root in the /env directory add a backend.tf file and add the below as its content.

```
terraform {
  backend "azurerm" {
    #example properties
    #resource_group_name  = ""
    #storage_account_name = ""
    #container_name       = ""
    #key                  = ""
    #access_key           = ""
  }
}
```

We can leave these items comennted out as what is important here is that Terraform is aware we want to use Azure as the backend, the rest of the items we will set when the pipeline is run.

## Step 2 - YAML Pipeline

You will notice on the root directory there is a "azure-pipelines.yml".  This file is picked up and used to define our Azure DevOps Pipeline. Let's take a look at what is is doing.

The first thing that is important here is that we are using the hosted Ubuntu image, this is key because this image is the one that has the terraform client install by default.

```
queue:
  name: Hosted Ubuntu 1604
```

Next, we tell the pipeline that we want to import the variable groups we created in the previous labs and add a specific key used to store the state as.

```
variables:
- group: 'TerraformClient'
- group: 'TerraformState'
- name: state-key
  value: 'jimpaine.azure-terraform-lab.master.tfstate'
```

Next we transform or .tfvars file with the values for this specific environment, this could be where you switch out values for dev and production.

```
- task: qetza.replacetokens.replacetokens-task.replacetokens@3
  displayName: 'Replace tokens in **/*.tfvars'

  inputs:
    rootDirectory: ./env
    targetFiles: '**/*.tfvars'
```

Now we can intiaialise Terraform. Take note that we are now passing in the values of the storage account we created in previous labs.

```
- script: |
   terraform init \
       -backend-config="resource_group_name=$(resource-group)" \
       -backend-config="storage_account_name=$(storage-account)" \
       -backend-config="container_name=$(container-name)" \
       -backend-config="key=$(state-key)" \
       -backend-config="access_key=$(access-key)"

  workingDirectory: ./env
  displayName: 'Terraform init'
```

And finally, we apply just like we have been so far.

```
- script: |
   terraform apply -auto-approve \
       -var-file="lab.tfvars"

  workingDirectory: ./env
  displayName: 'Terraform apply'
  ```

  ## Step 3 - Create the pipeline

  Switch back to Azure DevOps and this time select 
  
  Build Pipelines > New Build Pipeline > Repos

  Select the repo we have been working with and it should automatically pick up our build. 

  There is a known issue here which is that it will only let you run the build.

  ![run](/docs/images/yaml.PNG)

  Click run and the build will fail.

  ![fail](/docs/images/fail.PNG)

  Now we can go back edit the build and link in our Variable groups from before.

  ![link](/docs/images/edit.PNG)

  ![addgroups](/docs/images/addgroups.PNG)

  re-run the pipeline and it will now pass.

# Next Step
[6.0 Secure by default](../6.0)
