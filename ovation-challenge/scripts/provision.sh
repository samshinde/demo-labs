#!/bin/bash

exists()
{
  command -v "$1" >/dev/null 2>&1
}

echo "Checking pre-requisites"
echo "============================="
# Install unzip
if exists unzip; then
    echo "unzip found"
else
    sudo apt update -y
    sudo apt install -y unzip
fi

# Install wget
if exists wget; then
    echo "wget found"
else
    sudo apt update -y
    sudo apt install -y wget
fi

# Install AWS CLI
if exists aws; then
    echo "aws cli found"
    aws --version
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Install lastest terraform
if exists terraform; then
    echo "terraform found"
    terraform --version
else
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
fi
echo "============================="
echo "Provisioning................."
echo "============================="

# Handling arguments passed to the script
case "$1" in
  plan)
    cd ../modules
    terraform init
    terraform plan -out=plan
    ;;
  apply)
    cd ../modules
    terraform plan -out=plan -refresh=false
    terraform apply -auto-approve plan
    ;;
  destroy)
    cd ../modules
    terraform plan -out=plan -destroy -refresh=false
    terraform apply -auto-approve plan
    ;;
  *)
    echo "./provision.sh <argument>"
    echo "Invalid argument. Use one of: plan, apply, destroy."
    echo "============================="
    exit 1
    ;;
esac
echo "============================="