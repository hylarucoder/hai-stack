# Naming Output Templates

Use the smallest mode that answers the request.

## Quick naming

```markdown
## Recommendation
`<recommendedName>` — <decisive reason tied to concept, reader, and context>.

## Alternatives
| Candidate | Best when | Main risk |
|-----------|-----------|-----------|
| `<name>` | <context> | <possible misunderstanding> |

## Context Check
<what was read or what assumption remains>
```

Keep this conversational for a tiny local name; headings may be omitted when the same information
fits in a short answer.

## Naming audit

```markdown
# Naming Audit: <scope>

## Vocabulary Map
- **Viewpoint anchor**: <product/domain/runtime/adapter and core actor>
- **Concepts**: <concept -> current vocabulary>
- **Call flow**: <caller -> boundary -> owner -> consumer>
- **Collisions or drift**: <overloaded, stale, or competing terms>

## Findings
### N1: `<oldName>` -> `<suggestedName>`
- **Location**: `<file:line>`
- **Evidence**: <declaration/call/contract evidence actually read>
- **Problem**: <wrong viewpoint, lost distinction, collision, stale vocabulary, or generic name>
- **Better model**: <what the new name makes clear>
- **Why this name**: <decisive reasoning; mention what changed after reading if relevant>
- **Migration scope**: <source/tests/docs/API/wire/persistence/generated artifacts>

## Rename Plan
- **Order**: <public/domain names before dependent locals>
- **Compatibility**: <required contract or no shim>
- **Validation**: <search/typecheck/contract/doc checks>

## Names To Avoid
- `<name>`: <misleading meaning>
```

For many names, use a compact table:

```markdown
| Current | Recommended | Evidence-backed reason | Migration scope |
|---------|-------------|------------------------|-----------------|
| `<old>` | `<new>` | <reason> | <scope> |
```
