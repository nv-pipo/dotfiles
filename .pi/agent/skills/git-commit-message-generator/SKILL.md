---
name: git-commit-message-generator
description: "Generate the best 3 git commit message suggestions for currently staged files using the /codegraph skill for semantic context and the bin/git-commit-context.sh helper script for diff inspection, then present them to the user, ask the user to decide, and perform the actual git commit with the chosen message. Use this skill when the user wants to commit staged changes."
---

# Git Commit Skill

This skill produces the **best 3 git commit message suggestions** for the files currently staged in git, combines raw diff inspection (via the `bin/git-commit-context.sh` helper script) with semantic code-graph context (`/codegraph`) to understand *what* changed and *why*, presents three conventional, focused candidate commit messages ranked from best to worst, then **asks the user to decide** which message to use and performs the actual `git commit` with their choice.

## Purpose

- The skill **generates and presents** three ranked commit message suggestions for the staged changes.
- It then **asks the user to make a decision** about the commit (which message to use, or to abort).
- After the user decides, the skill **executes the actual `git commit`** with the chosen message.
- The only permitted sources of information are:
  1. `bash <skill_dir>/bin/git-commit-context.sh` — run exactly once (step 1).
  2. `codegraph` commands — for semantic context (step 2).
- **NEVER run any `git` command directly for inspection.** Not `git status`, not `git diff`, not `git log` — nothing. The helper script already runs every read-only git command needed.
- The only `git` command you are allowed to run directly is `git commit` in step 6, and only after the user has explicitly chosen the message. Never run other mutating or destructive commands (`git checkout`, `git restore`, `git reset`, `git clean`, `git rm`, `git switch`, `git rebase`, `git stash`, `git push`).
- Do not stage files, do not amend history, do not push, do not run formatters, do not modify code — the only change made to the repository is the single `git commit` in step 6.

## Workflow

### 1. Gather the staged changes (helper script)

The message must reflect *staged* changes only. Never inspect unstaged or untracked files unless the user asks.

- **Do not change directories.** The helper script must be run from the root of the git repo.
- **Run the helper script `git-commit-context.sh` exactly once, in a single `bash` invocation.** It lives next to this SKILL.md and runs all required read-only `git` commands sequentially in one shot. Do NOT run any `git` command yourself for inspection and do NOT run the script more than once.

```bash
bash <skill_dir>/bin/git-commit-context.sh   # run ONCE — collects all git context
```

The script runs `git status`, `git log --oneline -10`, `git diff --staged --stat`, and `git diff --staged` sequentially via `set -x` (each command echoed as a `+ <command>` line before its output) — combine all sections (state, scope, changes, style) to generate the commit message.

### 2. Enrich with semantic context (codegraph)

Load the `/codegraph` skill and use it to understand the meaning of the changed symbols — their callers, callees, and impact — so the message explains *intent*, not just line-level edits.

```bash
codegraph status                         # ensure index is present; sync if stale
codegraph sync                           # refresh if needed
codegraph node <changed_symbol_or_file>  # source + caller/callee trail for a staged path
codegraph callers <symbol>               # who depends on changed code (impact)
codegraph impact <symbol>                # blast radius for a changed symbol
codegraph affected <staged files...>     # related tests that the change touches
```

Use codegraph when the diff is non-trivial: new/renamed symbols, changed function signatures, refactors, or behavior changes. For tiny cosmetic edits (whitespace, comments, formatting), skip codegraph and rely on the diff alone.

### 3. Synthesize 3 commit message suggestions

Combine the diff (what) and the graph (why) into **three** candidate commit messages following these rules:

- **Conventional Commits** format unless the repo's `git log` output (from the helper script) clearly uses another convention. Match the repo's existing style when it's consistent:
  - Summary: `<type>(<optional scope>): <imperative summary>`
  - Body (only if requested): `<body explaining why, referencing affected symbols/tests when useful>`
- Type is one of: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- **Summary line:** imperative mood ("add", "fix", "refactor"), ≤ ~72 chars, no trailing period. Describe the change, not the diff.
- **Body is provided only if the user asks for it** (e.g., "include a body", "explain why", "add detail"). When the user does ask for a body, generate it for each suggestion, wrap it at ~72 cols, explain the *why* and any non-obvious *what* — pull the rationale from codegraph impact/caller analysis — and reference affected tests from `codegraph affected` when relevant.
- **One logical change per commit.** If staged changes span multiple unrelated concerns, flag it as **option 3** (see step 4) — do not produce commit messages for the set as-is and do not invent groupings or suggest splits beyond flagging it for review.
- **No hallucination.** Only reference symbols, files, tests, and behaviors that actually appear in the diff or codegraph output.
- Do not add AI attribution, Co-Authored-By, or Generated-with lines unless the user explicitly asks.

### 4. Present the suggestions

Determine which of the three mutually-exclusive options below applies and present it.

**Option 1 — single logical change, no body requested:**

Output three ranked summary-line suggestions as plain text, numbered 1–3 from best to worst.

1. feat(auth): validate token expiry before refresh
2. fix(auth): guard refresh against already-expired tokens
3. refactor(auth): check token expiry prior to refresh

**Option 2 — user explicitly asked for a body (single logical change):**

Output three ranked suggestions, each consisting of a summary line, a blank line, then a body. Separate each suggestion with a blank line and a `---` divider line.

```
1. feat(auth): validate token expiry before refresh

Token refresh previously fired regardless of expiry, causing redundant
network calls. Guard `refreshToken` with an `isExpired` check and add a
unit test covering the near-expiry path. Affects `AuthMiddleware` callers.

2. fix(auth): guard refresh against already-expired tokens

Refreshing an already-expired token produced redundant network calls.
Add an `isExpired` guard in `refreshToken` and cover the near-expiry
path with a unit test. Impacts `AuthMiddleware` callers.

3. refactor(auth): check token expiry prior to refresh

Centralize expiry handling in `refreshToken` via an `isExpired` check so
refresh is skipped when unnecessary. Add a unit test for the near-expiry
path; `AuthMiddleware` callers benefit from fewer redundant calls.
```

**Option 3 — staged files do not form a single logical change:**

Do **not** produce commit messages. Output the warning below (no commit messages) and **do not proceed to a commit** — ask the user whether they want to review the staged set themselves, and do not run `git commit` until the staged set is made into a single logical change:

```
Staged set DOES NOT look like a single logical change. Please review.
- potential logical change 1
- potential logical change 2
```

Replace `potential logical change N` with a short label for each distinct concern you can identify in the staged set. Wait for the user's instructions before reconsidering.

### 5. Ask for the user's decision

After presenting the suggestions, **ask the user which commit message they want to use**, offering the options:

- commit with suggestion **1**, **2**, or **3** (exact message lines as presented);
- a **custom** message they supply;
- **abort** (do not commit).

If option 3 (not a single logical change) fired, do not present commit options; instead ask the user how they want to proceed.

### 6. Perform the commit

- Only after the user has explicitly chosen a message, run the commit with that exact chosen message (summary only, or summary+body) against the **staged** files.
- Run **exactly one** `git commit` command. Use an explicitly invented message of `git commit -m`, or for multi-paragraph messages use `git commit -F -` feeding the message on stdin (summary as the first line, blank line, then body). Never use shell interpolation that could mangle the message; pass the message safely.
- The command's working repo will be the current directory (the git repo root).
- After the commit, confirm success (check the commit succeeds / report errors). Do not push unless explicitly asked. Do not amend.
- If the commit fails (e.g., nothing staged from a newline check), report the failure and stop.

## Rules

- **Never run mutating git commands except the single `git commit` in step 6**, and that commit only after the user has explicitly chosen its message.
- Inspect **staged** changes only (the helper script uses `git diff --staged`), never unstaged/untracked unless asked.
- If nothing is staged, say so and stop — do not fabricate messages and do not commit.
- The user's decision is required before any commit. Never commit without an explicit, in-flow user choice.
- When you are about to commit, use the exact chosen message. Do not silently substitute a different one.
- Do not add AI attribution or Co-Authored-By lines unless requested.
- The skill output in step 4 must be ONLY the selected option — no preamble, no reasoning, no code fences.