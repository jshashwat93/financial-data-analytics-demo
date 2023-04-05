#!/bin/bash

# Check if we are already in the terraform directory by looking for main.tf
if [ ! -f main.tf ]; then
  # If main.tf is not found, change to the terraform directory
  cd terraform
fi

# Source the environment variables from .env file
if [ ! -f .env ]; then
  echo "Creating .env file..."
  read -p "Please enter the Confluent Cloud API Key: " TF_VAR_confluent_cloud_api_key
  read -s -p "Please enter the Confluent Cloud API Secret: " TF_VAR_confluent_cloud_api_secret

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

# Add three blank lines
echo -e "\n\n\n"

ksqlDB_url="https://confluent.cloud/environments/$(terraform output -raw confluent_environment_id)/clusters/$(terraform output -raw confluent_kafka_cluster_id)/ksql"

# Print the message with colors
echo -e "\033[1;34mScript completed successfully. It may take 1-2 minutes for your ksqlDB cluster's metadata to sync with your Confluent Cloud cluster.\033[0m"
echo -e "\033[1;34mTo check if your ksqlDB cluster is ready, you should be able to click into and open your ksqlDB cluster called \033[1;33mStreamingApplication\033[1;34m by going to the following URL on your web browser:\033[0m"
echo -e "\033[1;36m${ksqlDB_url}\033[0m"

