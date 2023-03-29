#!/bin/bash

# Source the environment variables from .env file
if [ ! -f .env ]; then
  echo "Creating .env file..."
  read -p "Please enter the Confluent Cloud API Key: " TF_VAR_confluent_cloud_api_key
  read -p "Please enter the Confluent Cloud API Secret: " TF_VAR_confluent_cloud_api_secret

  echo "TF_VAR_confluent_cloud_api_key=${TF_VAR_confluent_cloud_api_key}" > .env
  echo "TF_VAR_confluent_cloud_api_secret=${TF_VAR_confluent_cloud_api_secret}" >> .env
else
  echo ".env file already exists. Proceeding with the existing values."
fi
source .env

# Export the environment variables
export TF_VAR_confluent_cloud_api_key
export TF_VAR_confluent_cloud_api_secret

# Run terraform init
echo "Running 'terraform init'..."
terraform init

# Run terraform apply with auto-approve flag
echo "Running 'terraform apply' with auto-approve..."
terraform apply -auto-approve

# Run terraform output command and store the result in a file
echo "Extracting resource IDs and saving to secrets.txt..."
terraform output -raw resource-ids > secrets.txt

echo "Script completed successfully."

