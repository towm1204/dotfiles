---
name: propagate-ngrok
description: Update ngrok URLs everywhere after a restart — .flaskenv, HelloSign, Increase
model: haiku
---
Propagate the current ngrok URL (for localhost:5001) to all places that need it.

## Steps

1. **Get ngrok URL** — run `curl -s http://localhost:4040/api/tunnels` and find the tunnel where `config.addr` contains `localhost:5001`. Extract its `public_url`. If ngrok isn't running or no tunnel found, tell the user and stop.

2. **Update IM `.flaskenv`** — in `investment_management/.flaskenv`, for each line containing `ngrok-free.app`, replace the `https://...ngrok-free.app` portion (everything before the path) with the new ngrok URL. Keep path suffixes intact. Affected vars:
   - `INCREASE_WEBHOOK_URL` (suffix `/v1/webhooks/increase-callback`)
   - `DWOLLA_WEBHOOK_URL` (suffix `/v1/webhooks/dwolla-callback`)
   - `PLAID_WEBHOOK_URL` (suffix `/webhooks/plaid-callback`)

3. **Update HelloSign callback** — read `HELLO_SIGN_API_KEY` from `.flaskenv`, then:
   ```
   curl -X PUT 'https://api.hellosign.com/v3/account' \
     -u '<HELLO_SIGN_API_KEY>:' \
     -F "callback_url=<ngrok_url>/v1/esign_templates/callback"
   ```
   Log the response status.

4. **Rotate Increase subscription** — read `INCREASE_API_KEY` and `INCREASE_WEBHOOK_SECRET` from `.flaskenv`, then run a Python script using the Increase SDK:
   ```python
   from increase import Increase
   client = Increase(api_key="<INCREASE_API_KEY>", environment="sandbox")
   # Disable all active subscriptions (Increase SDK has no delete — disable is the only option)
   for sub in client.event_subscriptions.list().data:
       if sub.status == "active":
           client.event_subscriptions.update(sub.id, status="disabled")
           print(f"Disabled {sub.id}")
   # Create new subscription with updated URL
   res = client.event_subscriptions.create(
       url="<ngrok_url>/v1/webhooks/increase-callback",
       shared_secret="<INCREASE_WEBHOOK_SECRET>",
   )
   print(f"Created {res.id}")
   ```

5. **Do NOT restart services** — tell the user to restart manually (`make stop-all && make im-start-nb`).
