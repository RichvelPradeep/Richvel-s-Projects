# 05 — Host PID and host network namespaces

## Misconfiguration and danger

Sharing host PID (`pid: host`) and network (`network_mode: host`) namespaces removes process and network isolation. A container can inspect host processes and capture or interfere with host network traffic, enabling potential nsenter-based namespace crossing into host namespaces if combined with elevated permissions or proc filesystem access.

## Safe walkthrough

The script safely demonstrates host PID visibility (`ps -eo pid,ppid,user,comm --sort=pid | head`) and host network interface visibility (`ip addr show | head`). It operates strictly read-only, performing no packet capture, no `nsenter` execution, and no `/proc/1/root` access.

## Detection rule

`Container Host Namespace Access` detects container execution of `nsenter` or access to `/proc/1/root`. It is CRITICAL and tagged `T1611`.

## Remediation

Avoid `pid: host` and `network_mode: host` for application workloads. Use rootless Docker/user namespaces, seccomp/AppArmor profiles, and least privilege.
