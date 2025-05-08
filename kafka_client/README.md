# Kafka Client for Pixel Traffic System

This directory contains Kafka client code for the pixel traffic system. The initial implementation is a Kafka consumer that reads pixel event messages (as specified in payload_example.json) from the Kafka topic and processes them for downstream systems (e.g., S3, Flink, Aerospike).

## Structure
- `consumer.py` — Kafka consumer implementation
- `requirements.txt` — Python dependencies
- `README.md` — This file

## Usage
- Configure the Kafka broker, topic, and group in `consumer.py` or via environment variables.
- Run the consumer to process pixel event messages.

## Notes
- The consumer expects messages in the format of `specs/payload_example.json`.
- Extend the consumer to batch, transform, or forward messages as needed for your pipeline. 