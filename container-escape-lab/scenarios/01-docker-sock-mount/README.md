# 01 — Docker socket mount

## Misconfiguration and danger

Mounting `/var/run/docker.sock` gives the container access to the Docker daemon API. A daemon normally runs with host-level authority, so an attacker could ask it to create highly privileged workloads.

## Safe walkthrough

The compose file exposes the socket. `exploit.sh` verifies the Unix socket and calls Docker's read-only `/version` endpoint. It deliberately does **not** create a sibling container, request privileged mode, or mount host paths.

## Detection rule

`Container Accessed Docker Socket` alerts when a container opens that socket or its command line references it. It is CRITICAL and tagged `T1611` (Escape to Host).

## Remediation

Never mount `docker.sock` into application containers. Use a narrowly scoped service instead; also use rootless Docker/user namespaces, least privilege, and seccomp/AppArmor profiles.
