---
name: wind-down
description: Wrap up a work session using repository state, Beads, Chronicle, and a durable handoff. Use when the user explicitly asks to wrap up, close out, or invokes wind-down, to preserve accurate project context and prepare the next session without committing, pushing, or remote syncing.
---

# Wind Down

Wrap up the current work session without committing, pushing, or remotely syncing unless the user explicitly asks.

1. **Ground in reality.** Run `git status` and relevant `git log`/branch commands in every repository touched during the session.

2. **Reconcile tasks.** If `.beads/` exists, inspect `bd list --status=in_progress` and `bd blocked`, then update only issues supported by evidence. Close only genuinely complete work; create a follow-up issue when a distinct task remains. Record issue IDs, statuses, blockers, and the next ready work. Do not run `bd dolt push` or `bd dolt pull` unless the user explicitly asks.

3. **Update durable knowledge.** If `.chronicle/` exists, update the relevant project note and capture any durable decision, architecture fact, or runbook. Treat Chronicle as the source of truth for requirements and durable context, not a duplicate execution queue. Run `chron lint` and fix its findings.

4. **Write the handoff.** Use the create-handoff skill. Include exact Git state, uncommitted files and why they remain, task status and blockers, open user decisions, validations performed and their results, and ordered next steps.

5. **Report.** State the handoff path and say it can be resumed with the new-day or resume-handoff skill.
