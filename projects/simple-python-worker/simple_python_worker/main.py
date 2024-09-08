import boto3
from signal_handler import SignalHandler
from sqs_message import SQSMessage
import os

from loguru import logger

if __name__ == '__main__':
    # Create SQS client
    sqs = boto3.client('sqs')

    queue_name = os.getenv(key='QUEUE_NAME', default='input-queue')
    queue_url = sqs.get_queue_url(QueueName=queue_name)['QueueUrl']


    def process_message(message_body):
        print(f'processing message: {message_body}')


    def delete_message(receipt_handle):
        logger.debug('Deleting message from queue, receipt_handle: {}'.format(receipt_handle))
        # Delete the message
        sqs.delete_message(QueueUrl=queue_url, ReceiptHandle=receipt_handle)


    signal_handler = SignalHandler()

    while not signal_handler.received_signal:
        response = sqs.receive_message(
            QueueUrl=queue_url,
            AttributeNames=['SentTimestamp'],
            MaxNumberOfMessages=10,
            MessageAttributeNames=['All'],
            VisibilityTimeout=0,
            WaitTimeSeconds=10,
        )

        messages = response.get('Messages')
        if messages is not None:
            for message in messages:
                try:
                    logger.debug("Received message: {}".format(message))
                    sqs_message = SQSMessage(**message)
                    process_message(sqs_message.Body)
                    delete_message(sqs_message.ReceiptHandle)
                except Exception as e:
                    logger.exception('Error processing message: {}'.format(e))
                    continue
