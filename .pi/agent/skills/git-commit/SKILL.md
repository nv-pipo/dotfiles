---
name: git-commit
description: "Generate a git commit message for currently staged files using the /codegraph skill for semantic context and `git` for diff inspection. Use this skill when the user wants a commit message suggestion for staged changes. Only generate the message; commit only if explicitly asked, using `git`."
model: openrouter/qwen/qwen3.6-35b-a3b
thinking: off
---

# Git Commit Skill

This skill produces a high-quality **git commit message** for the files currently staged in git. It combines raw diff inspection (`git`) with semantic code-graph context (`/codegraph`) to understand *what* changed and *why*, then writes a conventional, focused commit message.

## Scope

- **Do only what is asked.** The default task is to *generate a commit message* — nothing else. Do not stage files, do not amend history, do not push, do not run formatters, and do not modify code.
- **Commit only when explicitly requested.** If the user later says to commit (e.g., "commit it", "go ahead and commit", "apply that message"), execute the commit with `git` using the generated message. Otherwise, stop after presenting the message.

## Workflow

### 1. Gather the staged changes (git)

Use `git` directly to inspect what is staged. Never inspect unstaged or untracked files unless the user asks — the message must reflect *staged* changes only.

```bash
git status --short          # see staged (and other) paths
git diff --cached --stat    # summary of staged hunks
git diff --cached           # full staged diff
git log --oneline -10       # match the repo's existing commit style/conventions
```

Notes:
- `git diff --cached` shows **staged** changes. Use this, not `git diff`.
- If nothing is staged (`git diff --cached --quiet` exits 0), tell the user there is nothing staged and stop. Do not invent a message.

### 2. Enrich with semantic context (codegraph)

Load the `/codegraph` skill and use it to understand the meaning of the changed symbols — their callers, callees, and impact — so the message explains *intent*, not just line-level edits.

```bash
codegraph status                           # ensure index is present; sync if stale
codegraph sync                              # refresh if needed
codegraph node <changed_symbol_or_file>     # source + caller/callee trail for a staged path
codegraph callers <symbol>                  # who depends on changed code (impact)
codegraph impact <symbol>                   # blast radius for a changed symbol
codegraph affected <staged files...>        # related tests that the change touches
```

Use codegraph when the diff is non-trivial: new/renamed symbols, changed function signatures, refactors, or behavior changes. For tiny cosmetic edits (whitespace, comments, formatting), skip codegraph and rely on the diff alone.

### 3. Synthesize the commit message

Combine the diff (what) and the graph (why) into a single commit message following these rules:

- **Conventional Commits** format unless the repo's `git log` clearly uses another convention. Match the repo's existing style when it's consistent.
  ```
  <type>(<optional scope>): <imperative summary>

  <body explaining why, referencing affected symbols/tests when useful>
  ```
- Type is one of: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- **Summary line:** imperative mood ("add", "fix", "refactor"), ≤ ~72 chars, no trailing period. Describe the change, not the diff.
- **Body is omitted by default.** Only include a body when the user explicitly asks for one (e.g., "include a body", "explain why", "add detail"). When the user does ask for a body, wrap it at ~72 cols, explain the *why* and any non-obvious *what* — pull the rationale from codegraph impact/caller analysis — and reference affected tests from `codegraph affected` when relevant.
- **One logical change per commit.** If staged changes span multiple unrelated concerns, say so and suggest splitting the commit (list the suggested groupings), but still provide one message for the staged set as-is.
- **No hallucination.** Only reference symbols, files, tests, and behaviors that actually appear in the diff or codegraph output.
- Do not include Claude/AI attribution, Co-Authored-By, or Generated-with lines unless the user explicitly asks.

### 4. Present the message

Output **only** the proposed commit message in a fenced code block, plus a one-line note on whether the staged set looks like a single logical change or should be split. Do not commit.

By default, output **only the summary line** — no body:

```
feat(auth): validate token expiry before refresh
```

If the user explicitly asked for a body, include it:

```
feat(auth): validate token expiry before refresh

Token refresh previously fired regardless of expiry, causing redundant
network calls. Guard `refreshToken` with an `isExpired` check and add a
unit test covering the near-expiry path. Affects `AuthMiddleware` callers.
```

*Staged set looks like a single logical change.*

### 5. Commit on request only

If and only if the user asks to commit (after seeing the message), run:

```bash
git commit -m "<summary>"                  # summary only by default
git commit -m "<summary>" -m "<body>"        # only when a body was requested
# or, if the body has structure that -m mangles, use a file:
git commit -F <(printf '%s\n' "$MESSAGE")
```

- Use the **exact** message generated in step 3 (or the user's edited version if they tweak it).
- Do **not** add `--amend`, `--no-verify`, flags to push, or any flags the user did not ask for.
- After committing, report the new commit hash and its one-line subject (`git log -1 --oneline`), then stop. Do not push.

## Rules

- Inspect **staged** changes only (`git diff --cached`), never unstaged/untracked unless asked.
- If nothing is staged, say so and stop — do not fabricate a message.
- Generate the message; do not commit unless explicitly asked.
- When asked to commit, use `git` directly with the generated message; no extra flags, no push.
- Use `/codegraph` for semantic *why* context on non-trivial diffs; skip it for cosmetic changes.
- Match the repo's existing commit conventions when they are clear from `git log`.
- Keep the summary ≤ ~72 chars, imperative mood, no trailing period.
- Omit the body by default; include one only when the user explicitly asks for it.
- Never invent symbols, tests, or behaviors not present in the diff or codegraph output.
- Do not add AI attribution or Co-Authored-By lines unless requested.
