[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Destroying an Environment

Another important benefit of Environment as Code is that we can tear environments down as quickly as we can spin them up. This is great for working with dev or test environments, being able to spin them up run our tests and destroying them as part of a repeatable process means we can a higher level of trust that the environment is common to previous runs and hasn't been modified between runs, as well as saving money as the environment is only around while we need it.

## Step 1 - Initialise the current lab

```
terraform init
```

```
terraform apply
```

## Step 2 - Destroy it!

Simply type into the terminal:

```
terraform destroy
```

# Next Step
[2.0 Variables](../2.0)