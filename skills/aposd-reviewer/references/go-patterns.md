# APoSD Principles Applied to Go

Go's design philosophy and APoSD are highly compatible. Go already favors simplicity, small interfaces, and explicit error handling. But Go codebases can still accumulate complexity in specific ways. Here's what to watch for.

## Package Design = Module Depth

In Go, the package is the primary unit of modularity. A well-designed Go package is a **deep module**:

**Deep package indicators**:
- Few exported types and functions relative to the internal logic
- Callers can use the package without understanding its internals
- The package name alone tells you what abstraction it provides

**Shallow package indicators**:
- Many exported types, each with minimal logic
- Callers must understand internal types to use the package
- Packages that are just namespaces grouping loosely related functions
- The `util`, `helpers`, `common` anti-pattern — these are never deep because they have no coherent abstraction

**Go-specific guidance**:
- Prefer fewer, deeper packages over many shallow ones. Go's package system discourages circular dependencies, which naturally pushes toward clearer boundaries.
- A package with one exported interface and one unexported implementation is a sign of good depth.
- The standard library is full of deep module examples: `net/http`, `database/sql`, `io`.

## Interface Design

Go interfaces are implicit (structural typing), which makes them powerful for information hiding.

**Good interface design (APoSD-aligned)**:
- Small interfaces (1-3 methods) that capture a single abstraction
- Defined by the consumer, not the implementer
- `io.Reader` and `io.Writer` are the gold standard — 1 method each, enormously powerful

**Red flags in Go interfaces**:
- Large interfaces (5+ methods) — likely trying to describe an implementation rather than an abstraction
- Interfaces defined in the same package as their only implementation — this hides nothing
- Interface methods that mirror the implementation's struct fields (getter/setter interfaces) — shallow by definition
- "Header interfaces" that are just the full method set of a concrete type

## Error Handling

Go's explicit error handling is a strength for APoSD, but it creates specific patterns to watch for.

**Define errors out of existence**:
```go
// BAD: caller must handle "not found"
func GetUser(id string) (*User, error)
// If the common case is "return nil if not found":

// GOOD: no error for missing user
func FindUser(id string) *User  // returns nil if not found
```
Use this when "not found" is a normal case, not an exceptional one. Reserve errors for things that are genuinely unexpected.

**Mask errors internally**:
```go
// BAD: caller must handle retry logic
func SendMessage(msg Message) error

// GOOD: retries internally, caller only sees final failure
func SendMessage(msg Message) error  // retries up to 3 times internally
```

**Aggregate errors**:
- When a function has many error returns that all result in the same caller behavior, consider whether the function's API could be simplified.
- Sentinel errors (`ErrNotFound`, `ErrInvalid`) are good for cross-module contracts, but having too many distinct sentinel errors in a package is a smell — it pushes decision-making up to callers.

**Error wrapping**:
- `fmt.Errorf("context: %w", err)` is good — it adds context without exposing internals.
- But long chains of wrapping across many layers (`a: b: c: d: original error`) can indicate pass-through layers that aren't adding real value.

## Struct Design

**Deep structs**:
- Have methods that provide meaningful behavior (not just field access)
- Hide internal state behind methods
- Internal fields are unexported; behavior is exported

**Shallow structs**:
- Are just data bags with exported fields and no methods
- Force callers to manipulate fields directly
- Have no invariants to maintain

Data-transfer structs (DTOs) between layers are inherently shallow, and that's fine — their purpose is explicit data transfer, not abstraction.

## The `internal/` Convention

Go's `internal/` package restriction is a built-in information hiding mechanism. Use it aggressively:
- Anything that is an implementation detail should be in `internal/`
- If you're tempted to export a type "just in case," don't — keep it internal until there's a real consumer
- `internal/` packages can be deep or shallow; the restriction just prevents external coupling

## Common Go Anti-Patterns (APoSD Lens)

**1. Over-interfacing**: Defining an interface for every struct, even when there's only one implementation and no testing benefit. This adds interface complexity without hiding anything.

**2. Package proliferation**: Creating a new package for every concept. Each package boundary adds interface surface area. Fewer, deeper packages are usually better.

**3. The "service" layer**: A `service` package that just calls `store` methods with identical signatures. This is a pure pass-through layer. If the service adds no logic, merge it with the layer above or below.

**4. Config structs with too many fields**: A `Config` struct with 20 fields pushes complexity upward — every caller must understand all options. Prefer sensible defaults with optional overrides (functional options pattern).

**5. Context abuse**: Passing values through `context.Context` to avoid pass-through parameters is tempting but creates obscurity — the dependency is hidden. Prefer explicit struct fields or dependency injection.
