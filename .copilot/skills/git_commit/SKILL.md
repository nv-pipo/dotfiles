---
name: git-commit
description: >
  Generate a concise, well-structured git commit message from staged changes
  following Conventional Commits 1.0.0. Use when asked to generate a commit
  message, write a git commit message, or commit changes.
---

# Generate Git Commit Message

## Description

Generate a concise, well-structured git commit message from the staged changes (diff) following the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification.

## Instructions

When the user asks you to generate a commit message, write a git commit message, or any similar request:

1. **Analyze the staged diff** provided by the user (or retrieved from `git diff --cached`).
2. **Determine the primary type** of change from the diff. Use one of the following types:
   - `feat` – a new feature (correlates with MINOR in SemVer)
   - `fix` – a bug fix (correlates with PATCH in SemVer)
   - `docs` – documentation-only changes
   - `style` – changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc.)
   - `refactor` – a code change that neither fixes a bug nor adds a feature
   - `perf` – a code change that improves performance
   - `test` – adding missing tests or correcting existing tests
   - `build` – changes that affect the build system or external dependencies
   - `ci` – changes to CI configuration files and scripts
   - `chore` – other changes that don't modify src or test files
   - `revert` – reverts a previous commit
3. **Determine the scope** (optional). The scope is a noun describing the section of the codebase affected (e.g., `api`, `auth`, `parser`, `ui`). Include it in parentheses after the type when the change is clearly scoped to a specific module or component.
4. **Write the subject line** following this format:
   ```
   <type>[optional scope]: <description>
   ```
   - The description MUST start with a lowercase letter.
   - The description MUST be imperative mood, present tense (e.g., "add", not "added" or "adds").
   - The description MUST NOT end with a period.
   - The entire subject line SHOULD be 72 characters or fewer.
5. **Write the body** (optional). If the diff is non-trivial and the "why" behind the change is not obvious from the subject alone, include a body:
   - Separate the body from the subject with one blank line.
   - Wrap each line at 72 characters.
   - Use the body to explain **what** changed and **why**, not *how* (the diff shows how).
   - Use bullet points (prefixed with `- `) for multiple distinct changes.
6. **Write footer(s)** (optional). Add footers when applicable:
   - `BREAKING CHANGE: <description>` – if the change introduces a breaking API change. Also append `!` after the type/scope in the subject line.
   - `Refs: #<issue-number>` – to reference related issues or tickets.
   - `Reviewed-by: <name>` – if applicable.
   - `Co-authored-by: Name <email>` – for co-authored commits.
   - Footer tokens use `-` in place of spaces (e.g., `Acked-by`, `Signed-off-by`).

## Output Format

Return **only** the commit message — no explanations, no markdown code fences, no commentary. The message must be ready to paste directly into a git commit.

## Examples

### Simple feature

```
feat(auth): add OAuth2 login support
```

### Bug fix with body

```
fix(api): handle null response from payment gateway

The payment gateway occasionally returns null instead of an error
object when the service is degraded. Add a null check before
accessing response properties to prevent unhandled TypeError.

Refs: #452
```

### Breaking change

```
feat(config)!: migrate configuration to YAML format

Replace JSON-based configuration with YAML to support comments and
multi-line strings. Existing JSON config files must be converted
using the included migration script.

BREAKING CHANGE: configuration files must now use `.yaml` extension
and follow the new schema. Run `npx migrate-config` to convert.
```

### Documentation change

```
docs: update API authentication guide
```

### Refactor with scope

```
refactor(db): extract connection pooling into dedicated module

- Move pool creation logic from `db/index.ts` to `db/pool.ts`
- Expose configurable pool size via environment variable
- Remove duplicated connection retry logic
```

### Multiple footers

```
fix: prevent racing of concurrent API requests

Introduce a request ID and reference to the latest request. Dismiss
incoming responses other than from the latest request.

Reviewed-by: Alice
Refs: #123
```

### Revert

```
revert: feat(auth): add OAuth2 login support

Refs: a3f2b1c
```

## Rules

- Always follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).
- Use **imperative mood** in the subject (e.g., "add" not "added" or "adds").
- Subject line must be **72 characters or fewer**.
- Do **not** end the subject line with a period.
- Start the description with a **lowercase** letter.
- If the diff contains multiple unrelated changes, suggest the user split them into separate commits.
- When the change is clearly a breaking change, always include `!` after the type/scope **and** a `BREAKING CHANGE:` footer.
- Prefer specific scopes over generic ones (e.g., `auth` over `utils`).
- When in doubt between types, prefer the more specific one (e.g., `perf` over `refactor` for performance improvements).
