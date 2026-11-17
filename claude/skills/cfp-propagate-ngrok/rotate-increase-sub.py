"""Disable all active Increase event subscriptions and create a new one."""
import sys
from increase import Increase


def main():
    if len(sys.argv) != 4:
        print("Usage: rotate-increase-sub.py <ngrok_url> <api_key> <webhook_secret>")
        sys.exit(1)

    ngrok_url, api_key, webhook_secret = sys.argv[1], sys.argv[2], sys.argv[3]
    client = Increase(api_key=api_key, environment="sandbox")

    for sub in client.event_subscriptions.list().data:
        if sub.status == "active":
            client.event_subscriptions.update(sub.id, status="disabled")
            print(f"Disabled {sub.id}")

    res = client.event_subscriptions.create(
        url=f"{ngrok_url}/v1/webhooks/increase-callback",
        shared_secret=webhook_secret,
    )
    print(f"Created {res.id}")


if __name__ == "__main__":
    main()
