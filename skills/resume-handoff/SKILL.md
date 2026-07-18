---
name: resume-handoff
description: Resume work from a previously written handoff document — read it fully, verify the recorded git state and referenced artifacts still hold, and propose a concrete plan before touching anything. Use this whenever the user wants to pick up where they left off, references a handoff file path or says "resume from handoff", asks what they were working on, wants to continue a previous session's work, or when a repo has a `.claude/handoffs/` directory and the user is clearly continuing prior work without saying so explicitly.
---

# Resume Handoff

The handoff document you're reading was written by a session with full context that
you don't have. Your job is to reconstruct that context accurately — and to catch
anywhere the world has moved on since it was written, not just parrot it back.

## Step 1: Locate the handoff

- **A file path was given**: use it directly.
- **No path given**: list `.claude/handoffs/<repo-name>/` (repo name from
  `basename "$(git rev-parse --show-toplevel)"`). If there's exactly one file, use it.
  If there are several, pick the most recent by filename timestamp — but confirm with
  the user rather than assuming, since an older handoff may be the one they mean.
  If the directory doesn't exist or is empty, say so plainly and ask for a path.

## Step 2: Read and verify

1. **Read the entire handoff document.** Not a summary pass — every section informs
   the plan you'll propose.
2. **Read every file referenced in Artifacts and Learnings.** If subagents are
   available, spawn them in parallel to read and summarize; otherwise read inline.
   Don't skip this because the handoff already describes the content — descriptions
   can be stale, and you need to verify, not trust blindly.
3. **Check whether the recorded state still holds:**
   - Compare `git_commit` and `branch` in the frontmatter against the current
     `git rev-parse --short HEAD` and `git branch --show-current`. If they differ,
     the codebase has moved since the handoff was written — figure out what changed
     (`git log <old-commit>..HEAD --oneline`) before assuming anything in the handoff
     is still accurate.
   - Confirm every file in Artifacts still exists at the stated path.
   - Spot-check that claims in Learnings still match what the code actually does now.

## Step 3: Present your analysis before acting

Never jump straight into implementation. Synthesize what you found:

```
I've read the handoff from [date] covering [topic]. Here's where things stand:

**Original tasks:** [status from handoff] → [what's actually true now]

**State check:** [git_commit matches / has moved N commits — summarize what changed]
[artifacts all present / X is missing or changed]

**Learnings still valid:** [confirm or flag anything that's changed]

**Recommended next step:** [the handoff's Action Items, adjusted for what you found]

Shall I proceed with [next step], or would you like to adjust the approach?
```

If the handoff's `Chronicle Candidates` section has entries and the `chronicle`
knowledge-memory tool exists in this environment by the time you're reading this,
mention them as worth writing up — but don't block on it, and don't invent this step
if chronicle isn't built yet.

## Step 4: Get confirmation, then proceed

Wait for the user to confirm or redirect. Once confirmed, use your normal task
tracking to work through the action items, referencing the handoff's Learnings as you
go so you don't repeat mistakes it already documents.

## When the trail has gone cold

If the codebase has diverged heavily (many commits since the handoff, referenced files
deleted or unrecognizable, or the described approach conflicts with code that now
exists), say so directly instead of forcing the old plan to fit. A stale handoff that's
honestly flagged as stale is still useful — it's degraded to "here's what someone was
trying to do and why," which is worth having even if the specific plan no longer
applies.
