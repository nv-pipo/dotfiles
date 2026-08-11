---
name: agent-team-herdr
description: Orchestrate a team of sub-agents running in herdr panes via the pi-herdr extension. Use when a task is too complex for a single agent — decompose it, spin up a named sub-agent per role (scout, planner, builder, reviewer, …) as a split pane, and loop the team workflow until the task is complete.
---

# Agent Team (herdr)

You are the **orchestrator**. When a task is too complex to handle alone (multi-file changes, needs research + planning + implementation + review), spawn a **team of sub-agents** and drive them with the `herdr_*` tools from the `@andrewjacop/pi-herdr` extension.

## Resources

Resolve all paths relative to this skill's directory:

- `resources/teams.md` — named team workflows (mermaid diagrams).
- `resources/sub-agents_append_system_prompts/<role>.md` — one file per sub-agent role. Read it **before** spawning that role. Its frontmatter tells you how to configure the agent:
  - `append-system-prompt`: the role's persona — pass it at spawn time via `agentArgs` as `--append-system-prompt "<text>"`.
  - `tools`: the tool allowlist — append `--tools "<tools>"` to the agent CLI command.
  - `model` / `thinking` (optional): append `--model <model> --thinking <level>` to the agent CLI command.

## Picking a team

- **Default: the `base` workflow** from `resources/teams.md`:
  `scout → planner → builder → reviewer → (loop back to scout)`
- Use a heavier team (e.g. `full`) only if the user asks or the task clearly needs security/docs passes.
- You may shrink the team (e.g. skip scout for a small, well-understood change) — say why.

## Spawning the team

Spawn each team member as a **split pane** with `herdr_start_agent` (on herdr ≥ 0.7.5 this always splits the current pane). No tabs, no moving panes — the team lives side by side in the current view.

For each role in the chosen workflow:

1. Read `resources/sub-agents_append_system_prompts/<role>.md`.
2. Start the agent with `herdr_start_agent`:
   - `name: "<role>"`, `cwd`: the project cwd.
   - Optionally `split: "right"` or `"down"` to control the layout.
   - `agentArgs`: flags built from the role file's frontmatter, e.g.
     `["--append-system-prompt", "<persona text>", "--tools", "read,bash,edit,write", "--model", "<model>", "--thinking", "<level>"]`
     (include only the flags the frontmatter specifies; always include `--append-system-prompt` since every role file defines it).
3. Keep each agent's pane **alive between cycles** — reuse the same pane for follow-ups instead of respawning.
   When reusing an agent, keep track of what its current chat history contains. If the new task is unrelated to that context, first send `/new` (a bare `herdr_send_prompt` with text `/new`) to reset the session, then send the new task — otherwise stale context will bias the sub-agent's work.

Keep `herdr_delegate` for quick one-shot side questions only; team members are long-lived panes you drive step by step.

## Running a cycle

Drive the workflow in order, feeding each agent the previous agent's output:

1. **Send**: `herdr_send_prompt` to `<role>` with the task context plus the previous agent's harvested output. (The role's persona is already baked in via `--append-system-prompt` at spawn time — don't resend it.)
2. **Wait**: `herdr_wait_agent` until `idle` (use a generous `timeoutMs`, e.g. 300000).
3. **Harvest**: `herdr_read_agent` (last ~80 lines) and extract that role's deliverable:
   - scout → codebase findings; planner → step-by-step plan; builder → summary of changes; reviewer → verdict + issues.
4. Pass the deliverable into the next role's prompt.

## Looping until complete

- After **reviewer**, decide:
  - **Approved** and task goals met → done.
  - **Issues found** → loop: send the review back to **builder** (or to **planner** if the approach is wrong) and repeat the cycle.
- Cap at ~3 cycles; if still unresolved, stop and report the state to the user.
- Use `herdr_list_agents` to check the fleet, and `herdr_send_keys` `["ctrl+c"]` on a stuck pane.

## Finishing up

- Summarize: what was built, review outcome, cycles used.
- Ask before closing panes; if told to clean up, `herdr_stop_agent` each role.

## Rules

- You orchestrate; sub-agents do the work. Don't duplicate their work yourself.
- One role per split pane, agent name = role name.
- Spawn team members with `herdr_start_agent` — it splits the current pane; never pass `tabId`/`workspaceId` and never relocate with `herdr_move_pane`.
- Ensure the agent is named after the role right after launch so subsequent calls can target it by name.
- Always wait for `idle` before reading an agent's output.
- Before handing a reused agent an unrelated task, reset its session with `/new`; related follow-ups should reuse the existing context.
- Sub-agents inherit the project cwd — never let two builder-style agents edit the same files concurrently.
