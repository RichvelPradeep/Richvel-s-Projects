# Contributing

Keep every scenario safe to run in a disposable lab: no destructive writes, real host escape chain, process attachment, credential collection, or traffic capture.

Before opening a pull request, run:

```bash
./scripts/validate.sh
```

Each new scenario needs a compose file, a Bash exercise with a lab-only disclaimer, one focused Falco rule with MITRE tags, a scenario README, and a documented remediation.
