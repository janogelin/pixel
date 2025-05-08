# EC2 Instance Estimate (SWAG) for Pixel Traffic System

This document provides a high-level estimate ("swag") of the number of EC2 instances required to support the pixel traffic system at peak load (~3.5 million RPS), based on sizing documents and best practices.

---

## 1. Pixel Servers (Frontend)
- **Target throughput:** 50,000–100,000 RPS per instance (c7g.4xlarge, c7i.4xlarge, or c7gn.4xlarge)
- **Peak RPS:** 3,472,222
- **Instances needed:**
  - At 100,000 RPS/instance: ~35
  - At 50,000 RPS/instance: ~70
- **Recommended:** 40–80 (for headroom, redundancy, and multi-AZ)

## 2. Kafka Brokers (MSK)
- **Sizing doc:** 4–6 brokers
- **Recommended:** 6

## 3. Flink Cluster
- **Sizing doc:** 6–8 c7g.4xlarge/c7i.4xlarge/c7gn.4xlarge
- **Recommended:** 8

## 4. Kafka Consumers (S3, Flink, Aerospike)
- **Kafka to S3:** 50–60 consumers, can be run on 6–8 c7g.4xlarge (8–12 consumers per instance)
- **Kafka to Flink/Iceberg:** Usually run as part of the Flink cluster above
- **Kafka to Aerospike:** 50–60 consumers, can be run on 6–8 c7g.4xlarge
- **Recommended:**
  - S3 consumers: 8
  - Aerospike consumers: 8

## 5. Aerospike Cluster
- **Sizing doc:** 8–16 storage-optimized nodes (i4i.8xlarge, i3en.6xlarge)
- **Recommended:** 12

## 6. Other Supporting Infrastructure
- Nessie Catalog, Bastion, Monitoring, etc.: 2–4 (can be small instances)

---

## Total Estimate (per region)

| Component           | Instances (low) | Instances (high) |
|---------------------|-----------------|------------------|
| Pixel Servers       | 40              | 80               |
| Kafka Brokers       | 6               | 6                |
| Flink Cluster       | 8               | 8                |
| S3 Consumers       | 8               | 8                |
| Aerospike Consumers | 8               | 8                |
| Aerospike Cluster   | 8               | 16               |
| Supporting Infra    | 2               | 4                |
| **Total**           | **80**          | **130**          |

---

## Grand Total (for 2 regions, active-active)
- **160–260 EC2 instances** (across both regions)

---

**Notes:**
- This is a high-level estimate. Actual numbers may be lower with aggressive optimization, or higher if you need more redundancy, smaller instance types, or more granular scaling.
- Some components (like Flink, consumers) can be co-located on the same instances if resource usage allows.
- Use auto-scaling to adjust to real traffic patterns. 