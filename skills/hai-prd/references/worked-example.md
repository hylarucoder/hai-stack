# Hai PRD: Worked Examples

Two end-to-end runs showing how the modes and the six-test produce a concrete answer.
Read this when you want to see how the judgment lands before applying it to the user's case.

---

## Example A — Scope PRD: a split decision

**Request:** "We have one big PRD called *User Profiles* that covers viewing a profile,
editing your own profile, and an admin moderation queue for reported profiles. Should this
be one PRD or several?"

**Run the six-test:**

| Test | Signal | Evidence |
|------|--------|----------|
| Press Release | split | "Edit my profile" and "moderate reported profiles" are two unrelated user values in one sentence. |
| Independent Value | split | Moderation delivers value to admins even if self-edit ships later, and vice versa. |
| Independent Acceptance | split | Self-edit is accepted by an end user; moderation is accepted by an admin against a queue — different acceptance owners. |
| Domain Language | neutral | All touch the `Profile` entity, but moderation introduces a separate `Report` lifecycle. |
| User Journey | do-not-break | View + edit are one continuous self-service journey; splitting them would fragment it. |
| Time Appetite | split | The combined scope is large; moderation can be sequenced after the self-service core. |

**Choose the cut (see `scope-tiers.md`):** split by *user role + core-path-vs-enhancement*,
not by CRUD. Keep view + edit together — they are one self-service journey for one role.

**Recommendation:** Split into two PRDs.
- **PRD A — Profile self-service** (Tier 1, entity lifecycle of `Profile`): view + edit your own profile.
- **PRD B — Profile moderation** (Tier 2, aggregate view over reported profiles; owns the `Report` flow, depends on A's `Profile` existing).

Do **not** split view from edit (would break one journey) and do **not** split into
API/frontend/DB PRDs (no fragment is independently acceptable).

---

## Example B — Craft PRD: diagnose and repair an existing PRD

**Request:** "Here's our *Checkout* PRD, clean it up." (user provides the file)

**Read the full document, then diagnose drift:**

- **Scope drift** — the PRD bundles a payment-provider migration that has no user-visible
  behavior change; it belongs in a separate technical effort (route to `hai-goal`).
- **Acceptance drift** — "checkout should feel fast" is not provable; no observable criterion.
- **Conflict drift** — the Behavior section says guest checkout is supported; the Permissions
  section says login is required.

**Reframe before rewriting:**
- Corrected target outcome: "A returning or guest user can complete a purchase in one session with a confirmed order."
- PRD boundary: the checkout journey only; provider migration is out.
- Decision: reorganize + repair, not rewrite — the journey and scope are mostly sound.

**Repairs applied:**
- Moved the provider migration to a non-goal and noted it as a separate effort.
- Rewrote "feel fast" into "order confirmation renders within 2s of payment success (observable)."
- Resolved the guest-vs-login conflict by stating guest checkout is in scope and login is optional, and aligned the Permissions section to match.

**Output:** an Existing PRD Diagnosis (main drift = scope drift), a remove/keep/rewrite table,
and the repaired acceptance criteria — per `references/output-template.md`.
