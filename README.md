
# Direct WhatsApp shop bot - free-tier pilot

Status: source built, local tests passed, NOT deployed. No live WhatsApp messages have been sent. This is a single-shop pilot, not production SaaS. No paid BSP required.

## Included
- Meta Cloud API webhook verification + SHA-256 signature authentication.
- Hours/public owner contact replies, stock lookup from D1 database.
- Explicit `/order item-code | quantity | pickup time`, then `/confirm request-id` within 15 minutes.
- Atomic stock reservation using a database trigger; duplicate order/message protection.
- Owner stock/order dashboard protected by a bearer token. Order visibility on manual refresh is the alert in this pilot; no push/email/WhatsApp notifications.
- LIVE_SEND defaults false. Secret values absent from this package.

## Set up in this order
1. Sign in/create Cloudflare Free account. Stay on Free; no paid plan or payment commitment.
2. Create D1 database `shop-whatsapp-pilot`; put its returned database ID into wrangler.jsonc. Apply schema.sql. Deploy Worker + assets. This produces an HTTPS dashboard and `/webhook` endpoint. Wrangler CLI commands: `npx wrangler d1 create shop-whatsapp-pilot`, `npx wrangler d1 execute shop-whatsapp-pilot --remote --file schema.sql`, `npx wrangler deploy`. Account auth is required. No remote command has been run here.
3. Create/choose Meta developer app with WhatsApp use case and business portfolio. Use Meta's supplied TEST phone number first, and add a verified test recipient. Do not migrate/delete the shop owner's existing WhatsApp number.
4. Configure server secrets securely: ADMIN_TOKEN (random), VERIFY_TOKEN (random), META_APP_SECRET, WA_TOKEN. PHONE_NUMBER_ID is the Meta test phone-number ID, configured as a server variable. Use secure secret storage, never chat/client source. Use `wrangler secret put` interactively or provider dashboard secret fields. GRAPH_VERSION is v23.0 per the fetched official setup example; recheck the app's supported version before deploy.
5. Register HTTPS `/webhook` as Meta callback with VERIFY_TOKEN and subscribe to messages. Add business details and test stock via private dashboard. Generate a durable system-user token for continued use; temporary tokens expire quickly.
6. Keep LIVE_SEND=false for setup. Explicitly authorize test recipient + scripted auto-replies, set LIVE_SEND=true, then the test customer messages the TEST number. Validate inbound webhook, replies, availability, a confirmed order, dashboard record and duplicate handling. A current 24-hour customer-service window is required for non-template replies.
7. Production onboarding of the owner's real business number is separate: consent, Meta eligibility/phone verification/business setup and any payment requirements must be checked. Existing Business app coexistence uses Embedded Signup and requires Solution Partner/Tech Provider eligibility; it is NOT implemented in this pilot. App review/permissions for onboarding other clients must be settled before selling multi-client deployment.

## Owner handoff
After approved production setup, customers message the owner's onboarded WhatsApp number, no website link needed for the chat. Give owner the private dashboard URL and private credential through a secure channel. Owner updates stock there. Stock is only as current as owner's updates; no POS sync implemented. Never share dashboard credentials with customers. Customers must confirm quantity/pickup; no payments are taken by this pilot.

## Free limits, not free forever
Workers Free: 100k dynamic requests/day, 10ms CPU/invocation, static asset requests free. D1 Free: 5M rows read/day, 100k written/day, 5GB storage. Free limits may stop operation. Replies to users in service windows can be free; business-initiated/template messages can incur Meta charges. This pilot does not use templates or proactive owner WhatsApp messages. Confirm actual account billing before enabling anything chargeable. No expiry timer is coded, but token/account/access/hosting availability and quotas determine whether it runs. No uptime/instant-reply guarantee.

## Deliberate gaps
- Not AI/fully agentic: uses deterministic intents and explicit command syntax. Arbitrary Hindi/free-text extraction and orders need a tested intent layer; never let an LLM invent stock or write orders without deterministic validation/confirmation.
- No proactive owner notification. Dashboard must be open/refreshed. Notification rail requires recipient consent/setup and verified pricing before implementation.
- No production auth sessions, rate-limiting, cancellation/release/refund/fulfilment, backup/retention jobs, multi-tenant isolation, customer privacy consent flow or full delivery/status reconciliation.
- Webhook processing failures are marked `needs-review` and not automatically retried to avoid duplicate orders/replies. Failed outbound sends need operator handling. Crash recovery, timeout/retry tests and provider integration tests remain.
- No automatic stale stock correction. Timestamps are shown. Pickup times are user text, not opening-hours validated.
- Free cloud/Meta accounts NOT connected here. Cannot call it working on WhatsApp until end-to-end tests pass.

## Tests
`node --test test/core.test.mjs`
`python3 test/database_test.py`
`node --check src/worker.mjs`
Five JS tests + database reserve/oversell/duplicate tests pass locally. Dashboard visually inspected at mobile and desktop widths, not connected to backend.

## Sources checked 30 September 2026
https://developers.facebook.com/docs/whatsapp/cloud-api/get-started
https://developers.facebook.com/docs/whatsapp/cloud-api/webhooks
https://developers.facebook.com/docs/graph-api/webhooks/getting-started/
https://developers.facebook.com/docs/whatsapp/embedded-signup/custom-flows/onboarding-business-app-users/
https://business.whatsapp.com/products/platform-pricing
https://developers.cloudflare.com/workers/platform/pricing/
https://developers.cloudflare.com/d1/platform/pricing/
https://developers.cloudflare.com/workers-ai/platform/pricing/
https://www.whatsapp.com/legal/business-solution-terms/?facet1=pdf
https://free-for.dev/

AI provider restrictions: keep any AI incidental to a shop's own customer service, not a general-purpose assistant distributed through WhatsApp. Meta restricts training/improving models from WhatsApp Business data. Check current terms/model data use before adding AI. Production client onboarding needs written authority, privacy/security protections and provider requirements. This is not a compliance certification.
