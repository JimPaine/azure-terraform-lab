# Configuring Kubernetes

So one of the main advantages of using Terraform over ARM is that you can use it to work with a range of providers, rather than mixing and matching ARM templates with bash scripts. We have already been using the random provider to generate unique names for resources but now lets try and create a Kubernetes environment using a range of different providers.

## Step 1 - Adding the foundations

In the /env directory add the following resources to get us started.

- Resource group
- Random ID

You can leave the existing resources as these will get build out by our pipeline, along with the new ones.

## Step 2 - Add AKS

AKS is Azure managed Kubernetes cluster, this is great in that it takes away a lot of the difficulty of managing kubernetes but what it doesn't allow us to do are things such as:

- Generate the SSH keys for the Linux VMs in the same way the CLI does
- Create Kubernetes resources like, namespaces, secrets and service accounts.

So lets go a head an add in AKS.

```
resource "azurerm_kubernetes_cluster" "lab" {
  name                = "cluster${random_id.lab.dec}"
  location            = "${azurerm_resource_group.lab.location}"
  resource_group_name = "${azurerm_resource_group.lab.name}"
  dns_prefix          = "cluster${random_id.lab.dec}"

  # set the Linux profile details using the ssh key we just generated. 
  # Not that it should be used to access the VM directly, hence why I don't 
  # store it in Azure Key Vault
  linux_profile {
    admin_username = "clusteradmin"

    ssh_key {
      key_data = ""
    }
  }

  kubernetes_version = "1.13.5"

  agent_pool_profile {
    name            = "default"
    count           = 3
    vm_size         = "Standard_B2s"
    os_type         = "Linux"
    os_disk_size_gb = 30

    # Attach the AKS cluster to the subnet within the VNet we have created
    vnet_subnet_id = "${azurerm_subnet.lab.id}"
  }

  service_principal {
    client_id     = "${var.client-id}"
    client_secret = "${var.client-secret}"
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.2.2.254"
    service_cidr = "10.2.2.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  # Enabled RBAC
  role_based_access_control {
    enabled = true
  }
}
```

What you will notice in the ssh key block is that it is currently an empty string, so here comes the first new provider to help us out. Luckily there is a TLS provider which we can add in to generate the keys for us.

```
# Generate the SSH key that will be used for the Linux account on the worker nodes
resource "tls_private_key" "lab" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

You might also want to update the providers as well, this ensures a maintainer can clearly see which providers and which versions are required.

```
provider "tls" {
  version = "~> 1.2"
}
```

Now we have a resource which can generate SSH keys for us lets go ahead and set the ssh_key block.

```
ssh_key {
      key_data = "${tls_private_key.lab.public_key_openssh}"
    }
```

Push your changes in and lets watch the resource go through.

## Step 3 - Add the Kubernetes resources.

Take a look through the terraform documentation and see if you can add a new namespace to the cluster. You might want to do it in a new file, call it something like terraform.tf