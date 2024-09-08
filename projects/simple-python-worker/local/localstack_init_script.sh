#!/bin/bash

# Create an SQS queue called input-queue
awslocal sqs create-queue --queue-name input-queue


awslocal sqs list-queues