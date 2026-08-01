# 02 — Privileged mode

## Misconfiguration and danger

`privileged: true` removes key container isolation restrictions and exposes broad device and capability access. On vulnerable legacy cgroup layouts, writable `release_agent` controls have been abused for host-context execution.

## Safe walkthrough

The script only enumerates `release_agent` and `notify_on_release` paths. It does not write either control, create a payload, or trigger a release event.

## Detection rule

`Cgroup Release Agent Modification` watches container write-opens of either sensitive cgroup control. It is CRITICAL and tagged `T1611`.

## Remediation

Do not use privileged containers. Drop all capabilities by default; use rootless Docker/user namespaces and enforce seccomp plus AppArmor/SELinux profiles.
