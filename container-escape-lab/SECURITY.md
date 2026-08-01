# Security policy

This repository is intentionally a defensive training lab. Run it only in an isolated disposable Linux VM that you own. Do not use its insecure compose examples, configurations, or detections as production deployment templates.

## Reporting a concern

Do not publish a working host-escape chain in an issue. Describe the affected file, the unsafe condition, and a safe reproduction summary. Redact hosts, tokens, internal endpoints, and payload details.

## Scope

The exercise scripts intentionally perform read-only checks or bounded benign actions. Any change that enables host-side command execution, destructive kernel control, credential access, traffic interception, or process-memory access is out of scope.
