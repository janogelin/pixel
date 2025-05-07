# Apache Flink Job Sizing Estimates

## Source Data
- **Payload Example:** `payload_example.json`
- **Traffic Numbers:**
  - Average RPS: ~1,157,407
  - Peak RPS: ~3,472,222
  - Payload size: ~500 bytes
  - Peak throughput: ~1.74 GB/sec

## 1. Flink Parallelism Calculation
- **Flink parallelism** determines how many concurrent tasks (slots) process the data stream.
- **Rule of thumb:** Each Flink task slot should handle no more than 50 MB/sec for low-latency, high-availability jobs.
- **Required parallelism:**
  - 1.74 GB/sec ÷ 50 MB/sec ≈ 35 slots
- **Recommended for headroom and scaling:** 50–100 slots (parallelism)

## 2. Task Manager Sizing
- **CPU:**
  - 1 vCPU per slot is recommended for lightweight processing (e.g., parsing, enrichment, routing).
  - For 100 slots: 100 vCPUs total (distributed across Task Managers)
- **Memory:**
  - 1–2 GB RAM per slot for lightweight jobs
  - For 100 slots: 100–200 GB RAM total
- **Network:**
  - Each Task Manager should have at least 10 Gbps networking for high-throughput jobs

## 3. Example Hardware Layout
- **Instance types:** c7g.4xlarge, c7i.4xlarge, or c7gn.4xlarge (16 vCPUs, 32 GB RAM each)
- **Cluster example:**
  - 7 instances × 16 slots = 112 slots (parallelism)
  - 7 × 32 GB RAM = 224 GB RAM
  - 7 × 10 Gbps = 70 Gbps aggregate network

## 4. Recommendations
- **Flink parallelism:** 50–100 slots for the main job
- **Cluster size:** 6–8 c7g.4xlarge/c7i.4xlarge/c7gn.4xlarge instances
- **Monitor:** Task slot utilization, backpressure, and latency
- **Scale:** Adjust parallelism and instance count based on observed workload and latency

## References
- [Flink Parallelism Guide](https://nightlies.apache.org/flink/flink-docs-release-1.18/docs/dev/datastream/execution/)
- [AWS Instance Types](https://aws.amazon.com/ec2/instance-types/)

---

These estimates provide a starting point for Flink job sizing at the specified traffic levels. Actual requirements may vary based on job complexity, state size, and processing logic. Always benchmark and tune in your environment. 