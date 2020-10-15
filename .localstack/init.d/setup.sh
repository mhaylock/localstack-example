#!/bin/sh

set -e # Exit immediately if something goes wrong

echo "Installing jq..."
apk update -q && apk add -q --no-cache jq

queue_name="example-events-queue"
dlq_queue_url=`awslocal sqs create-queue --queue-name $queue_name-dlq | jq -r .QueueUrl`
echo "Created DLQ: $dlq_queue_url"

dlq_queue_arn=`awslocal sqs get-queue-attributes --queue-url "$dlq_queue_url" | jq -r .Attributes.QueueArn`
redrive_policy=$(jq -n \
  --arg arn "$dlq_queue_arn" \
  '{
    deadLetterTargetArn: $arn,
    maxReceiveCount: "2"
  }'
)
queue_attributes=$(jq -n \
  --arg policy "$redrive_policy" \
  '{
    DelaySeconds: "5",
    VisibilityTimeout: "5",
    RedrivePolicy: $policy
  }'
)

queue_url=`awslocal sqs create-queue --queue-name $queue_name --attributes "$queue_attributes" | jq -r .QueueUrl`
echo "Created Queue: $queue_url"