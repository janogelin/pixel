# Kafka Partition Count and Hardware Estimates

## Source Data
- **Payload Example:** `payload_example.json`
- **Traffic Numbers:**
  - Average RPS: ~1,157,407
  - Peak RPS: ~3,472,222

## 1. Payload Size Calculation
The payload example is a JSON object. Estimated size (pretty-printed):

```json
{
  "event_type": "purchase",
  "event_time": "2025-05-07T14:52:00Z",
  ...
}
```

- **Estimated payload size:** ~500 bytes (actual size may vary, but this is a reasonable estimate for similar events)

## 2. Kafka Partition Count Calculation

### Throughput Calculation
- **Peak RPS:** 3,472,222
- **Payload size:** 500 bytes
- **Peak throughput:**
  - 3,472,222 * 500 bytes = 1,736,111,000 bytes/sec ≈ 1.74 GB/sec

### Partition Sizing
- **Recommended max throughput per partition:** 50 MB/sec (conservative, for low latency and high availability)
- **Required partitions:**
  - 1.74 GB/sec ÷ 50 MB/sec ≈ 35 partitions
- **Recommended for headroom and parallelism:** 50–100 partitions

## 3. Hardware Estimates (Broker Sizing)

### Network
- **Total peak throughput:** 1.74 GB/sec
- **Per broker (assuming 4 brokers):** 1.74 GB/sec ÷ 4 ≈ 435 MB/sec per broker
- **Recommended network:** 10 Gbps per broker (1.25 GB/sec), sufficient for this load

### Disk
- **Sustained write:** 435 MB/sec per broker
- **Recommended:** NVMe SSDs for low latency and high throughput

### CPU/Memory
- **Instance types:** c7g.4xlarge, c7i.4xlarge, or c7gn.4xlarge (as in requirements)
- **Memory:** At least 32–64 GB RAM per broker for buffer/cache

## 4. Recommendations
- **Kafka cluster:** 4–6 brokers, each with 10 Gbps networking, NVMe SSDs, and 32–64 GB RAM
- **Partitions:** 50–100 partitions for the topic
- **Monitor:** Partition skew, broker utilization, and adjust as needed
- **Replication:** Use replication factor 3 for durability

## References
- [Kafka Sizing Guide](https://www.github.com/k888/kafkaplan/kafka_sizing_requirements.md)
- [AWS Instance Types](https://aws.amazon.com/ec2/instance-types/)

---

These estimates provide a starting point for Kafka sizing at the specified traffic levels. Actual requirements may vary based on message size, compression, and workload characteristics. Always benchmark in your environment. 