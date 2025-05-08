import json
from typing import List, Dict, Any
from consumer import PixelKafkaConsumer

class TestPixelKafkaConsumer(PixelKafkaConsumer):
    def __init__(self, *args, **kwargs):
        # Do not call the real Consumer constructor
        pass

    def run_test(self, test_events: List[Dict[str, Any]], batch_size: int, batch_timeout: float):
        """
        Simulate consuming events and test batching logic.
        """
        self.batch_size = batch_size
        self.batch_timeout = batch_timeout
        batch = []
        processed_batches = []
        import time
        last_batch_time = None
        for i, event in enumerate(test_events):
            batch.append(event)
            now = time.time() if last_batch_time is not None else 0
            if last_batch_time is None:
                last_batch_time = now
            # Simulate batch processing by size
            if len(batch) >= self.batch_size:
                processed_batches.append(list(batch))
                batch = []
                last_batch_time = None
        # Process any remaining events
        if batch:
            processed_batches.append(list(batch))
        return processed_batches

if __name__ == "__main__":
    # Example test events (matching payload_example.json structure)
    test_events = [
        {
            "event_type": "purchase",
            "event_time": "2025-05-07T14:52:00Z",
            "user": {"id": f"user{i}", "ip": "203.0.113.45", "user_agent": "Mozilla/5.0"},
            "session_id": f"session{i}",
            "page_url": "https://example.com/product/123",
            "referrer": "https://partner.com/ad?campaign=789",
            "campaign": {"id": "camp-789", "source": "google", "medium": "cpc", "term": "running+shoes", "content": "text_ad_3"},
            "browser": {"language": "en-US", "screen_resolution": "1920x1080"},
            "custom": {"product_id": "sku-456", "revenue": 149.99, "currency": "USD"}
        }
        for i in range(7)
    ]
    test_consumer = TestPixelKafkaConsumer(None, None, None)
    batches = test_consumer.run_test(test_events, batch_size=3, batch_timeout=2.0)
    print(f"Total batches: {len(batches)}")
    for idx, batch in enumerate(batches):
        print(f"Batch {idx+1} ({len(batch)} events):")
        for event in batch:
            print(json.dumps(event, indent=2)) 