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

1.2. Verify your email address by clicking on the verification link sent to your inbox.

1.3. Log in to your Confluent Cloud account.

1.4. Once logged in, follow these steps to create a new Confluent Cloud API key and secret:

- Click on the hamburger menu in the upper-left corner of the dashboard.
- Select "Cloud API keys" from the menu.
- Click on the "+ Add key" button.
- Click on "Global access."
- Enter a description for the key (optional), and click on the "Download and continue" button.
- Ensure you securely store the downloaded file, as the key and secret are displayed only once during creation. You will need the generated API key and secret for later steps in the project.

Now you have a Confluent Cloud API key and secret that you can use in your project.

### Step 2: Clone the GitHub repository

2.1. Open a terminal or command prompt and navigate to the desired directory for the Git repository.

2.2. Clone the repository:

```
git clone https://github.com/jshashwat93/financial-data-analytics-demo.git
```

2.3. Change the directory to the cloned repository:

```
cd financial-data-analytics-demo/
```

### Step 3: Set up the Confluent Cloud environment

Run the Confluent Cloud setup script:

```
./terraform/setup-confluent-cloud.sh
```


When prompted, enter the Confluent Cloud API key and secret generated in Step 1.

### Step 4: Build the Docker image

Build the Docker image for the project:

```
docker build -t financial-data-analytics .
```


### Step 5: Run the Docker image

Run the Docker image with the secrets file as an attached volume:

```
docker run -it --rm --name fdad-container -v $(pwd)/terraform/secrets.txt:/app/secrets.txt financial-data-analytics
```

### Step 6: Run the streaming applications on ksqlDB

While the Docker container is running in the current terminal session, open a new terminal window or tab to run the streaming applications without stopping the container.

Follow these steps:

1. Open a new terminal window or tab.
2. Navigate to the project directory if you are not already there.
3. Execute the script by running the following command:

```
./start-streaming-applications.sh
```


---

## Cleaning up

**To stop the Docker image:**

Press Ctrl + C in the terminal where the Docker container is running.

**To tear down the Confluent Cloud environment:**

Run the following script and confirm by typing "yes" when prompted:

```
./terraform/destroy-confluent-cloud.sh
```


**To delete the Confluent Cloud API key and secret file:**

```
rm -f terraform/.env
```