[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Azure Function Terraform Module

This module wil create an Azure Function on a Consumption plan.

## Inputs

| Name                     | Type   | Example     |
|:------------------------:|:------:|:-----------:|
| resource_group_name      | string | lab         |
| resource_group_location  | string | northeurope |


## Outputs

| Name      | Type   | Example                             |
|:---------:|:------:|:-----------------------------------:|
| sku-tier  | string | https://lab.azurewebsites.net       |
