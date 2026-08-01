#!/usr/bin/env bash
# Lab-only orchestrator. Use solely in an isolated VM you own.
set -euo pipefail

scenario="${1:-}"
if [[ ! "$scenario" =~ ^[1-6]$ ]]; then
  echo "Usage: $0 <scenario-number: 1..6>" >&2
  exit 64
fi

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
matches=("$root_dir"/scenarios/0"$scenario"-*)
if [[ ${#matches[@]} -ne 1 || ! -d "${matches[0]}" ]]; then
  echo "Scenario directory not found for $scenario" >&2
  exit 66
fi
scenario_dir="${matches[0]}"
compose_file="$scenario_dir/vulnerable-compose.yml"
rule_file="$scenario_dir/falco_rule.yaml"
log_file="$root_dir/screenshots/0$scenario-alert.log"
container_name="$(awk '/container_name:/ {print $2; exit}' "$compose_file")"
falco_pid=""

cleanup() {
  [[ -n "$falco_pid" ]] && kill "$falco_pid" 2>/dev/null || true
  docker compose -f "$compose_file" down --remove-orphans || true
}
trap cleanup EXIT INT TERM

docker compose -f "$compose_file" up -d
falco -r "$rule_file" -o json_output=true > >(tee "$log_file") 2>&1 &
falco_pid=$!
sleep 2
docker exec "$container_name" /lab/exploit.sh
echo "Falco output saved to: $log_file"
