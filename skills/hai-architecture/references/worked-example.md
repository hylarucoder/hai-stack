# Worked Examples — Calibrating a Finding

Read this when you are unsure how deep a finding should go, how to phrase evidence, or whether a smell is real. These examples set the bar: every finding is **evidence-led**, traces the smell to a **design force**, and survives a **refutation attempt**. The code below is illustrative (a Go service layer), but the shape transfers to any stack.

---

## Example A — A real, high-leverage finding (done well)

### Finding: `RunService` owns lifecycle state that the store also mutates — split ownership

- **Severity:** High
- **Principle:** Information leakage / boundary ownership
- **What I found (evidence):** `runservice.go:142` sets `run.Status = "waiting"` and writes it via `store.Save(run)`. But `store/agent/lifecycle_transition.go:88` *also* transitions status during `Claim()`, and `queue.go:51` flips it again on requeue. I grepped `Status =` across `internal/biz/agent` and `internal/store/agent` — the same field is assigned in 6 places across two layers. No single function owns the transition table; the legal transitions exist only as scattered assignments.
- **Why it matters (which symptom):** *Change amplification + unknown unknowns.* Adding one new state (e.g. `paused`) means finding all 6 sites and reasoning about which layer is allowed to make which move. A reviewer cannot answer "what transitions are legal?" from any one file — the state machine is implicit. This is exactly where a wrong edit introduces a stuck-run bug that no local test catches.
- **Suggestion:** Make the transition table a deep module: one `lifecycle.Transition(from, event) (to, error)` owned by the store layer, with biz code calling it instead of assigning `Status` directly. The legal moves become data in one place; callers stop knowing the string values.
- **Why-not:**
  - *Why not leave it?* The states are still growing (the runtime added `waiting`/`leased` recently) — the implicit machine is already at 6 assignment sites and will keep amplifying.
  - *Why not push it up into biz?* Lifecycle is persisted; the store is the layer that already owns durability and the lease, so the transition guard belongs next to the write, not above it.
- **Red team:** A future dev bypasses `Transition()` and writes `Status` directly "just this once" for a hotfix. **Blue team:** make `Status` an unexported field reachable only through the transition method, and add an arch test asserting no `Status =` assignment outside `lifecycle_transition.go`. **Residual risk:** raw SQL migrations can still mutate the column; the guard is Go-level only.

**Why this is a good finding:** it cites real lines and the search that found them, names the design force (implicit state machine across a layer boundary), ties to a concrete future failure, and the recommendation makes a *deeper* module rather than just "refactor."

---

## Example B — A tempting smell that is actually a false positive (rejected)

### Non-finding: "`HTTPHandler.CreateRun` is a shallow pass-through to `RunService.Create` — merge them"

- **What it looks like:** `controller/run/controller.go` has `CreateRun` that just decodes the request, calls `service.Create(...)`, and encodes the response. Interface ≈ implementation. Looks like a textbook shallow module / pass-through method.
- **Why it is NOT a finding:** Protocol translation is *inherently* shallow and that is correct (see `red-flags.md` #1 and #5 exceptions). The handler's job *is* to translate HTTP ↔ domain; merging it into the service would drag wire-format concerns (status codes, JSON shape, auth headers) down into business logic — making the service *less* deep, not more. The shallowness here is load-bearing, not accidental.
- **The discipline:** before reporting a shallow/pass-through smell, ask "is this boundary doing protocol/format translation?" If yes, the shallowness is the point. Report it only if the handler also contains business decisions that belong in the service (then the real finding is "business logic leaked into the controller," not "the handler is shallow").

**Why this matters:** half of architecture-review noise is flagging structurally-required shallow boundaries (handlers, DTOs, barrel files, adapters). Calibrate against the *exceptions* in `red-flags.md` before spending a finding on one.
