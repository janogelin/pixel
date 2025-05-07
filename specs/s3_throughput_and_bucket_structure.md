# S3 Throughput Calculation and Bucket Structure Recommendations

## Source Data
- **Peak Throughput:** ~1.74 GB/sec (from Flink/Kafka estimates)
- **Payload Example:** `payload_example.json`
- **Traffic Numbers:**
  - Peak RPS: ~3,472,222
  - Payload size: ~500 bytes

## 1. S3 Throughput Calculation
- **AWS S3 Performance Limits (as of 2024):**
  - S3 supports at least 3,500 PUT/COPY/POST/DELETE requests per second per prefix
  - S3 supports at least 5,500 GET/HEAD requests per second per prefix
  - No practical limit to total throughput with sufficient prefixes and parallelization
  - S3 can scale to tens of GB/sec with proper design

- **Required PUT rate:**
  - 3,472,222 PUTs/sec (one per event)
  - 3,472,222 PUTs/sec ÷ 3,500 PUTs/sec/prefix ≈ 993 prefixes required for full parallelism

- **Required data throughput:**
  - 1.74 GB/sec peak write rate

## 2. Bucket and Prefix Structure Recommendations
- **Use a single bucket or a small number of buckets for simplicity and manageability**
- **Distribute writes across many prefixes to maximize parallelism and avoid S3 performance bottlenecks**
- **Recommended prefix structure:**
  - Use time-based and/or hash-based prefixes, e.g.:
    - `s3://your-bucket/pixel_data/year=2025/month=05/day=07/hour=14/minute=52/`
    - Or: `s3://your-bucket/pixel_data/hash=ab/`
  - Ensure at least 1,000 unique prefixes are active at any time during peak load
- **Partitioning by time and/or hash ensures even distribution and optimal S3 performance**
- **Avoid hot prefixes** (e.g., writing all data to a single prefix or time bucket)

## 3. Recommendations
- **Monitor S3 request rates and latency using AWS CloudWatch**
- **Increase the number of prefixes if PUT latency increases or throttling is observed**
- **Use multipart uploads for large objects, but for small events, single PUTs are sufficient**
- **Enable S3 versioning and lifecycle policies as needed for data management**

## References
- [S3 Performance Guidelines](https://docs.aws.amazon.com/AmazonS3/latest/userguide/optimizing-performance.html)
- [S3 Request Rate and Performance](https://aws.amazon.com/blogs/aws/amazon-s3-performance-tips-tricks-seattle-hackathon/)

---

These recommendations ensure S3 can handle the required throughput and scale efficiently for the pixel traffic workload. Always monitor and adjust prefix strategy as traffic patterns evolve. 