import pika
import os

# Environment variables (with defaults)
RABBITMQ_URL = os.getenv('RABBITMQ_URL', 'amqp://guest:guest@localhost:5672/')
QUEUE_NAME = os.getenv('QUEUE_NAME', 'default_queue')

# Parse RabbitMQ connection URL
url_params = pika.URLParameters(RABBITMQ_URL)
connection = pika.BlockingConnection(url_params)
channel = connection.channel()

# Declare the queue
channel.queue_declare(queue=QUEUE_NAME, durable=True)

# ✅ Use connection parameters for heartbeat instead of direct property
# (heartbeat must be set when creating connection)
# Example: pika.BlockingConnection(pika.ConnectionParameters(heartbeat=1000))

for i in range(100):
    message = f"Message {i + 1}"
    channel.basic_publish(
        exchange='',
        routing_key=QUEUE_NAME,
        body=message,
        properties=pika.BasicProperties(
            delivery_mode=2,  # make message persistent
        )
    )
    print(f"Sent: {message}")

# Clean up
channel.close()
connection.close()
