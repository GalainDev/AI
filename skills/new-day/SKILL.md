---
name: new-day
description: Resume work carefully at the start of a session using a handoff, Chronicle, and Beads. Use when the user explicitly asks to resume, pick up where they left off, or invokes new-day, to recover project state, verify prior work, identify blockers, and propose the next step before changing code.
---

# New Day

Resume work carefully. Do not change code until the user confirms the plan.

1. **Find the handoff.** Use a handoff path supplied with the request when present. Otherwise, automatically select the most recent file under `.claude/handoffs/` by modification time. Report which file was selected; do not ask the user to choose among older handoffs unless the newest file cannot be read or its intended repository is ambiguous.

2. **Verify it.** Use the resume-handoff skill to read the entire handoff and verify its Git state, referenced artifacts, and lessons against the current workspace. For a cross-repository workspace, check every repository named by the handoff. A handoff is evidence to verify, not truth to trust blindly.

3. **Re-orient from Chronicle.** If `.chronicle/` exists, resolve the vault (walk upward for `.chronicle/`, falling back to the configured global vault) and read the relevant project note, decisions, runbooks, and current capability spec before treating the handoff as complete context.

4. **Check live task state.** If `.beads/` exists, run `bd prime`, `bd ready`, `bd list --status=in_progress`, and `bd blocked`. Read every in-progress issue and the recommended next issue. Treat Beads as the operational source for claims, dependencies, blockers, and completion. Do not run `bd dolt push` or `bd dolt pull` unless the user explicitly asks.

5. **Report.** Give a concise readout covering verified handoff state and drift, relevant Chronicle requirements and decisions, live task work and blockers, open user decisions, and the recommended next step.

6. **Wait.** Get the user's approval before changing any code.
