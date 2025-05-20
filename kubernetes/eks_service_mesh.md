
# Service Mesh Support in Amazon EKS

Amazon EKS (Elastic Kubernetes Service) **does not include a service mesh by default**, but it **supports integration with several service mesh solutions**, and AWS offers **AWS App Mesh** as its native service mesh.

---

## 1. AWS App Mesh
- **AWS-native service mesh** that integrates with EKS.
- Works by injecting **Envoy sidecars** into your pods.
- Integrates with AWS CloudMap, IAM, and other AWS services.
- Supports features like **traffic routing, observability (metrics/tracing), and retries**.

> ✅ **Managed by AWS**, but **not automatically installed** with EKS—you must deploy and configure App Mesh manually or via automation.

---

## 2. Istio (Self-managed or via Istio Distro)
- Popular open-source service mesh.
- Compatible with EKS—can be installed using Helm, Istioctl, or via `istio-operator`.
- Can use **sidecar injection** and integrate with Kiali, Jaeger, Prometheus.

> ❌ AWS does not manage Istio for you. You handle upgrades and lifecycle.

---

## 3. Linkerd
- Lightweight, open-source alternative.
- Simpler to operate than Istio, with automatic mTLS and easy setup.
- Supports EKS and can be deployed with a single command line.

---

## Summary

| Service Mesh  | Managed by AWS | Integrated with EKS | Notes |
|---------------|----------------|----------------------|-------|
| App Mesh      | ✅ Yes          | ✅ Yes               | AWS-native; integrates well with IAM and CloudMap |
| Istio         | ❌ No           | ✅ Yes               | Most feature-rich, but heavier operational overhead |
| Linkerd       | ❌ No           | ✅ Yes               | Lightweight, easy to use |

---

Let me know if you want a Terraform or Helm example for installing any of these on EKS.
