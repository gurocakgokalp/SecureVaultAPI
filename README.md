# SecureVaultAPI

A zero-knowledge storage API built with Vapor. The server stores only 
encrypted blobs — it never has access to plaintext content or encryption keys.

> **Note:** This is the backend component. Client-side encryption 
> (AES-GCM via CryptoKit) is intentionally left to the client — 
> any client that encrypts before sending achieves zero-knowledge storage.

> **Disclaimer:** Educational and portfolio use only. Not audited.

## Architecture

The server is designed to be cryptographically blind:
- Accepts any blob — encrypted or not
- Never inspects content
- Access controlled via per-item Bearer tokens
- Every operation logged to audit trail
- In-memory Swift Actors shield the database from spam and brute-force spikes

## API

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| POST | `/vault/store` | — | Store a blob, receive item ID + access token |
| GET | `/vault/:id` | Bearer token | Retrieve a blob |
| DELETE | `/vault/:id` | Bearer token | Delete a blob |

## Audit Logs

<img height="300" alt="image" src="https://github.com/user-attachments/assets/195927db-28d4-472c-a211-64d7cf7ff394" />

## Usage

**Store:**
```bash
curl -X POST http://localhost:8080/vault/store \
  -H "Content-Type: application/json" \
  -d '{"blob": "<your-encrypted-content>"}'
```

Response:
```json
{
  "id": "bf1349b0-...",
  "accessToken": "358A8514-...",
  "encryptedBlob": "<your-encrypted-content>",
  "createdAt": "2026-03-30T..."
}
```

**Retrieve:**
```bash
curl http://localhost:8080/vault/<id> \
  -H "Authorization: Bearer <accessToken>"
```

**Delete:**
```bash
curl -X DELETE http://localhost:8080/vault/<id> \
  -H "Authorization: Bearer <accessToken>"
```

## Security

- **Per-item access tokens** — each stored blob gets a unique Bearer token. 
No token, no access.
- **Brute-force protection** — 3 consecutive failed token attempts trigger an automatic 15-minute IP ban via `AsyncMiddleware`. Successful reads reset the failure counter.
- **Global rate limiting** — an actor-isolated memory cache throttles excessive requests, returning `429 Too Many Requests` without bottlenecking the DB.
- **Audit logging** — every store, retrieve, delete, and unauthorized attempt 
is logged to the database with timestamp and success status.
- **Zero-knowledge by design** — the server has no decryption capability. 
Clients are responsible for encrypting before sending.
- **Self-cleaning memory** — background tasks automatically evict expired IP states from RAM to prevent memory leaks.

## Running with Docker
```bash
docker-compose up
```

Backend starts on `http://localhost:8080`. Database migrations run automatically.

## Tech Stack

- **Backend:** Vapor (Server-side Swift)
- **Database:** PostgreSQL + Fluent ORM
- **Containerization:** Docker

## Known Limitations

- Access tokens stored in plaintext in DB — should be hashed in production.
- No token expiry — tokens are valid indefinitely.
- Single-user design — no multi-tenancy.
- Not security audited.
