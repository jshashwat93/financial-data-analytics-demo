# Use the latest stable Python image with a smaller footprint
FROM python:3.11.2

# Set the working directory to /app
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy Python scripts and entrypoint.sh
COPY src/kafka-producers/coinbase-btc.py src/kafka-producers/coingecko-btc.py ./
COPY entrypoint.sh ./

# Set the entry point script to run when the container starts
ENTRYPOINT ["./entrypoint.sh"]

