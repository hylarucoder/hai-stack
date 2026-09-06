# Documentation-vs-Code Audit Examples

## Current-behavior claim

The setup guide says a command accepts `--port`, while current CLI help and the command definition
show only `--listen`. The guide presents this as current usage and no approved spec preserves
`--port`, so the documentation is the repair target.

- **Severity**: P1 if the documented command fails; otherwise P2.
- **Evidence**: guide line, CLI definition, and captured `--help` output.
- **Minimal repair**: update the guide and examples to `--listen`.

## Intended-behavior claim

An approved security specification says isolation must be enabled, while runtime configuration
disables it. The document is the intended authority and accurately labels the requirement, so this
is an implementation gap—not stale documentation.

- **Severity**: P0/P1 based on exposure.
- **Evidence**: approved spec status plus runtime configuration and tests.
- **Minimal repair**: report the implementation gap; do not "fix" the audit by weakening the spec.

These cases show why source precedence must be declared before choosing the repair target.
