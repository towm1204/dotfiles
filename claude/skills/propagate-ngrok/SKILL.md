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

4. **Disable old Increase subscriptions** — read `INCREASE_API_KEY` from `.flaskenv`, then:
   - List: `GET https://sandbox.increase.com/api/event_subscriptions` with `Authorization: Bearer <key>`
   - For each **active** subscription with `ngrok` in the URL: `PATCH https://sandbox.increase.com/api/event_subscriptions/<id>` with `{"status": "disabled"}`
   - App startup will auto-create a new subscription with the updated URL.

5. **Restart services** — run `make stop-all` then `make im-start-nb` (from repo root).
