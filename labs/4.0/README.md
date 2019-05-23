[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Service Principal

In this lab we will create a Service Prinicpal which we will use for further labs. The importance is why we use a service principal and not in how it is created so we have already written the Terraform to create a Service Principal in the Azure AD tenant, give it access to the Azure Subscription we are working against and add the credentials into an Azure Key Vault for our CI / CD pipelines later on.

## Step 1 - Create the Service Prinicipal

```
terraform init
```

```
terraform apply -var="user=[azurelogin@email.com]"
```

So let's take a look through so we understand what it is doing.

## Step 2 - Azure AD provider

If you take a look in the main.tf file you will notice we are using a new provider called "AzureAD" This provider allows us to work with Azure AD without a need to use or understand subscriptions or resource groups. You can then see from this provider we create a few resources.

Firstly we create an Azure application, this is needed as it is what we will use when we want to authenticate and for setting RBAC permissions against subscriptions and resources. We have to set a few core items that we won't be using but because the application can also be used for user flows and app to app authentications items like the URIs are required.

```
resource "azuread_application" "lab" {
  name                       = "terraclient"
  homepage                   = "https://homepage"
  identifier_uris            = ["https://uri"]
  reply_urls                 = ["https://uri"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}
```

Next we wrap this up in a service prinicipal. This is all a little messy from an Azure AD perspective but we need to do this to assign credtentials such as a secret to our application. So we simply wrap the application in a service principal at this point.

```
resource "azuread_service_principal" "lab" {
  application_id = "${azuread_application.lab.application_id}"
}
```

Because everything we do we want to be secure we generate a random password to use with our new service prinicpal, ideally we would then put this only into Key Vault but for the purpose of the lab we will also output it.

```
resource "random_string" "lab" {
  length  = "32"
  special = true
}
```

And finally, we set the password of our service prinicpal with the randomly generated password.

```
resource "azuread_service_principal_password" "lab" {
  service_principal_id = "${azuread_service_principal.lab.id}"
  value                = "${random_string.lab.result}"
  end_date             = "2020-01-01T01:02:03Z"
}
```

# Next Step
[4.1 Shared state](../4.1)
