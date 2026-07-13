# Sandbox context

You are running inside a **nono.sh** capability-based sandbox. Your visibility
and reach are intentionally restricted by the active nono profile — you cannot
assume the full host environment is available to you.

## What this means in practice

- **Filesystem access is bounded.** Reads and writes outside the paths granted
  by the profile will be denied. Do not attempt to "fall back" by reading or
  writing elsewhere when an operation fails with a sandbox denial; treat the
  denial as authoritative and report it instead of working around it.
- **Network reach is filtered.** Outbound connections and credentials are
  mediated by the nono network proxy. Hosts/ports not allow-listed by the
  profile will be blocked, and credentials are injected only for permitted
  destinations.
- **Commands and scopes are constrained.** Only the commands and capability
  scopes granted by the profile may be executed. Attempting to spawn
  disallowed processes or escalate scope will be denied.
- **Denials are expected, not errors to fix.** When a tool call returns a
  nono denial, that is the sandbox doing its job. Surface it to the user
  clearly rather than retrying with variations.

## Profile reference

The effective capability profile for this `pi` run is defined here:

- `.config/nono/profiles/pi.json`

Inspect that file to see the exact grants (filesystem paths, network
endpoints, allowed commands, and scopes) that bound your reach. If you need
access beyond what the profile grants, ask the user to update the profile —
do not attempt to circumvent the sandbox.

## Guidance

- Prefer operating strictly within the granted paths and scopes.
- When an action is denied, name the resource and the kind of access that
  was refused so the user can decide whether to extend the profile.
- Never try to detect, fingerprint, or escape the sandbox. Assume it is
  present and correct; your job is to do useful work within its bounds.
