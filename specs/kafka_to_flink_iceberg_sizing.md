# Kafka to Flink & Iceberg Sizing

## Overview
This document provides sizing guidance for streaming data from Kafka into Apache Flink for processing and writing to Apache Iceberg tables, based on the pixel traffic system requirements.

## 1. Throughput Requirements
- **Peak Throughput:** ~1.74 GB/sec
- **Peak RPS:** ~3,472,222 events/sec
- **Payload Size:** ~500 bytes/event

## 2. Flink Parallelism and Kafka Integration
- **Kafka Partition Count:** 50–100 partitions (see Kafka sizing doc)
- **Flink Parallelism:**
  - Flink job parallelism should match or exceed the number of Kafka partitions for optimal throughput.
  - Recommended: 50–100 parallel Flink source tasks (slots).
- **Batching:**
  - Flink jobs should batch records for efficient writes to Iceberg (e.g., write every N MB or every few seconds).
  - Use Parquet format for efficient storage and analytics in Iceberg tables.

## 3. Sizing Flink Cluster
- **Throughput per Slot:**
  - Each Flink slot can typically handle 20–50 MB/sec for lightweight processing and Parquet encoding.
- **Required Slots:**
  - 1.74 GB/sec ÷ 50 MB/sec ≈ 35 slots (recommend 50–100 for headroom and scaling).
- **CPU/Memory:**
  - 1 vCPU and 1–2 GB RAM per slot is typical for lightweight jobs.
- **Cluster Example:**
  - 7 × c7g.4xlarge (16 vCPUs, 32 GB RAM, 30 Gbps network) = 112 slots, 224 GB RAM
  - 6–8 c7g.4xlarge/c7i.4xlarge/c7gn.4xlarge instances recommended

## 4. Instance Type Recommendations
| Instance Type   | vCPUs | RAM  | Network      | Slots/Instance | Notes                        |
|----------------|-------|------|--------------|----------------|------------------------------|
| c7g.large      | 2     | 4GB  | 12.5 Gbps    | 2              | Scale horizontally           |
| c7g.4xlarge    | 16    | 32GB | 30 Gbps      | 16             | Good balance                 |
| c7i.4xlarge    | 16    | 32GB | 50 Gbps      | 16             | High network                 |
| c7gn.4xlarge   | 16    | 32GB | 50 Gbps      | 16             | High network                 |

- **Spot instances** can be used for cost savings, but ensure your Flink cluster can handle interruptions.

## 5. Best Practices
- Monitor Flink job lag, checkpointing, and Iceberg write latency.
- Auto-scale Flink TaskManagers based on lag or throughput.
- Distribute Flink TaskManagers across multiple AZs for high availability.
- Use enhanced networking (ENA) and latest instance types.
- Benchmark with your actual workload and adjust as needed.
- Use Parquet format for Iceberg tables for efficient analytics and compression.

## References
- [Flink Parallelism Guide](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/dev/datastream/execution/)
- [Iceberg Performance Tuning](https://iceberg.apache.org/docs/latest/performance/)
- [AWS Instance Types](https://aws.amazon.com/ec2/instance-types/)

---

These recommendations provide a starting point for sizing Kafka to Flink and Iceberg. Actual requirements may vary based on job complexity, message size, and workload characteristics. Always benchmark and tune for your environment. 