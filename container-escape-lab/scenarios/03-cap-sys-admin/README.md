# 03 — CAP_SYS_ADMIN

## Misconfiguration and danger

`SYS_ADMIN` is an extremely broad capability and enables mounting in many configurations. Mount access can expose devices or filesystem content beyond an application's intended boundary.

## Safe walkthrough

The script attempts only an ephemeral 1 MiB tmpfs at `/tmp`, then unmounts it. It never mounts `/dev/*`, host paths, or a host filesystem.

## Detection rule

`Unexpected Container Mount` alerts on any mount syscall from a container. It is CRITICAL and tagged `T1611`; tune allowlists for known legitimate mounts.

## Remediation

Drop all capabilities by default, never grant `SYS_ADMIN` unless rigorously justified, and apply seccomp/AppArmor/SELinux plus user namespaces.
