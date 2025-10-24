import pika
import os
import time

RABBITMQ_URL = os.getenv('RABBITMQ_URL', 'amqp://guest:guest@localhost:5672/%2F')
QUEUE_NAME = os.getenv('QUEUE_NAME', 'task_queue')
URL_PARAMS = pika.URLParameters(RABBITMQ_URL)

connection = pika.BlockingConnection(pika.URLParameters(RABBITMQ_URL))
channel = connection.channel()  
channel.queue_declare(queue=QUEUE_NAME, durable=True)

def received_msg(ch, method, properties, body):
    print(f" [x] Received {body.decode()}")
    time.sleep(2)
    print(" [x] Done")
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_qos(prefetch_count=1)
channel.basic_consume(queue=QUEUE_NAME, on_message_callback=received_msg)
print(' [*] Waiting for messages. To exit press CTRL+C')

channel.start_consuming()

