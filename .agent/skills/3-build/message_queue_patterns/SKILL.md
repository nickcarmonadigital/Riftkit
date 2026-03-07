---
name: Message Queue Patterns
description: Message queues with RabbitMQ, SQS, and NATS covering pub/sub, fan-out, dead letter, and exactly-once patterns
---

# Message Queue Patterns Skill

**Purpose**: Design and implement message queue architectures using RabbitMQ, SQS, or NATS with proper patterns for pub/sub, fan-out, dead letter queues, and reliable message processing.

---

## TRIGGER COMMANDS

```text
"Set up a message queue"
"Implement pub/sub messaging"
"Configure dead letter queue"
"Choose a message broker"
"Using message_queue_patterns skill: [task]"
```

---

## Broker Comparison

| Feature | RabbitMQ | AWS SQS | NATS | Kafka |
|---------|----------|---------|------|-------|
| Protocol | AMQP 0-9-1 | HTTP/AWS SDK | NATS protocol | Kafka protocol |
| Delivery | Push (consumer) | Pull (poll) | Push (subscribe) | Pull (consumer) |
| Ordering | Per-queue (FIFO) | Best-effort (FIFO option) | Per-subject | Per-partition |
| Retention | Until consumed | 4d (configurable) | JetStream: configurable | Configurable |
| Throughput | 10K-50K msg/s | ~3K msg/s per queue | 10M+ msg/s | 100K-1M msg/s |
| Replay | No (consumed = gone) | No | JetStream: yes | Yes (offset) |
| Managed option | CloudAMQP, AmazonMQ | Native AWS | Synadia Cloud | Confluent, MSK |
| Best for | Complex routing | AWS serverless | Ultra-low latency | Event streaming |

### When to Use What

| Scenario | Recommended |
|----------|-------------|
| Task queue (background jobs) | RabbitMQ or SQS |
| Event streaming (replay needed) | Kafka or NATS JetStream |
| AWS serverless architecture | SQS + Lambda |
| Low-latency pub/sub | NATS |
| Complex routing (headers, topics) | RabbitMQ |
| Simple FIFO processing | SQS FIFO |

---

## Messaging Patterns

### Point-to-Point (Work Queue)

```
Producer ──> [Queue] ──> Consumer 1
                    ──> Consumer 2  (competing consumers)
                    ──> Consumer 3
```

Each message processed by exactly one consumer. Used for task distribution.

### Pub/Sub (Fan-Out)

```
Producer ──> [Exchange/Topic] ──> Queue A ──> Consumer A
                              ──> Queue B ──> Consumer B
                              ──> Queue C ──> Consumer C
```

Each message delivered to all subscribers. Used for event notification.

### Request/Reply

```
Client ──> [Request Queue] ──> Server
Client <── [Reply Queue]   <── Server
```

Synchronous-style communication over async transport.

### Dead Letter Queue

```
Producer ──> [Main Queue] ──> Consumer
                  |
                  | (failed after retries)
                  v
             [Dead Letter Queue] ──> DLQ Consumer (alert/investigate)
```

---

## RabbitMQ

### Connection and Channel Setup (Python)

```python
import pika
import json
from datetime import datetime

def get_connection():
    credentials = pika.PlainCredentials("user", "password")
    parameters = pika.ConnectionParameters(
        host="rabbitmq",
        port=5672,
        virtual_host="/",
        credentials=credentials,
        heartbeat=600,
        blocked_connection_timeout=300,
        connection_attempts=3,
        retry_delay=5,
    )
    return pika.BlockingConnection(parameters)
```

### Exchange Types

| Exchange | Routing | Use Case |
|----------|---------|----------|
| direct | Exact routing key match | Task routing by type |
| fanout | All bound queues | Broadcast events |
| topic | Pattern matching (*.error, order.#) | Flexible routing |
| headers | Header attribute matching | Complex filtering |

### Producer with Confirms

```python
def publish_event(exchange: str, routing_key: str, message: dict):
    connection = get_connection()
    channel = connection.channel()

    channel.confirm_delivery()

    channel.exchange_declare(
        exchange=exchange,
        exchange_type="topic",
        durable=True,
    )

    try:
        channel.basic_publish(
            exchange=exchange,
            routing_key=routing_key,
            body=json.dumps(message),
            properties=pika.BasicProperties(
                delivery_mode=2,          # Persistent
                content_type="application/json",
                message_id=str(uuid.uuid4()),
                timestamp=int(datetime.now().timestamp()),
                headers={"version": "1.0"},
            ),
            mandatory=True,
        )
    except pika.exceptions.UnroutableError:
        logger.error(f"Message unroutable: {routing_key}")
    finally:
        connection.close()
```

### Consumer with Manual Ack

```python
def consume_orders(callback):
    connection = get_connection()
    channel = connection.channel()

    # Declare exchange and queue
    channel.exchange_declare(exchange="orders", exchange_type="topic", durable=True)

    # Main queue with DLX
    channel.queue_declare(
        queue="order-processor",
        durable=True,
        arguments={
            "x-dead-letter-exchange": "orders-dlx",
            "x-dead-letter-routing-key": "order.failed",
            "x-message-ttl": 300000,       # 5 min TTL
            "x-max-length": 100000,        # Max queue length
            "x-overflow": "reject-publish", # Reject when full
        },
    )

    channel.queue_bind(
        queue="order-processor",
        exchange="orders",
        routing_key="order.created",
    )

    # DLQ
    channel.exchange_declare(exchange="orders-dlx", exchange_type="direct", durable=True)
    channel.queue_declare(queue="order-processor-dlq", durable=True)
    channel.queue_bind(
        queue="order-processor-dlq",
        exchange="orders-dlx",
        routing_key="order.failed",
    )

    # Prefetch: process one at a time
    channel.basic_qos(prefetch_count=10)

    def on_message(ch, method, properties, body):
        try:
            message = json.loads(body)
            callback(message)
            ch.basic_ack(delivery_tag=method.delivery_tag)
        except RetryableError:
            ch.basic_nack(delivery_tag=method.delivery_tag, requeue=True)
        except Exception as e:
            logger.error(f"Non-retryable error: {e}")
            ch.basic_nack(delivery_tag=method.delivery_tag, requeue=False)
            # Message goes to DLQ via dead-letter-exchange

    channel.basic_consume(queue="order-processor", on_message_callback=on_message)
    channel.start_consuming()
```

### RabbitMQ Topology Diagram

```
                    +------------------+
                    | Exchange: orders |
                    | Type: topic      |
                    +--------+---------+
                             |
              +--------------+--------------+
              |              |              |
         order.created  order.updated  order.cancelled
              |              |              |
    +---------+---+  +-------+----+  +------+------+
    | Q: processor|  | Q: notify  |  | Q: analytics|
    | (DLX config)|  | (fanout)   |  | (TTL: 24h)  |
    +------+------+  +------+-----+  +------+------+
           |                |                |
     Consumer Group    Email Service    Analytics
```

---

## AWS SQS

### Standard Queue

```python
import boto3
import json

sqs = boto3.client("sqs", region_name="us-east-1")

QUEUE_URL = "https://sqs.us-east-1.amazonaws.com/123456789/orders"

# Send message
def send_order_event(order: dict):
    response = sqs.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps(order),
        MessageAttributes={
            "EventType": {
                "StringValue": "OrderCreated",
                "DataType": "String",
            },
        },
        MessageDeduplicationId=order["id"],  # FIFO queues only
    )
    return response["MessageId"]

# Receive and process
def process_messages():
    while True:
        response = sqs.receive_message(
            QueueUrl=QUEUE_URL,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=20,         # Long polling
            VisibilityTimeout=300,      # 5 min processing window
            MessageAttributeNames=["All"],
        )

        for message in response.get("Messages", []):
            try:
                body = json.loads(message["Body"])
                process_order(body)
                sqs.delete_message(
                    QueueUrl=QUEUE_URL,
                    ReceiptHandle=message["ReceiptHandle"],
                )
            except Exception as e:
                logger.error(f"Failed to process: {e}")
                # Message becomes visible again after VisibilityTimeout
```

### SQS Dead Letter Queue (Terraform)

```hcl
resource "aws_sqs_queue" "orders" {
  name                       = "orders"
  visibility_timeout_seconds = 300
  message_retention_seconds  = 345600    # 4 days
  receive_wait_time_seconds  = 20        # Long polling
  max_message_size           = 262144    # 256 KB

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.orders_dlq.arn
    maxReceiveCount     = 3
  })

  tags = { Service = "orders" }
}

resource "aws_sqs_queue" "orders_dlq" {
  name                      = "orders-dlq"
  message_retention_seconds = 1209600   # 14 days

  tags = { Service = "orders", Type = "DLQ" }
}

resource "aws_sqs_queue_redrive_allow_policy" "orders_dlq" {
  queue_url = aws_sqs_queue.orders_dlq.id
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.orders.arn]
  })
}
```

### SQS + Lambda Trigger

```yaml
# serverless.yml
functions:
  processOrder:
    handler: src/handlers/orders.process
    events:
      - sqs:
          arn: !GetAtt OrdersQueue.Arn
          batchSize: 10
          maximumBatchingWindow: 30
          functionResponseType: ReportBatchItemFailures
```

---

## NATS

### Core NATS (Pub/Sub)

```python
import nats
import json

async def main():
    nc = await nats.connect("nats://nats:4222")

    # Publish
    await nc.publish(
        "orders.created",
        json.dumps({"id": "ord-123", "total": 99.99}).encode(),
    )

    # Subscribe
    async def handler(msg):
        data = json.loads(msg.data)
        print(f"Received order: {data['id']}")

    sub = await nc.subscribe("orders.*", cb=handler)

    # Queue group (competing consumers)
    sub = await nc.subscribe("orders.created", queue="processors", cb=handler)
```

### NATS JetStream (Persistence)

```python
async def jetstream_example():
    nc = await nats.connect("nats://nats:4222")
    js = nc.jetstream()

    # Create stream
    await js.add_stream(
        name="ORDERS",
        subjects=["orders.>"],
        retention="limits",
        max_msgs=1_000_000,
        max_bytes=1_073_741_824,  # 1 GB
        max_age=86400_000_000_000,  # 24 hours (nanoseconds)
        storage="file",
        num_replicas=3,
        discard="old",
    )

    # Create consumer
    await js.subscribe(
        "orders.created",
        durable="order-processor",
        deliver_policy="all",
        ack_policy="explicit",
        max_deliver=3,
        ack_wait=30,
    )
```

---

## Reliability Patterns

### Idempotent Consumer

```python
class IdempotentConsumer:
    def __init__(self, redis_client):
        self.redis = redis_client

    def process(self, message_id: str, handler):
        lock_key = f"processed:{message_id}"
        if self.redis.set(lock_key, "1", nx=True, ex=86400):
            try:
                handler()
            except Exception:
                self.redis.delete(lock_key)
                raise
        else:
            logger.info(f"Duplicate message skipped: {message_id}")
```

### Transactional Outbox

```
+------------------+     +------------------+     +------------------+
| Application      |     | Outbox Poller    |     | Message Broker   |
| (single DB tx)   |     | (CDC or poll)    |     |                  |
|                  |     |                  |     |                  |
| 1. INSERT order  |     | 3. Read outbox   |     | 4. Publish msg   |
| 2. INSERT outbox |---->| entries          |---->|                  |
|    (same tx)     |     | 5. Mark sent     |     |                  |
+------------------+     +------------------+     +------------------+
```

```python
# Transactional outbox pattern
def create_order(db, order_data: dict):
    with db.transaction():
        order = db.execute(
            "INSERT INTO orders (id, customer_id, total) VALUES (:id, :cid, :total) RETURNING *",
            order_data,
        )
        db.execute(
            """INSERT INTO outbox (id, aggregate_type, aggregate_id, event_type, payload)
            VALUES (:id, 'Order', :order_id, 'OrderCreated', :payload)""",
            {
                "id": str(uuid.uuid4()),
                "order_id": order["id"],
                "payload": json.dumps(order_data),
            },
        )
    return order
```

### Retry with Exponential Backoff

| Attempt | Delay | Total Wait |
|---------|-------|-----------|
| 1 | 1s | 1s |
| 2 | 2s | 3s |
| 3 | 4s | 7s |
| 4 | 8s | 15s |
| 5 | 16s | 31s |
| Max | 60s (capped) | varies |

---

## Monitoring

### Key Metrics

| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| Queue depth | > 1000 | > 10000 | Scale consumers |
| Consumer lag | Growing | > 5 min | Check consumer health |
| DLQ depth | > 0 | > 100 | Investigate failures |
| Publish rate | Spike > 2x | Sustained > 5x | Scale or rate-limit producers |
| Ack rate | < 90% | < 70% | Check consumer errors |
| Message age | > 5 min | > 30 min | Consumer bottleneck |

---

## Cross-References

- `3-build/kafka_event_streaming` - Kafka for event streaming (replay, high throughput)
- `3-build/caching_strategies` - Cache to reduce message volume
- `3-build/api_gateway_patterns` - Gateway can produce messages on behalf of clients

---

## EXIT CHECKLIST

- [ ] Broker selected based on requirements (latency, throughput, ordering, replay)
- [ ] Queues/topics declared as durable with appropriate retention
- [ ] Dead letter queue configured with maxReceiveCount/max_deliver
- [ ] Messages published with persistence (delivery_mode=2 / persistent)
- [ ] Consumers use manual acknowledgment (not auto-ack)
- [ ] Consumer implements idempotency (dedup by message ID)
- [ ] Prefetch/batch size tuned for throughput vs latency
- [ ] Transactional outbox used for DB + message atomicity
- [ ] Monitoring configured for queue depth, consumer lag, DLQ depth
- [ ] Retry policy with exponential backoff and max retries
- [ ] Connection pooling and heartbeats configured

---

*Skill Version: 1.0 | Created: March 2026*
