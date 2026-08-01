# 04 — CAP_SYS_PTRACE with host PID namespace

## Misconfiguration and danger

Host PID sharing reveals host processes. Combining it with `SYS_PTRACE` can allow an attacker to attach to accessible processes, inspect memory, or inject code.

## Safe walkthrough

The script displays a small process list to demonstrate host PID visibility. It does not call `ptrace`, launch gdb, attach to a process, or dump memory.

## Detection rule

`Cross-Namespace Ptrace Attempt` detects any container `ptrace` syscall. It is CRITICAL and tagged `T1055` (Process Injection); correlate the target PID namespace in your broader Falco ruleset.

## Remediation

Avoid host PID namespaces and `SYS_PTRACE`. Drop capabilities by default and use seccomp/AppArmor/SELinux, rootless Docker, and user namespaces.
