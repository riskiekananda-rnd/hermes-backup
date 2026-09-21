---
name: api-design
version: 1.0.0
description: "REST API design: endpoints, auth, rate limiting."
tags: [api, rest, http, authentication, design]
platforms: [linux, macos, windows]
author: Hermes Agent
license: MIT
---

# REST API Design

Design clean, secure, and scalable REST APIs.

## When to Use
- Designing new API endpoints
- Implementing authentication
- Setting up rate limiting
- Building RESTful services

## Quick Reference
```bash
# Test API
curl -X GET http://localhost:3000/api/resource
curl -X POST http://localhost:3000/api/resource -H 'Content-Type: application/json' -d '{"key":"value"}'
curl -X PUT http://localhost:3000/api/resource/1 -H 'Content-Type: application/json' -d '{"key":"new"}'
curl -X DELETE http://localhost:3000/api/resource/1
```

## Endpoint Design
```
GET    /api/resource          # List all
GET    /api/resource/:id      # Get one
POST   /api/resource          # Create
PUT    /api/resource/:id      # Update
DELETE /api/resource/:id      # Delete
```

## Authentication
```python
# JWT token auth
import jwt
from datetime import datetime, timedelta

def create_token(user_id):
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + timedelta(hours=24)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm='HS256')

def verify_token(token):
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
    except jwt.ExpiredSignatureError:
        return None
```

## Rate Limiting
```python
from functools import wraps
from time import time

def rate_limit(max_requests, window):
    requests = []
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            now = time()
            requests[:] = [r for r in requests if r > now - window]
            if len(requests) >= max_requests:
                return {'error': 'Rate limit exceeded'}, 429
            requests.append(now)
            return f(*args, **kwargs)
        return wrapper
    return decorator
```

## Error Handling
```python
# Standard error responses
{
    'error': {
        'code': 'VALIDATION_ERROR',
        'message': 'Invalid input',
        'details': {'field': 'email', 'issue': 'required'}
    }
}
```

## Best Practices
1. **Versioning** — `/api/v1/resource`
2. **Pagination** — `?page=1&limit=20`
3. **Filtering** — `?status=active&sort=created_at`
4. **HATEOAS** — include links for discoverability
5. **CORS** — configure for browser access

## Common Mistakes
- Using verbs in URLs (`/getUser` → `/users/:id`)
- No error handling
- Missing rate limiting
- Exposing internal IDs
- No API versioning

## Verification
```bash
curl -I http://localhost:3000/api/health
# Should return 200 with proper headers
```