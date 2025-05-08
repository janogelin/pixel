import os
import json
from typing import List, Dict, Any
from confluent_kafka import Consumer
from dotenv import load_dotenv

load_dotenv()

KAFKA_BROKER = os.getenv("KAFKA_BROKER", "localhost:9092")
KAFKA_TOPIC = os.getenv("KAFKA_TOPIC", "pixel-events")
KAFKA_GROUP = os.getenv("KAFKA_GROUP", "pixel-consumer-group")
BATCH_SIZE = int(os.getenv("BATCH_SIZE", 100))
BATCH_TIMEOUT = float(os.getenv("BATCH_TIMEOUT", 2.0))  # seconds

class BatchSink:
    """
    Abstract sink interface for batch processing.
    """
    def write_batch(self, batch: List[Dict[str, Any]]):
        raise NotImplementedError

class PrintSink(BatchSink):
    def write_batch(self, batch: List[Dict[str, Any]]):
        print(f"Processing batch of {len(batch)} events:")
        for event in batch:
            print(json.dumps(event, indent=2))

class S3Sink(BatchSink):
    def __init__(self, bucket: str):
        self.bucket = bucket
        # Stub: In a real implementation, set up boto3 client here

    def write_batch(self, batch: List[Dict[str, Any]]):
        # Stub: Replace with actual S3 upload logic
        print(f"[S3Sink] Would write batch of {len(batch)} events to S3 bucket: {self.bucket}")

class FlinkSink(BatchSink):
    def __init__(self, endpoint: str):
        self.endpoint = endpoint
        # Stub: In a real implementation, set up REST or Kafka producer here

    def write_batch(self, batch: List[Dict[str, Any]]):
        # Stub: Replace with actual Flink integration logic
        print(f"[FlinkSink] Would send batch of {len(batch)} events to Flink endpoint: {self.endpoint}")

class AerospikeSink(BatchSink):
    def __init__(self, host: str, port: int):
        self.host = host
        self.port = port
        # Stub: In a real implementation, set up Aerospike client here

    def write_batch(self, batch: List[Dict[str, Any]]):
        # Stub: Replace with actual Aerospike write logic
        print(f"[AerospikeSink] Would write batch of {len(batch)} events to Aerospike at {self.host}:{self.port}")

class PixelKafkaConsumer:
    """
    Kafka consumer for pixel event messages with batching and pluggable sinks.
    """
    def __init__(self, broker: str, topic: str, group: str, batch_size: int = 100, batch_timeout: float = 2.0, sinks: List[BatchSink] = None):
        self.topic = topic
        self.batch_size = batch_size
        self.batch_timeout = batch_timeout
        self.sinks = sinks or [PrintSink()]
        self.consumer = Consumer({
            'bootstrap.servers': broker,
            'group.id': group,
            'auto.offset.reset': 'earliest',
            'enable.auto.commit': True
        })
        self.consumer.subscribe([self.topic])

    def process_batch(self, batch: List[Dict[str, Any]]):
        for sink in self.sinks:
            sink.write_batch(batch)

    def run(self):
        print(f"Consuming from topic: {self.topic}")
        batch = []
        last_batch_time = None
        import time
        try:
            while True:
                msg = self.consumer.poll(1.0)
                now = time.time()
                if msg is not None and not msg.error():
                    try:
                        event = json.loads(msg.value().decode('utf-8'))
                        batch.append(event)
                        if last_batch_time is None:
                            last_batch_time = now
                    except json.JSONDecodeError as e:
                        print(f"Failed to decode JSON: {e}")
                # Check if batch should be processed
                if batch and (len(batch) >= self.batch_size or (last_batch_time and now - last_batch_time >= self.batch_timeout)):
                    self.process_batch(batch)
                    batch = []
                    last_batch_time = None
        except KeyboardInterrupt:
            print("Consumer interrupted.")
        finally:
            self.consumer.close()

if __name__ == "__main__":
    sinks = [
        PrintSink(),
        S3Sink(bucket="my-s3-bucket"),
        FlinkSink(endpoint="http://flink-job-endpoint"),
        AerospikeSink(host="localhost", port=3000)
    ]
    consumer = PixelKafkaConsumer(
        broker=KAFKA_BROKER,
        topic=KAFKA_TOPIC,
        group=KAFKA_GROUP,
        batch_size=BATCH_SIZE,
        batch_timeout=BATCH_TIMEOUT,
        sinks=sinks
    )
    consumer.run() 