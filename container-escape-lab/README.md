# Container Escape Lab + Detection

## 1. WARNING / DISCLAIMER

**Educational lab only.** Run this repository only in an isolated disposable Linux VM or sandbox that you own. Do not run it on shared, production, or third-party infrastructure, and do not target a real host. The included proof-of-concept scripts are deliberately **non-destructive simulations**: they demonstrate telemetry and validation checks without performing a host escape or host-side code execution.

## 2. Overview

This lab pairs six intentionally insecure Docker configurations with focused Falco detections and safe exercise scripts.

```text
operator --> run-lab.sh --> Docker Compose --> vulnerable lab container
                         \-> Falco + scenario rule --> JSON alert log
lab container --> safe simulation --> expected Falco telemetry --> screenshots/*-alert.log
```

## 3. Scenarios

| # | Misconfig | MITRE Technique | Exploit Summary | Detection Rule | Priority |
|---|---|---|---|---|---|
| 01 | Docker socket mount | T1611 | Validates socket exposure; safely demonstrates request construction | Container Accessed Docker Socket | CRITICAL |
| 02 | Privileged mode | T1611 | Inspects cgroup release-agent surfaces without changing them | Cgroup Release Agent Modification | CRITICAL |
| 03 | `SYS_ADMIN` | T1611 | Attempts a harmless tmpfs mount only | Unexpected Container Mount | CRITICAL |
| 04 | `SYS_PTRACE` + host PID | T1055 | Checks host PID visibility; no attach or memory dump | Cross-Namespace Ptrace Attempt | CRITICAL |
| 05 | Host PID + network | T1611 | Lists namespaces; no `nsenter` or packet capture | Container Host Namespace Access | CRITICAL |
| 06 | Writable proc | T1611 | Reads sensitive kernel knobs; does not write them | Sensitive Proc Sysctl Write | CRITICAL |

## 4. Prerequisites

1. A disposable Linux VM with Docker Engine and the Docker Compose plugin.
2. Falco installed from the official installer: `curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg` followed by the current distribution instructions at [falco.org](https://falco.org/docs/getting-started/installation/).
3. A Linux kernel supported by Falco's eBPF probe driver or kernel module driver.
4. `sudo` permission to run Falco where required by your installation.

## 5. Run the lab

From this repository, run one scenario at a time:

```bash
chmod +x run-lab.sh scenarios/*/exploit.sh
./run-lab.sh 1
```

`run-lab.sh` starts the selected compose file, starts Falco with that scenario's rule, runs the safe exercise inside the container, saves Falco output under `screenshots/`, and cleans up the compose stack. Review the scenario README before starting it.

## 6. Falco alert output example

```json
{
  "output": "Container Accessed Docker Socket (user=root command=curl --unix-socket /var/run/docker.sock)",
  "priority": "Critical",
  "rule": "Container Accessed Docker Socket",
  "time": "2026-08-01T10:15:30.123456789Z",
  "output_fields": {
    "container.id": "example",
    "container.name": "lab-docker-sock",
    "fd.name": "/var/run/docker.sock",
    "proc.cmdline": "curl --unix-socket /var/run/docker.sock"
  }
}
```

## 7. Remediation summary

| Risk | Primary remediation |
|---|---|
| Docker socket | Never mount `docker.sock`; use a narrow broker/API if needed. |
| Privileged container | Avoid `privileged: true`; use narrowly scoped capabilities. |
| Excess capabilities | Drop all capabilities by default and add only documented requirements. |
| Host namespaces | Do not use host PID/network namespaces for application workloads. |
| Writable proc/sys | Do not bind mount `/proc`; use read-only mounts and a default seccomp profile. |
| Defense in depth | Use rootless Docker or user namespaces, seccomp, AppArmor/SELinux, and admission policy. |

## 8. Falco kernel module vs eBPF probe driver

The kernel module driver has broad syscall visibility but requires compiling/loading a module, which can be operationally difficult on locked-down or managed kernels. Falco's eBPF probe avoids a loadable kernel module and is often easier to deploy, but feature availability and performance depend on the kernel and driver mode. Validate driver support and rule coverage on the exact kernel used by the lab.
