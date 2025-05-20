# Kafka Partition and AWS Instance Sizing

## 📥 Input Parameters

| Parameter                | Value             |
|-------------------------|-------------------|
| Message size            | 1 KB (1024 bytes) |
| Messages per second     | 10,000            |
| Retention period        | 7 days            |
| Replication factor (RF) | 3                 |

---

## 🧮 Step-by-Step Calculations

### 🔹 1. Throughput Calculation

**Throughput (MB/s)**:
```
Throughput = 1024 × 10,000 / 1,000,000 = 10.24 MB/s
Effective throughput with RF=3 = 10.24 × 3 = 30.72 MB/s
```

---

### 🔹 2. Storage Requirement

**Daily storage**:
```
10.24 MB/s × 86400 s/day = 885.5 GB/day
```

**Retention storage (7 days)**:
```
885.5 × 7 = 6.2 TB (1 replica)
With RF=3 → 6.2 TB × 3 = 18.6 TB total disk usage
```

---

### 🔹 3. Partition Count Calculation

Assumptions:
- Max 5 MB/s per partition
- Max 500 GB per partition
- Expected concurrency = 6 consumers

**Partitions based on**:
- Throughput: ceil(10.24 / 5) = 3
- Storage: ceil(6.2 / 0.5) = 13
- Concurrency: 6

**Final partition count**:
```
max(3, 13, 6) = 13 → Recommend 14–16 partitions
```

---

## 💻 AWS Instance Recommendation

### Recommended Instance: `m7i.4xlarge` or `r7i.4xlarge`

| Resource         | `m7i.4xlarge`             |
|------------------|---------------------------|
| vCPUs            | 16                        |
| RAM              | 64 GB                     |
| Network          | 12.5 Gbps                 |
| EBS Bandwidth    | 10 Gbps                   |

- Attach **EBS gp3 volumes** (~7 TB per broker)
- Configure with high IOPS (e.g., 16,000)
- Use **3–5 brokers** for RF=3

---

## 📌 Summary

| Aspect              | Value                    |
|---------------------|--------------------------|
| Throughput (with RF)| 30.72 MB/s               |
| Retention Storage   | 18.6 TB total (RF=3)     |
| Partitions Needed   | 13 (round to 14–16)      |
| Broker Count        | 3–5 recommended          |
| AWS Instance Type   | m7i.4xlarge or r7i.4xlarge |
| Storage per Broker  | ≥7 TB (EBS gp3)          |
