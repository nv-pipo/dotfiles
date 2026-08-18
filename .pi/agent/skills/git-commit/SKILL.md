---
name: git-commit
description: "Generate the best 3 git commit message suggestions for currently staged files using the /codegraph skill for semantic context and the bin/git-commit-context.sh helper script for diff inspection. Use this skill when the user wants commit message suggestions for staged changes. Only generate and print the messages; NEVER run any git command directly."
---

# Git Commit Skill

This skill produces the **best 3 git commit message suggestions** for the files currently staged in git. It combines raw diff inspection (via the `bin/git-commit-context.sh` helper script) with semantic code-graph context (`/codegraph`) to understand *what* changed and *why*, then prints three conventional, focused candidate commit messages ranked from best to worst.

## Sole purpose — read this first

- **The ONLY job of this skill is to PRINT commit message suggestions.** Nothing more.
- The only two permitted sources of information are:
  1. `bash <skill_dir>/bin/git-commit-context.sh` — run exactly once (step 1).
  2. `codegraph` commands — for semantic context (step 2).
- **NEVER run any `git` command directly.** Not `git status`, not `git diff`, not `git log`, not `git add`, not `git commit`, not `git stash` — nothing. The helper script already runs every read-only git command needed.
- **Under NO circumstances run mutating or destructive git commands**, especially `git checkout`, `git restore`, `git reset`, `git clean`, `git rm`, `git switch`, `git rebase`, or `git commit`. These are strictly forbidden in every situation, even if the user seems to ask for them mid-flow — if the user wants to commit or modify the working tree, tell them to do it themselves.
- Do not stage files, do not amend history, do not push, do not run formatters, do not modify code, do not touch the working tree in any way.

## Workflow

### 1. Gather the staged changes (helper script)

The message must reflect *staged* changes only. Never inspect unstaged or untracked files unless the user asks.

- **Do not change directories.** pi is already running at the root of the git repo.
- **Run the helper script `git-commit-context.sh` exactly once, in a single `bash` invocation.** It lives next to this SKILL.md and runs all required `git` commands sequentially in one shot. Do NOT run any `git` command yourself, and do NOT run the script more than once.
- **The helper script is the ONLY allowed way to inspect the changes** (apart from the codegraph command suggestions in step 2). Do not run any other command to extract the changes.

```bash
bash <skill_dir>/bin/git-commit-context.sh   # run ONCE — collects all git context
```

The script runs `git status`, `git diff --staged --stat`, `git diff --staged`, and `git log --oneline -10` sequentially via `set -x` (each command echoed as a `+ <command>` line before its output) — combine all sections (state, scope, changes, style) to generate the commit message.

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

### 3. Synthesize 3 commit message suggestions

Combine the diff (what) and the graph (why) into **three** candidate commit messages following these rules:

- **Conventional Commits** format unless the repo's `git log` output (from the helper script) clearly uses another convention. Match the repo's existing style when it's consistent:
  - Summary: `<type>(<optional scope>): <imperative summary>`
  - Body (only if requested): `<body explaining why, referencing affected symbols/tests when useful>`
- Type is one of: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
- **Summary line:** imperative mood ("add", "fix", "refactor"), ≤ ~72 chars, no trailing period. Describe the change, not the diff.
- **Body is omitted by default.** Only include a body when the user explicitly asks for one (e.g., "include a body", "explain why", "add detail"). When the user does ask for a body, wrap it at ~72 cols, explain the *why* and any non-obvious *what* — pull the rationale from codegraph impact/caller analysis — and reference affected tests from `codegraph affected` when relevant.
- **One logical change per commit.** If staged changes span multiple unrelated concerns, treat it as **option 3** (see step 4) — do not produce commit messages for the set as-is. Do not invent groupings or suggest specific splits beyond flagging that it should be reviewed.
- **No hallucination.** Only reference symbols, files, tests, and behaviors that actually appear in the diff or codegraph output.
- Do not include Claude/AI attribution, Co-Authored-By, or Generated-with lines unless the user explicitly asks.

### 4. Present the suggestions

Determine which of the three mutually-exclusive options below applies, then output **exactly that option and nothing else**. The ENTIRE response body must be only the option — no preamble, no reasoning, no explanation of the change, no "this is a cosmetic update" or similar introduction, no trailing commentary, no "looks like a single logical change" note, no questions, no code fences (```), no Markdown formatting, no surrounding backticks. If the option is a set of commit messages (options 1 or 2), your full response is the ranked list of three suggestions and nothing else. Do not commit — committing is the user's job, never yours.

**Option 1 — default (single logical change, no body requested):**

Output only three ranked summary-line suggestions as plain text, numbered 1–3 from best to worst, each on its own line with no code fence and no surrounding backticks.

1. feat(auth): validate token expiry before refresh
2. fix(auth): guard refresh against already-expired tokens
3. refactor(auth): check token expiry prior to refresh

**Option 2 — user explicitly asked for a body (single logical change):**

Output three ranked suggestions, each consisting of a summary line, a blank line, then a body — all as plain text, with no code fence and no surrounding backticks. Separate each suggestion with a blank line and a `---` divider line.

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

**Option 3 — staged files do not form a single logical change:**

Do **not** produce commit messages. Output only the literal warning below (no code fence, no Markdown formatting, no suggested groupings, no commit messages):

*Staged set DOES NOT look like a single logical change. Please review*
- potential logical change 1
- potential logical change 2

Replace `potential logical change N` with a short label for each distinct concern you can identify in the staged set. Do not invent commits or suggest specific file splits; just label the concerns at a high level. Do not fall back to option 1 or 2 for a multi-concern set.

## Rules

- **NEVER run any `git` command directly.** All git context comes exclusively from one single run of `bin/git-commit-context.sh`. Running `git checkout`, `git restore`, `git reset`, `git clean`, `git add`, `git commit`, `git stash`, `git push`, or any other `git` subcommand yourself is strictly forbidden — no exceptions.
- The skill's output ends at printed message suggestions. It does not commit, stage, unstage, or otherwise modify the repository or working tree — ever.
- Inspect **staged** changes only (the helper script uses `git diff --staged`), never unstaged/untracked unless asked.
- If nothing is staged, say so and stop — do not fabricate messages.
- Generate three ranked suggestions and stop. If the user asks you to commit, decline and remind them to run `git commit` themselves with the chosen message.
- Use `/codegraph` for semantic *why* context on non-trivial diffs; skip it for cosmetic changes.
- **The response must be ONLY the selected option.** Never output reasoning, preamble, explanations of the change (e.g. "this is a cosmetic update"), trailing notes, code fences (```), or surrounding Markdown/backtick formatting. For options 1 and 2 the entire response is the ranked list of three commit message suggestions and nothing else.
- Output **exactly one** of the three options defined in step 4. Single logical change + no body requested → option 1 only; body requested → option 2 only; not a single logical change → option 3 only (no messages, no fallback to 1 or 2).
- The three suggestions must be meaningfully distinct from each other (different type, scope, or framing) — not three trivial rephrasings of the same wording.
- Rank suggestions from best (1) to worst (3) by accuracy and clarity of the change description.
- Match the repo's existing commit conventions when they are clear from the `git log` section of the helper script output.
- Keep each summary ≤ ~72 chars, imperative mood, no trailing period.
- Omit the body by default; include one only when the user explicitly asks for it.
- Never invent symbols, tests, or behaviors not present in the diff or codegraph output.
- Do not add AI attribution or Co-Authored-By lines unless requested.
