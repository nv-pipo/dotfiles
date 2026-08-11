---
name: agent-team-herdr
description: Orchestrate a team of sub-agents running in herdr panes via the pi-herdr extension. Use when a task is too complex for a single agent — decompose it, spin up a named sub-agent per role (scout, planner, builder, reviewer, …) in its own herdr tab, and loop the team workflow until the task is complete.
---

# Agent Team (herdr)

You are the **orchestrator**. When a task is too complex to handle alone (multi-file changes, needs research + planning + implementation + review), spawn a **team of sub-agents** and drive them with the `herdr_*` tools from the `@andrewjacop/pi-herdr` extension.

## Resources

Resolve all paths relative to this skill's directory:

- `resources/teams.md` — named team workflows (mermaid diagrams).
- `resources/sub-agents_append_system_prompts/<role>.md` — one file per sub-agent role. Read it **before** spawning that role. Its frontmatter tells you how to configure the agent:
  - `append-system-prompt`: the role's persona — include this text in the prompt you send.
  - `tools`: the tool allowlist — pass to `herdr_start_agent` as `agentArgs: ["--tools", "<tools>"]`.
  - `model` / `thinking` (optional): pass as `agentArgs: ["--model", "<model>", "--thinking", "<level>"]`.

## Picking a team

- **Default: the `base` workflow** from `resources/teams.md`:
  `scout → planner → builder → reviewer → (loop back to scout)`
- Use a heavier team (e.g. `full`) only if the user asks or the task clearly needs security/docs passes.
- You may shrink the team (e.g. skip scout for a small, well-understood change) — say why.

## Spawning the team

For each role in the chosen workflow:

1. Read `resources/sub-agents_append_system_prompts/<role>.md`.
2. Create a **tab named after the role** so each sub-agent is easy to find:
   - `herdr_create_tab` with `label: "<role>"` and the project `cwd`.
3. Start the agent in that tab:
   - `herdr_start_agent` with `name: "<role>"`, `tabId` from step 2, `cwd` = project root, and `agentArgs` built from the role file's frontmatter (`--tools`, `--model`, `--thinking`).
4. Keep each agent's pane **alive between cycles** — reuse the same pane for follow-ups instead of respawning.

Keep `herdr_delegate` for quick one-shot side questions only; team members are long-lived panes you drive step by step.

## Running a cycle

Drive the workflow in order, feeding each agent the previous agent's output:

1. **Send**: `herdr_send_prompt` to `<role>` with:
   - the role's `append-system-prompt` text (first message only; the pane remembers it afterwards),
   - the task context plus the previous agent's harvested output.
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
- Ask before closing panes; if told to clean up, `herdr_stop_agent` each role and `herdr_close_tab` its tab.

## Rules

- You orchestrate; sub-agents do the work. Don't duplicate their work yourself.
- One role per tab, tab label = role name, agent name = role name.
- Always wait for `idle` before reading an agent's output.
- Sub-agents inherit the project cwd — never let two builder-style agents edit the same files concurrently.
