require 'aws-sdk-sqs'

QUEUE_URL="http://localhost:4566/000000000000/example-events-queue"

client = Aws::SQS::Client.new(
    region: 'us-west-1',
    endpoint: 'http://localhost:4566',
    credentials: Aws::Credentials.new('your_access_key_id', 'your_secret_access_key')
)

client.send_message(
    queue_url: QUEUE_URL,
    message_body: "Test Message"
)