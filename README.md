# Localstack Example

A very basic demonstration of using [localstack](https://github.com/localstack/localstack) to simulate SQS.

## Usage

Start SQS on localstack:
```
$ docker-compose start
```

Emit a test message using Ruby:
```
$ ruby producer.rb
```

Use the AWS CLI to pull the message from the queue:
```
bin/awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/example-events-queue
```