# Global architecture investigation

Start from how the system runs. A keyword is a clue, not the audit boundary.

1. Map repository packages, manifests, boot/config files, test roots, ADRs, and declared ownership.
2. Identify entrypoint families: server routes, workers/jobs, CLI commands, event handlers.
3. Choose one to three paths by product importance and change pressure. State coverage and omissions.
4. Trace each entrypoint through callers, domain logic, lifecycle/config state, persistence/external
   effects, and tests. Search both declarations and consumers before claiming a blast radius.
5. Use only relevant lenses from `references/global-lenses.md`.
6. Locate where change amplification, cognitive load, or hidden dependencies concentrate.
7. Compare a conservative repair and a cleaner ownership boundary; price migration when a real
   public/persisted contract changes. State first proof and stop/reframe signal.

A global finding connects at least three anchors: package ownership, dependency direction,
entrypoint/call trace, state/config/data flow, and test protection. A file's length is not proof.
Do not claim a whole-repository audit from one attractive file or claim all paths were traced
when only selected paths were inspected.

Use P0 for evidenced correctness/data/security/operability risk, P1 for costly core-path coupling,
P2 for bounded change friction, P3 for local cleanup. Cost S/M/L reflects local repair,
boundary/test changes, or public-contract/persistence/rollout changes respectively.
Read `references/global-output-template.md` before delivering. Preserve the evidence map even
when the answer is compact.
