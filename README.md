# financial-data-analytics-demo
An interactive demo and workshop demonstrating real-time financial data analytics using Coinbase and CoinGecko APIs, Kafka on Confluent Cloud, ksqlDB, and dashboard visualizations with Imply. Explore use cases such as crypto arbitrage and volatility analysis in a hands-on environment.

## Prerequisites

1. **Install Git:** If Git is not already installed on your system, follow the instructions provided at [https://git-scm.com/book/en/v2/Getting-Started-Installing-Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

2. **Install Terraform:** If Terraform is not already installed on your system, download and install it from the official website: [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html).

3. **Install and start Docker:** If Docker is not already installed on your system or not running, follow the instructions provided at [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/) to install and start it.

---

## Project Setup

### Step 1: Create a Confluent Cloud account and generate API key and secret

1.1. Sign up for a Confluent Cloud account at [https://confluent.cloud/](https://confluent.cloud/).

1.2. Once logged in, navigate to the API Access section and create a new API key and secret. Make a note of these credentials, as you'll need them later.

### Step 2: Clone the GitHub repository

2.1. Open a terminal or command prompt and navigate to the desired directory for the Git repository.

2.2. Clone the repository:

```git clone https://github.com/jshashwat93/financial-data-analytics-demo.git```

2.3. Change the directory to the cloned repository:

```cd financial-data-analytics-demo/```

### Step 3: Set up the Confluent Cloud environment

Run the Confluent Cloud setup script:

```./terraform/setup-confluent-cloud.sh```


When prompted, enter the Confluent Cloud API key and secret generated in Step 1.

### Step 4: Build the Docker image

Build the Docker image for the project:

```docker build -t financial-data-analytics .```


### Step 5: Run the Docker image

Run the Docker image with the secrets file as an attached volume:

```
docker run -it --rm --name fdad-container -v $(pwd)/terraform/secrets.txt:/app/secrets.txt financial-data-analytics
```


---

## Cleaning up

**To stop the Docker image:**

Press Ctrl + C in the terminal where the Docker container is running.

**To tear down the Confluent Cloud environment:**

Run the following script and confirm by typing "yes" when prompted:

```./terraform/destroy-confluent-cloud.sh```


**To delete the Confluent Cloud API key and secret file:**

```rm -f terraform/.env```