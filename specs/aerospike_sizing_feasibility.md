# Aerospike Sizing and Feasibility

## Assumptions
- A separate consumer service reads JSON files (from S3 or stream) and writes events to Aerospike.
- Payload per event: ~500 bytes (from payload_example.json)
- Peak RPS: ~3,472,222 (from request_rate_analysis.md)

## 1. Throughput Calculation
- **Peak write rate:** 3,472,222 events/sec × 500 bytes = ~1.74 GB/sec
- **Aerospike is designed for high-throughput, low-latency workloads and can scale horizontally.**

## 2. Storage Calculation
- **Daily data volume:**
  - 3,472,222 events/sec × 500 bytes × 86,400 sec/day ≈ 150 TB/day (uncompressed)
- **Retention:**
  - For real-time analytics, retention may be short (e.g., 1–7 days)
  - 7 days retention: 1 PB (petabyte) uncompressed
- **Compression:**
  - Aerospike supports data compression; actual storage may be 30–70% of raw size depending on data and compression settings

## 3. Hardware Sizing
- **Cluster size:**
  - Aerospike nodes can handle 100,000–500,000 TPS per node (depending on hardware and configuration)
  - For 3.5M TPS, recommend 8–16 nodes for headroom and redundancy
- **Instance types:**
  - Storage-optimized EC2 (e.g., i4i.8xlarge, i3en.6xlarge) with NVMe SSDs
  - 25–50 Gbps networking per node recommended
  - 128–256 GB RAM per node for in-memory indexes and hot data
- **Disk:**
  - NVMe SSDs, provisioned for required retention (e.g., 1 PB for 7 days, with compression)

## 4. Feasibility
- **Aerospike is feasible for this workload, given its proven performance at multi-million TPS and petabyte-scale storage.**
- **Key considerations:**
  - Sizing for peak write throughput and storage
  - Sufficient network and disk bandwidth
  - Monitoring and auto-scaling for node failures or traffic spikes
  - Data model and secondary index design for query performance

## 5. Recommendations
- **Cluster:** 8–16 storage-optimized nodes (i4i/i3en family), NVMe SSDs, 128–256 GB RAM, 25–50 Gbps networking
- **Monitor:** Write latency, disk usage, and node health
- **Tune:** Compression, retention, and secondary indexes for workload
- **Benchmark:** In your environment with representative data and access patterns

## References
- [Aerospike Hardware Sizing Guide](https://docs.aerospike.com/server/operations/plan/capacity/)
- [AWS Storage-Optimized Instances](https://aws.amazon.com/ec2/instance-types/)

---

These estimates provide a starting point for Aerospike sizing and feasibility at the specified traffic levels. Actual requirements may vary based on data model, compression, and retention policies. Always benchmark and tune for your workload. 