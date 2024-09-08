# Prerequisites (considering Linux platform - Ubuntu 22.04 LTS)
## Install aws cli2
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions

## Install terraform
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions

## setup aws credentials with default profile (This will need AWS access and secret key)
https://docs.aws.amazon.com/cli/latest/reference/configure/#examples

# Provision infra
## Terraform plan
```shell
cd scripts
./provision.sh plan
```

## Terraform apply
```shell
cd scripts
./provision.sh apply
```

## Terraform destroy
```shell
cd scripts
./provision.sh destroy
```

# TODO : 
1. We can store the terraform state to the s3 buckets
