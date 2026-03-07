---
name: Kafka Event Streaming
description: Apache Kafka topics, partitions, consumer groups, schemas, exactly-once semantics, Kafka Connect, and Kafka Streams
---

# Kafka Event Streaming Skill

**Purpose**: Design and operate Apache Kafka-based event streaming systems with proper topic design, schema management, consumer group patterns, exactly-once processing, and connector pipelines.

---

## TRIGGER COMMANDS

```text
"Set up Kafka topics"
"Design event streaming architecture"
"Configure Kafka consumers"
"Implement event-driven messaging with Kafka"
"Using kafka_event_streaming skill: [task]"
```

---

## Architecture Overview

```
+-------------+     +-----------+     +--------------+
| Producers   |---->| Kafka     |---->| Consumers    |
| (apps, CDC) |     | Cluster   |     | (apps, sink) |
+-------------+     +-----------+     +--------------+
                         |
                    +----+----+
                    | Schema  |
                    | Registry|
                    +---------+

Kafka Cluster:
  Broker 1: [P0] [P2-replica]
  Broker 2: [P1] [P0-replica]
  Broker 3: [P2] [P1-replica]
```

---

## Topic Design

### Naming Convention

```
<domain>.<entity>.<event-type>

Examples:
  orders.order.created
  payments.payment.completed
  users.profile.updated
  inventory.stock.adjusted
  analytics.pageview.tracked
```

### Topic Configuration

```bash
# Create topic with production settings
kafka-topics.sh --bootstrap-server kafka:9092 --create \
  --topic orders.order.created \
  --partitions 12 \
  --replication-factor 3 \
  --config retention.ms=604800000 \
  --config cleanup.policy=delete \
  --config min.insync.replicas=2 \
  --config compression.type=zstd \
  --config max.message.bytes=1048576

# Compacted topic (latest state per key)
kafka-topics.sh --bootstrap-server kafka:9092 --create \
  --topic users.profile.snapshot \
  --partitions 12 \
  --replication-factor 3 \
  --config cleanup.policy=compact \
  --config min.compaction.lag.ms=3600000 \
  --config delete.retention.ms=86400000
```

### Partition Count Guidelines

| Messages/sec | Consumers | Recommended Partitions |
|-------------|-----------|----------------------|
| < 1K | 1-3 | 6 |
| 1K-10K | 3-6 | 12 |
| 10K-100K | 6-12 | 24-36 |
| 100K+ | 12+ | 48-64 |

> **Tip**: Partitions can only be increased, never decreased. Start conservatively but leave room for growth. Partition count should be >= max consumer count.

### Cleanup Policy Decision

| Policy | Use Case | Key Required | Retention |
|--------|----------|-------------|-----------|
| delete | Events, logs, analytics | No | Time or size based |
| compact | State snapshots, configs | Yes | Latest per key |
| compact,delete | Compacted with expiry | Yes | Compact + time limit |

---

## Producer Configuration

### Java/Spring Producer

```java
@Configuration
public class KafkaProducerConfig {

    @Bean
    public ProducerFactory<String, Object> producerFactory() {
        Map<String, Object> config = new HashMap<>();
        config.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:9092");
        config.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        config.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
            KafkaAvroSerializer.class);
        // Exactly-once
        config.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, true);
        config.put(ProducerConfig.ACKS_CONFIG, "all");
        config.put(ProducerConfig.RETRIES_CONFIG, Integer.MAX_VALUE);
        config.put(ProducerConfig.MAX_IN_FLIGHT_REQUESTS_PER_CONNECTION, 5);
        // Performance
        config.put(ProducerConfig.BATCH_SIZE_CONFIG, 16384);
        config.put(ProducerConfig.LINGER_MS_CONFIG, 10);
        config.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "zstd");
        // Schema Registry
        config.put("schema.registry.url", "http://schema-registry:8081");
        return new DefaultKafkaProducerFactory<>(config);
    }
}
```

### Producer Reliability Matrix

| Setting | At-Most-Once | At-Least-Once | Exactly-Once |
|---------|-------------|---------------|-------------|
| acks | 0 | 1 or all | all |
| retries | 0 | > 0 | MAX_VALUE |
| idempotence | false | false | true |
| max.in.flight | any | any | <= 5 |
| transactional.id | none | none | set |

### Python Producer (confluent-kafka)

```python
from confluent_kafka import Producer
from confluent_kafka.serialization import SerializationContext, MessageField
from confluent_kafka.schema_registry.avro import AvroSerializer

producer_config = {
    "bootstrap.servers": "kafka:9092",
    "acks": "all",
    "enable.idempotence": True,
    "compression.type": "zstd",
    "linger.ms": 10,
    "batch.size": 16384,
}

producer = Producer(producer_config)

def delivery_callback(err, msg):
    if err:
        logger.error(f"Delivery failed: {err}")
    else:
        logger.info(f"Delivered to {msg.topic()}[{msg.partition()}] @ {msg.offset()}")

def publish_order_event(order):
    producer.produce(
        topic="orders.order.created",
        key=str(order["id"]),
        value=avro_serializer(order, SerializationContext("orders.order.created",
            MessageField.VALUE)),
        callback=delivery_callback,
    )
    producer.flush()
```

---

## Consumer Configuration

### Consumer Group Pattern

```
Topic: orders.order.created (12 partitions)

Consumer Group: order-processor
  Consumer 1: [P0, P1, P2, P3]
  Consumer 2: [P4, P5, P6, P7]
  Consumer 3: [P8, P9, P10, P11]

Consumer Group: analytics-tracker (independent)
  Consumer 1: [P0-P11]  (single consumer reads all)
```

### Java Consumer with Error Handling

```java
@KafkaListener(
    topics = "orders.order.created",
    groupId = "order-processor",
    containerFactory = "kafkaListenerContainerFactory"
)
public void processOrder(
    @Payload OrderCreatedEvent event,
    @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
    @Header(KafkaHeaders.OFFSET) long offset,
    Acknowledgment ack
) {
    try {
        orderService.process(event);
        ack.acknowledge();
    } catch (RetryableException e) {
        throw e;  // Spring Retry handles
    } catch (Exception e) {
        log.error("Non-retryable error at partition={} offset={}", partition, offset, e);
        deadLetterPublisher.send("orders.order.created.DLT", event);
        ack.acknowledge();
    }
}
```

### Consumer Configuration

```java
@Bean
public ConsumerFactory<String, Object> consumerFactory() {
    Map<String, Object> config = new HashMap<>();
    config.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:9092");
    config.put(ConsumerConfig.GROUP_ID_CONFIG, "order-processor");
    config.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
    config.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, false);
    config.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 100);
    config.put(ConsumerConfig.MAX_POLL_INTERVAL_MS_CONFIG, 300000);
    config.put(ConsumerConfig.SESSION_TIMEOUT_MS_CONFIG, 30000);
    config.put(ConsumerConfig.HEARTBEAT_INTERVAL_MS_CONFIG, 10000);
    config.put(ConsumerConfig.ISOLATION_LEVEL_CONFIG, "read_committed");
    return new DefaultKafkaConsumerFactory<>(config);
}
```

---

## Schema Management

### Avro Schema Example

```json
{
  "type": "record",
  "name": "OrderCreatedEvent",
  "namespace": "com.example.orders.events",
  "fields": [
    {"name": "orderId", "type": "string"},
    {"name": "customerId", "type": "string"},
    {"name": "totalAmount", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 10, "scale": 2}},
    {"name": "currency", "type": "string", "default": "USD"},
    {"name": "items", "type": {"type": "array", "items": {
      "type": "record", "name": "OrderItem", "fields": [
        {"name": "productId", "type": "string"},
        {"name": "quantity", "type": "int"},
        {"name": "unitPrice", "type": {"type": "bytes", "logicalType": "decimal",
          "precision": 10, "scale": 2}}
      ]
    }}},
    {"name": "createdAt", "type": {"type": "long", "logicalType": "timestamp-millis"}},
    {"name": "metadata", "type": ["null", {"type": "map", "values": "string"}],
      "default": null}
  ]
}
```

### Schema Compatibility Modes

| Mode | Add Field | Remove Field | Use Case |
|------|-----------|-------------|----------|
| BACKWARD | With default | Yes | Consumer-first (default) |
| FORWARD | Yes | With default | Producer-first |
| FULL | With default | With default | Strictest, bidirectional |
| NONE | Any | Any | Dev only, no guarantees |

```bash
# Set compatibility mode
curl -X PUT http://schema-registry:8081/config/orders.order.created-value \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d '{"compatibility": "BACKWARD"}'

# Test compatibility
curl -X POST http://schema-registry:8081/compatibility/subjects/orders.order.created-value/versions/latest \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d @new-schema.json
```

### Protobuf Alternative

```protobuf
syntax = "proto3";
package com.example.orders.events;

message OrderCreatedEvent {
  string order_id = 1;
  string customer_id = 2;
  int64 total_amount_cents = 3;
  string currency = 4;
  repeated OrderItem items = 5;
  int64 created_at_millis = 6;
  map<string, string> metadata = 7;
}

message OrderItem {
  string product_id = 1;
  int32 quantity = 2;
  int64 unit_price_cents = 3;
}
```

---

## Exactly-Once Semantics

### Transactional Producer + Consumer

```java
// Producer with transactions
@Bean
public KafkaTransactionManager<String, Object> kafkaTransactionManager(
    ProducerFactory<String, Object> factory) {
    return new KafkaTransactionManager<>(factory);
}

// Produce within transaction
kafkaTemplate.executeInTransaction(ops -> {
    ops.send("orders.order.created", orderId, event);
    ops.send("inventory.stock.reserved", orderId, reserveEvent);
    return null;
});
```

### Idempotent Consumer Pattern

```java
public void processOrder(OrderCreatedEvent event, long offset, int partition) {
    String idempotencyKey = partition + "-" + offset;
    if (processedOffsets.contains(idempotencyKey)) {
        log.info("Skipping duplicate: {}", idempotencyKey);
        return;
    }
    orderService.process(event);
    processedOffsets.add(idempotencyKey);
}
```

---

## Kafka Connect

### Debezium CDC Source (PostgreSQL)

```json
{
  "name": "postgres-source",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "debezium",
    "database.password": "${secrets:postgres-password}",
    "database.dbname": "orders",
    "topic.prefix": "cdc.orders",
    "schema.include.list": "public",
    "table.include.list": "public.orders,public.order_items",
    "slot.name": "debezium_orders",
    "plugin.name": "pgoutput",
    "publication.name": "dbz_publication",
    "transforms": "route",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.route.regex": "cdc\\.orders\\.public\\.(.*)",
    "transforms.route.replacement": "orders.$1.changed",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter.schema.registry.url": "http://schema-registry:8081"
  }
}
```

### Elasticsearch Sink

```json
{
  "name": "elasticsearch-sink",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "topics": "orders.order.created",
    "connection.url": "http://elasticsearch:9200",
    "type.name": "_doc",
    "key.ignore": false,
    "schema.ignore": true,
    "behavior.on.malformed.documents": "warn",
    "write.method": "upsert",
    "batch.size": 200,
    "max.retries": 5,
    "retry.backoff.ms": 1000
  }
}
```

---

## Kafka Streams

### Stream Processing Topology

```java
StreamsBuilder builder = new StreamsBuilder();

KStream<String, OrderCreatedEvent> orders = builder.stream("orders.order.created");

// Filter, transform, and write to new topic
orders
    .filter((key, order) -> order.getTotalAmount() > 100_00)
    .mapValues(order -> EnrichmentService.enrich(order))
    .to("orders.order.enriched");

// Windowed aggregation
KTable<Windowed<String>, Long> orderCounts = orders
    .groupBy((key, order) -> order.getCustomerId())
    .windowedBy(TimeWindows.ofSizeWithNoGrace(Duration.ofMinutes(5)))
    .count(Materialized.as("order-counts-store"));

// Join streams
KStream<String, PaymentEvent> payments = builder.stream("payments.payment.completed");

KStream<String, OrderWithPayment> enriched = orders.join(
    payments,
    (order, payment) -> new OrderWithPayment(order, payment),
    JoinWindows.ofTimeDifferenceWithNoGrace(Duration.ofMinutes(10)),
    StreamJoined.with(Serdes.String(), orderSerde, paymentSerde)
);
```

---

## Monitoring

### Key Metrics

| Metric | Alert Threshold | Meaning |
|--------|----------------|---------|
| Consumer lag | > 10K messages | Consumer falling behind |
| Under-replicated partitions | > 0 | Broker health issue |
| ISR shrink rate | > 0/min sustained | Replication problems |
| Request latency p99 | > 100ms | Broker overload |
| Active controller count | != 1 | Leadership election issue |
| Offline partitions | > 0 | Data unavailable |

```bash
# Check consumer lag
kafka-consumer-groups.sh --bootstrap-server kafka:9092 \
  --describe --group order-processor

# List under-replicated partitions
kafka-topics.sh --bootstrap-server kafka:9092 \
  --describe --under-replicated-partitions
```

---

## Cross-References

- `3-build/message_queue_patterns` - Compare Kafka with RabbitMQ, SQS, NATS
- `3-build/service_mesh_patterns` - Network-level concerns for Kafka traffic
- `3-build/log_aggregation_pipeline` - Kafka as log transport

---

## EXIT CHECKLIST

- [ ] Topic naming follows domain.entity.event convention
- [ ] Partition count matches expected throughput and consumer parallelism
- [ ] Replication factor >= 3 with min.insync.replicas = 2
- [ ] Schema registered in Schema Registry with compatibility mode set
- [ ] Producer configured with acks=all and idempotence enabled
- [ ] Consumer group offsets committed manually (auto-commit disabled)
- [ ] Dead letter topic configured for non-retryable failures
- [ ] Exactly-once semantics enabled where required (transactions + read_committed)
- [ ] Consumer lag monitoring and alerting configured
- [ ] Kafka Connect connectors validated with SMT transforms
- [ ] Schema evolution tested (backward/forward compatibility check)
- [ ] Retention and compaction policies appropriate for each topic

---

*Skill Version: 1.0 | Created: March 2026*
