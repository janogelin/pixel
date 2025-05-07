# Apache Flink Overview

**Apache Flink** is a powerful, open-source **stream processing framework** designed for **real-time** and **batch** data processing at massive scale. It excels at **stateful computations** over **unbounded (streaming)** and **bounded (batch)** datasets, making it ideal for use cases like event-driven applications, real-time analytics, fraud detection, and ETL pipelines.

---

## 🚀 Key Features of Apache Flink

### ⚡ 1. True Stream Processing
- Processes **events as they arrive**, not in micro-batches like Spark Streaming.
- Supports **event time** and **watermarks**, enabling accurate out-of-order processing.

### 📦 2. Exactly-Once State Management
- Maintains application state with local or external backends (e.g., RocksDB, S3).
- Supports **checkpointing** and **savepoints** for **fault-tolerance**.

### 🔄 3. Unified Batch and Streaming API
- Treats batch processing as a special case of streaming.
- Reuse the same code for both modes via **DataStream** or **Table API**.

### 🗣 4. SQL and Table API
- **Flink SQL** is a powerful declarative language for streaming and batch.
- Integrates with Kafka, Iceberg, Hive, JDBC, Elasticsearch, and more.

### ☁️ 5. High Throughput + Low Latency
- Handles billions of events per day with **millisecond latency**.
- Efficient operator chaining and task scheduling with backpressure handling.

### 🔧 6. Rich Ecosystem and Connectors
- **Sources/Sinks**: Kafka, Kinesis, Pulsar, JDBC, Cassandra, Elasticsearch, Hive, Iceberg, S3
- **Formats**: JSON, Avro, Parquet, Protobuf, CSV

---

## 🧱 Architecture Overview

```
  +-----------+      +----------------+     +-----------------+
  |  Kafka    | -->  | Flink Job      | --> | Iceberg / S3    |
  +-----------+      | (Operators,    |     | Elasticsearch,  |
                     |  State, Timers)|     | Kafka, etc.     |
                     +----------------+     +-----------------+
```

- Jobs are broken into **parallel tasks** distributed across TaskManagers.
- The **JobManager** coordinates execution and state.

---

## 🔍 Common Use Cases

| Use Case                  | Why Flink? |
|---------------------------|------------|
| Real-time analytics       | Low latency, event time support |
| Fraud detection           | Stateful stream joins, CEP |
| ETL pipelines             | Ingest, enrich, write to data lake (Iceberg, Delta) |
| Data quality/validation   | Streaming SQL with complex logic |
| IoT and sensor streams    | Scalable and fault-tolerant processing |

---

## 🛠 Example: Flink SQL

```sql
CREATE TABLE page_views (
  user_id STRING,
  url STRING,
  event_time TIMESTAMP(3),
  WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kafka',
  'topic' = 'views',
  ...
);

SELECT user_id, COUNT(*) 
FROM page_views 
GROUP BY user_id, TUMBLE(event_time, INTERVAL '1' MINUTE);
```

---

Flink is used by companies like Netflix, Uber, Alibaba, Pinterest, and Stripe for high-scale stream processing.
