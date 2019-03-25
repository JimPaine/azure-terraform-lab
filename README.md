TODO: Banner

# Infra as Code Hands-on lab using Terraform

This session will provider an overview of the different options available for provisioning environments on Azure and the pros and cons of each. We will then work through a hands-on lab to create DevOps pipelines to maintain environments in Azure using Terraform.

## Introduction

- [Infra as Code Options](/docs/1.options.md)
- [Terraform overview](/docs/2.terraform-summary.md)

## Labs

- [Pre-reqs](/docs/3.prereqs.md)
- [Lab 1.0 - The Basics](/labs/1.0/README.md)
- [Lab 1.1 - Adding Resources](/labs/1.1/README.md)
- [Lab 1.2 - Not infra, but environment](/labs/1.2/README.md)
- [Lab 1.3 - Deletions](/labs/1.3/README.md)
- [Lab 1.4 - Destroy](/labs/1.4/README.md)

## Exercise 1.3.

Delete the "exercise-1-1.tf" file then run "apply", what will happen?

TODO: pic of delete and portal

## Exercise 1.4.

TODO: Destroy.

Exercise 2.0

Variables
Outputs
tfvars

Exercise 3.0

Setting up Azure

Service Principal
Backend.tf
Remote State
Subscription IAM

Exercise 3.1

Modify AzureRM Provider
push changes into GitHub
Source control benfits

Exercise 3.2

Pipieline
Variable groups
Queue

Exercise 4.0.

ARM within Terraform

Exercise 5.0.

Other resources, K8S? or an NVA?





The session will cover:
-	ARM vs Terraform vs Azure CLI and PowerShell
-	Running Terraform locally to provision resources
-	Using Terraform to modify resources and add new to existing
-	Using Terraform within Teams via GitHub
-	Azure DevOps Pipelines to run Terraform across environments
-	ARM resources within Terraform
-	Provisioning and configuring none Azure resources
