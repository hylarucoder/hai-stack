---
name: prd-splitter
description: |
  PRD scope advisor — helps decide whether a feature should be its own PRD or merge into an existing
  one. Two modes: (1) Split — given a large PRD or feature idea, apply a 6-dimension test framework
  to decide where to draw boundaries; (2) Audit — review a set of existing PRDs for merge signals,
  scope creep, or broken user journeys.
  Use this skill when the user asks: "should this be a separate PRD", "how to split this PRD",
  "is this PRD too big", "PRD scope", "PRD granularity", "merge these PRDs",
  or mentions PRD 拆分, 需求拆分, PRD 粒度, 拆需求, 合并 PRD, 需求边界.
---

# PRD Scope Advisor

You help product managers and engineers decide what belongs in one PRD vs. many. The goal is not to follow a rigid formula, but to reason about **user mental models** — a PRD should map to what a user thinks of as "one thing I want to do."

Not by technical module (that's design docs). Not by team (that's project management). By **how the user thinks**.

## Core Framework: Six-Dimension Decision Tests

When unsure whether something should be one PRD or two, run these six tests in order. Each test produces a lean/split or lean/merge signal. Weigh them together — no single test is decisive.

### Test 1: Press Release Test (Amazon PR/FAQ)

> Can you write a single clear user value in one sentence?

If you need "and" to connect two unrelated values → **split**.
If a piece can't stand alone as a clear value statement → **merge**.

### Test 2: Independent Value Test (Vertical Slice)

> Can a user get value from this PRD alone, without depending on another PRD?

Yes → can split.
No → merge, or explicitly mark the dependency order.

### Test 3: Independent Acceptance Test

> Can this PRD be deployed and acceptance-tested independently?

Yes → can split.
No (must wait for other modules) → mark the dependency, but not necessarily merge.

### Test 4: Domain Language Test (DDD Bounded Context)

> Do the two features share the same domain terminology and core entities?

Same aggregate root (e.g., both operate on the Order entity) → lean merge.
Different terminology or entities → split.

### Test 5: User Journey Test (User Story Mapping)

> Does splitting break the user's journey?

Example: user can "create a profile" but can't "see the profile list" → journey broken → **don't split**.
Example: user can "chat" and also "manage knowledge base" independently → **can split**.

### Test 6: Time Appetite Test (Shape Up)

> Is the scope achievable in a controlled timeframe?

Too large (estimated > 6 weeks) → cut scope or split into phases.
Too small (just a single API endpoint) → merge into a larger PRD.

## Applying the Tests

When the user presents a feature or PRD and asks whether to split:

**Step 1 — Understand the feature.** Ask what it does, who uses it, and what value it provides. If you have access to the PRD text, read it.

**Step 2 — Run all six tests.** For each test, state the signal (split / merge / neutral) with a one-sentence justification.

**Step 3 — Synthesize.** If 4+ tests agree, the recommendation is clear. If it's close (3-3 or nuanced), lay out the tradeoff and let the user decide.

**Step 4 — If splitting, recommend a cut dimension.** Use the splitting dimensions table below.

## Splitting Dimensions

When the decision is to split, choose where to cut. Try in priority order:

| Dimension | How to cut | Example |
|-----------|-----------|---------|
| **User journey steps** | Different stages each get a PRD | Create → Edit → Publish (but check Test 5: journey can't break) |
| **Core path vs enhancement** | Happy path first, enhancements in a follow-up PRD | Basic chat vs. citation panel |
| **User role** | Different roles each get a PRD | End user vs. admin vs. guest |
| **Risk / complexity** | High-uncertainty parts become a spike or experiment PRD | Collaboration mode (high uncertainty) vs. CRUD (low uncertainty) |
| **Platform / channel** | Different platforms each get a PRD | Web app vs. desktop app vs. mobile |

### Anti-patterns — do NOT cut along these dimensions:

| Anti-pattern | Why it's bad |
|-------------|-------------|
| By tech layer (API PRD + frontend PRD + DB PRD) | One feature split into three, nobody sees the full picture |
| By CRUD (create PRD + read PRD + delete PRD) | User journey shattered, each piece is incomplete |
| By team (Team A's part + Team B's part) | Org changes invalidate the PRDs |

## Merge Signals

These indicate two PRDs should be combined:

| Signal | Explanation |
|--------|-------------|
| Circular dependency | A depends on B, B depends on A |
| Shared core entity | Both PRDs operate on different lifecycle stages of the same aggregate root |
| User doesn't distinguish | Users see it as one thing — you split it by internal logic |
| No independent acceptance | Completing one alone delivers zero user value |

## Granularity Scale

| Too large (split) | Just right | Too small (merge) |
|-------------------|-----------|-------------------|
| > 400 lines | 100-300 lines | < 50 lines |
| > 6 weeks to build | 2-6 weeks | < 1 week |
| Covers > 3 user journeys | 1-2 journeys | Doesn't form a complete journey |
| Press release needs "and" | One sentence value | Can't articulate independent value |
| Spans > 2 bounded contexts | 1 bounded context | Just a field in someone else's context |

## Three-Tier Classification — "How Many PRDs Should a Project Have?"

The six tests solve the micro question ("split this or not?"). The three-tier model solves the macro question ("how many PRDs should the whole project have?").

| Tier | Definition | Rule | Examples |
|------|-----------|------|----------|
| **Tier 1: Entity lifecycle** | Full CRUD + business flow for each core domain entity | One entity = one PRD | User, Project, Document, Subscription, Campaign |
| **Tier 2: Aggregate view** | Cross-entity dashboard or summary — owns no core entity itself | One aggregate surface = one PRD | Home/Dashboard, App Shell, Analytics Overview |
| **Tier 3: Platform extension** | A distinct platform or channel experience | One platform = one PRD | Mobile app, Desktop app, Browser extension |

### Decision flow for new features

When a new feature appears, ask in order:

1. **Is it a new core entity?** (Has an independent lifecycle: create → use → manage → archive)
   - Yes → Tier 1, new PRD
   - No → next
2. **Is it a cross-entity aggregate view?** (Summarizes multiple entities, doesn't manage data itself)
   - Yes → Tier 2, new PRD
   - No → next
3. **Is it a new platform/channel?** (Independent interaction environment)
   - Yes → Tier 3, new PRD
   - No → **It shouldn't be its own PRD** — fold it into an existing one

### Things that are NOT PRDs

| Type | Where it belongs | Examples |
|------|-----------------|----------|
| Technical architecture decisions | design-docs/ | Memory architecture, engine module design |
| Infrastructure capabilities | design-docs/ | i18n, design system, data-fetching layer |
| Quality standards | Standalone meta doc | Acceptance criteria template |
| Tracking artifacts | §9 of each PRD | Prototype alignment log |

## Output Format

When advising on a PRD split/merge decision:

```markdown
## PRD Scope Assessment: [Feature Name]

### Six-Dimension Test Results
| Test | Signal | Reasoning |
|------|--------|-----------|
| Press Release | split/merge/neutral | ... |
| Independent Value | ... | ... |
| Independent Acceptance | ... | ... |
| Domain Language | ... | ... |
| User Journey | ... | ... |
| Time Appetite | ... | ... |

### Recommendation
[Split / Merge / Keep as-is] — [one paragraph reasoning]

### Suggested Boundaries (if splitting)
- **PRD A**: [scope]
- **PRD B**: [scope]
- **Cut dimension**: [which dimension from the table]
- **Dependency**: [if any, which must ship first]
```

## What This Skill Is NOT

- Not a PRD template or writer. It decides scope boundaries, not content.
- Not a project management tool. It doesn't assign timelines or teams.
- Not a technical architecture advisor. Module decomposition is a separate concern.
