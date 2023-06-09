#!/bin/bash

# Check if we are already in the terraform directory by looking for main.tf
if [ ! -f main.tf ]; then
  # If main.tf is not found, change to the terraform directory
  cd terraform
fi

# Source the environment variables from .env file
if [ -f ".env" ]; then
  source .env
else
  # Ask for input values
  echo "Please enter the Confluent Cloud API Key:"
  read TF_VAR_confluent_cloud_api_key

  echo "Please enter the Confluent Cloud API Secret:"
  read TF_VAR_confluent_cloud_api_secret

  # Export the input values as environment variables
  export TF_VAR_confluent_cloud_api_key
  export TF_VAR_confluent_cloud_api_secret
fi

# Export the input values as environment variables
export TF_VAR_confluent_cloud_api_key
export TF_VAR_confluent_cloud_api_secret

# Run terraform destroy
echo "Running 'terraform destroy'..."
terraform destroy

rm -f secrets.txt
# Notify user to delete .env file when done

echo -e "\n\n\033[1;31m\033[7m⚠️ IMPORTANT WARNING ⚠️\033[0m\033[1;31m"
echo -e "\033[1;34mIf you are done with using Terraform for this demo, you should delete the \033[1;31m.env\033[1;34m file for security reasons. You can run \033[1;32mrm -f terraform/.env\033[1;34m to delete this file.\033[0m\n\n\n"

