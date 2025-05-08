# Pixel Traffic Requirements

## Overview
This document outlines the requirements for a latency-sensitive pixel traffic collection system, typical in advertising tracking. The system is designed to handle high-throughput, low-latency requests, collecting minimal data and forwarding it efficiently for downstream processing and analysis.

## Key Requirements
- **Latency Sensitivity:**
  - Each pixel request must be responded to within 1-2 ms.
- **Data Collected:**
  - Only the pixel sent from an advertiser page ad, with minimal location and user information.
- **Throughput:**
  - Target: 50,000–100,000 requests per second (RPS) per instance.
- **Multi-Region:**
  - The system must support active-active deployments across multiple AWS regions to ensure high availability and global low-latency response.
  - Route53 should be used in front of the load balancers to distribute traffic globally and provide failover.

## Architecture
- **Frontend:**
  - Likely candidate: `nginx` (other fast alternatives can be considered).
  - Load balancer in front of pixel servers to distribute traffic evenly.
- **Pixel Servers:**
  - EC2 instance types: `c7g.4xlarge`, `c7i.4xlarge`, or `c7gn.4xlarge`.
  - Tuned for high throughput and low latency.
  - Consider using the most cost-effective instance types, including spot instances, to optimize costs while maintaining required performance.
  - Implement scheduled scaling to match expected traffic patterns and reduce costs during off-peak hours.
  - Prewarm the load balancer before anticipated traffic spikes to ensure minimal cold start latency and optimal distribution.
- **Data Pipeline and Storage:**
  - Pixel data is sent over a Kafka queue for ingestion.
  - Apache Flink is used for real-time stream processing and analytics on the pixel data.
  - Processed data is written to Apache Iceberg tables, with Nessie as the Iceberg catalog for versioned data lake management.
  - The Iceberg tables are stored in S3 buckets as the final data destination.
  - Parquet files should be used as the storage format for efficient analytics and compression within Iceberg tables and S3.
  - Kafka must implement robust backpressure and flow control mechanisms to prevent overload, and broker protection strategies should be in place to avoid cascading failures.
  - (Optional) Aerospike can be used for live stream data from frontends for real-time fraud/AI analysis (e.g., with a custom-tuned LLM).
- **Global Traffic Distribution:**
  - AWS Route53 is used as a DNS-based global traffic manager, routing user requests to the nearest healthy region and providing automatic failover.

## Security
- **Firewall:**
  - Only allow connections on the specified port for the pixel service.
- **Network:**
  - Restrict access to internal services and Kafka brokers.
- **Encryption:**
  - AWS Key Management Service (KMS) with Customer Master Keys (CMK) should be used to secure data keys and encrypt sensitive data at rest and in transit.
  - KMS should also be used for decryption operations to ensure secure access to sensitive information.
  - S3 buckets must use Server-Side Encryption with KMS (SSE-KMS) for all stored data.
  - KMS should be leveraged for TLS certificate management and for signing/verifying JWTs where applicable.
  - Secrets must be stored in AWS Secrets Manager, with compliance and auditing enforced for all encryption and access operations.
  - Key types:
    - Symmetric AES-256 keys should be used for encrypt/decrypt operations.
    - RSA or ECC keys should be used for encryption/decryption or signing/verifying operations as required.

## Summary Diagram
```
                +-------------------+
                |    Route53 DNS    |
                +-------------------+
                         |
         +---------------+---------------+
         |                               |
 [Region A]                        [Region B]
   [Load Balancer]                 [Load Balancer]
        |                               |
   [Auto Scaling Group]            [Auto Scaling Group]
        |                               |
   [Pixel Servers]                 [Pixel Servers]
        |                               |
   [Kafka Queue]                   [Kafka Queue]
        |                               |
   [Apache Flink]                  [Apache Flink]
        |                               |
 [Iceberg (Nessie Catalog)]      [Iceberg (Nessie Catalog)]
        |                               |
   [S3 Buckets]                   [S3 Buckets]
        |                               |
 [Aerospike (optional)]           [Aerospike (optional)]
```

## Notes
- All components must be tuned for minimal latency and high throughput.
- Kafka sizing and configuration are critical to avoid bottlenecks.
- Kafka must be configured with traffic guards, including backpressure, flow control, and broker protection, to maintain reliability and prevent overload.
- Consider benchmarking alternative web servers to nginx for further latency reduction. 