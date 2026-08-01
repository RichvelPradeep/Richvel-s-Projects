# 06 — Writable proc and unconstrained seccomp

## Misconfiguration and danger

A writable host `/proc` mount exposes kernel control interfaces. `core_pattern` and `sysrq-trigger` are particularly sensitive; modifying them can affect the host. Disabling seccomp removes an important syscall boundary.

## Safe walkthrough

The script reads the mounted `core_pattern` and reports whether `sysrq-trigger` exists. It does not write either control or crash any process.

## Detection rule

`Sensitive Proc Sysctl Write` detects write-open events for `core_pattern` and `sysrq-trigger`. It is CRITICAL and tagged `T1611`.

## Remediation

Never bind-mount host `/proc` for workloads. Keep Docker's default seccomp profile or a tighter custom profile, use read-only mounts, drop capabilities, and enforce AppArmor/SELinux plus user namespaces.
