#!/usr/bin/env bash
# Repository-only validation; it intentionally does not start containers or Falco.
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(README.md run-lab.sh falco/falco.yaml LICENSE SECURITY.md CONTRIBUTING.md)
for path in "${required[@]}"; do
  [[ -f "$root_dir/$path" ]] || { echo "Missing required file: $path" >&2; exit 1; }
done

for number in 01 02 03 04 05 06; do
  dirs=("$root_dir/scenarios/$number"-*)
  [[ ${#dirs[@]} -eq 1 && -d "${dirs[0]}" ]] || { echo "Missing scenario $number" >&2; exit 1; }
  for file in vulnerable-compose.yml exploit.sh falco_rule.yaml README.md; do
    [[ -f "${dirs[0]}/$file" ]] || { echo "Missing $file in ${dirs[0]}" >&2; exit 1; }
  done
  bash -n "${dirs[0]}/exploit.sh"
  grep -q 'LAB-ONLY SAFE SIMULATION' "${dirs[0]}/exploit.sh" || { echo "Missing safety banner: ${dirs[0]}" >&2; exit 1; }
  grep -q 'tags:' "${dirs[0]}/falco_rule.yaml" || { echo "Missing MITRE tags: ${dirs[0]}" >&2; exit 1; }
done
bash -n "$root_dir/run-lab.sh"
echo "Validation passed: six scenarios, Bash syntax, safety banners, and Falco tags verified."
