import json
import os
import time

import boto3
from loguru import logger
from signal_handler import SignalHandler
from sqs_message import SQSMessage, SQSMessageBody

if __name__ == '__main__':
    # Create SQS client
    sqs = boto3.client('sqs')
    stepfunctions = boto3.client('stepfunctions')

    logger.info('Starting Simple Python Worker')
    queue_name = os.getenv(key='QUEUE_NAME', default='input-queue')
    logger.debug('QUEUE_NAME: {}'.format(queue_name))
    queue_url = sqs.get_queue_url(QueueName=queue_name)['QueueUrl']
    logger.debug('QUEUE_URL: {}'.format(queue_url))
    enable_wait_for_callback = os.getenv(
        key='ENABLE_WAIT_FOR_CALLBACK', default='false'
    ).lower() in ['true', '1', 'yes']
    logger.debug(
        'ENABLE_WAIT_FOR_CALLBACK: {}'.format(enable_wait_for_callback)
    )


    def process_message(message_body: SQSMessageBody):
        logger.debug(f'processing message: {message_body}')
        new_message = message_body.message + 'processed'

        if enable_wait_for_callback:
            task_token = message_body.taskToken
            if not task_token:
                raise Exception('Task token is required')
            stepfunctions.send_task_success(
                taskToken=task_token,
                output=json.dumps({
                    'status': 'success',
                    'message': f'{new_message}',
                }),
            )

            # if failure
            # stepfunctions.send_k_failure(
            #     taskToken=task_token,
            #     error=error,
            #     cause=cause
            # )


    def delete_message(receipt_handle):
        logger.debug(
            'Deleting message from queue, receipt_handle: {}'.format(
                receipt_handle
            )
        )
        # Delete the message
        sqs.delete_message(QueueUrl=queue_url, ReceiptHandle=receipt_handle)


    signal_handler = SignalHandler()

    while not signal_handler.received_signal:
        logger.info('Running loop for receive messages')
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
                    logger.debug('Received message: {}'.format(message))
                    sqs_message = SQSMessage(**message)
                    process_message(sqs_message.get_body_as_model())
                    delete_message(sqs_message.ReceiptHandle)
                except Exception as e:
                    logger.exception('Error processing message: {}'.format(e))
                    continue
