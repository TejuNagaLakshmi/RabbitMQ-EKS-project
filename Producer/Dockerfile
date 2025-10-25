# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the producer script into the container
COPY producer.py .

# Environment variables with default values
ENV RABBITMQ_URL=amqp://guest:guest@rabbitmq:5672/
ENV QUEUE_NAME=default_queue

# Run producer.py when the container launches
CMD ["python", "producer.py"]
