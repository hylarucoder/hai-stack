# APoSD Principles Applied to TypeScript / Frontend

TypeScript's type system and module system create specific opportunities and pitfalls from an APoSD perspective.

## Module Depth in TypeScript

**Deep modules look like**:
- A module that exports 2-3 functions or a single class, but internally manages significant complexity (state machines, data transformations, caching, coordination).
- A React hook that encapsulates complex state logic behind a simple return type.
- A service module that hides API details, retry logic, and caching behind simple `get`/`create`/`update` functions.

**Shallow modules look like**:
- Re-export files (`index.ts` that just re-exports from other files) — pure pass-through.
- Wrapper components that add no behavior, just forward props.
- Utility files with many small, unrelated exported functions.
- Type-only modules that export types but no behavior.

## Information Hiding with TypeScript's Type System

TypeScript's type system can help or hurt information hiding:

**Helping**: Use opaque types or branded types to prevent callers from depending on internal structure.
```typescript
// Callers know it's a UserID, but can't assume it's a string
type UserID = string & { readonly __brand: 'UserID' }
```

**Hurting**: Exporting internal types forces callers to couple to implementation details.
```typescript
// BAD: caller must know internal structure
export interface InternalCacheEntry<T> { data: T; ttl: number; key: string }
export function getFromCache<T>(key: string): InternalCacheEntry<T>

// GOOD: caller only sees the data
export function getFromCache<T>(key: string): T | null
```

## React Component Design

**Deep components**: Accept simple props, manage significant internal complexity (state, effects, event handling, rendering logic). The caller passes data in and gets UI out without needing to know how.

**Shallow components**: Accept many props that directly control rendering details. The caller is essentially writing the component's implementation through props. If the component's props mirror its internal state 1:1, it's not hiding anything.

**Information leakage in React**: When a parent component must know about a child's internal state or structure to use it correctly. This often manifests as "prop drilling" or tightly coupled parent-child render logic.

## Error Handling in Frontend

Frontend error handling is often more about UX than system correctness:

- **Define errors out of existence**: If a list is empty, show an empty state — don't error. If a fetch hasn't completed, show a loading state — don't throw.
- **Mask errors**: A data-fetching hook can retry internally and only surface errors after retries are exhausted.
- **Aggregate errors**: A form can collect all validation errors and present them together, rather than failing on the first one.

## Common TypeScript Anti-Patterns (APoSD Lens)

**1. Barrel files**: `index.ts` files that re-export everything from a directory. These are pure pass-through modules that add a layer of indirection without hiding anything.

**2. Over-typing**: Creating a type for every intermediate value. Types should help understanding, not mirror every step of a transformation.

**3. Props explosion**: Components with 10+ props are shallow — the caller must understand all the knobs. Consider composing smaller components or using compound component patterns.

**4. State management leakage**: When components directly access global store internals (specific slice shapes, action creators) instead of going through a focused selector/hook interface.
