# Kafka to Aerospike Consumer Sizing

## Overview
This document provides sizing guidance for Kafka consumers that read from Kafka topics and write data to Aerospike, based on the pixel traffic system requirements.

## 1. Throughput Requirements
- **Peak Throughput:** ~1.74 GB/sec
- **Peak RPS:** ~3,472,222 events/sec
- **Payload Size:** ~500 bytes/event

## 2. Consumer Parallelism
- **Kafka Partition Count:** 50–100 partitions (see Kafka sizing doc)
- **Consumer Group:**
  - Each consumer can read from one partition at a time.
  - For maximum throughput, match the number of consumers to the number of partitions.
- **Batching:**
  - Consumers may batch writes to Aerospike for efficiency, but Aerospike supports high write rates per connection.

## 3. Sizing Kafka Consumers
- **Throughput per Consumer:**
  - Each consumer can typically handle 20–50 MB/sec (Aerospike write throughput is high, but network and serialization may be limiting factors).
- **Required Consumers:**
  - 1.74 GB/sec ÷ 50 MB/sec ≈ 35 consumers (recommend 50–60 for headroom and resilience).
- **Distribute consumers across multiple instances for resilience and scaling.**

## 4. Instance Type Recommendations
| Instance Type   | vCPUs | RAM  | Network      | Consumers/Instance | Notes                        |
|----------------|-------|------|--------------|--------------------|------------------------------|
| c7g.large      | 2     | 4GB  | 12.5 Gbps    | 1                  | Scale horizontally           |
| c7g.4xlarge    | 16    | 32GB | 30 Gbps      | 8–12               | Good balance                 |
| c7i.4xlarge    | 16    | 32GB | 50 Gbps      | 12–16              | High network                 |
| i4i.2xlarge    | 8     | 64GB | 18.75 Gbps   | 4–6                | For local disk buffering     |

- **Spot instances** can be used for cost savings, but ensure your consumer group can handle interruptions.

## 5. Best Practices
- Monitor consumer lag and Aerospike write latency.
- Auto-scale consumers based on lag or throughput.
- Distribute consumers across multiple AZs for high availability.
- Use enhanced networking (ENA) and latest instance types.
- Benchmark with your actual workload and adjust as needed.
- Tune Aerospike write batch size and connection pool for optimal throughput.

## References
- [Kafka Sizing Guide](https://www.github.com/k888/kafkaplan/kafka_sizing_requirements.md)
- [Aerospike Hardware Sizing Guide](https://docs.aerospike.com/server/operations/plan/capacity/)
- [AWS Instance Types](https://aws.amazon.com/ec2/instance-types/)

---

These recommendations provide a starting point for sizing Kafka to Aerospike consumers. Actual requirements may vary based on message size, compression, and workload characteristics. Always benchmark and tune for your environment. 