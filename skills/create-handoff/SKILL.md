---
name: create-handoff
description: Write a thorough-but-concise session handoff document capturing current work state so a future session (or a teammate) can resume without you present. Use this whenever the user wants to pause work, hand off to another session, is about to run low on context, explicitly asks to "create a handoff", "write up where we are", "save my progress", or "capture what we've done in case I lose this session" — and proactively suggest it near the end of a long, complex session that hasn't reached a clean stopping point, even if the user hasn't asked.
---

# Create Handoff

A handoff document exists so a session with zero memory of this conversation can pick
up the work correctly. Write for that reader, not for yourself — they don't know what
you tried and abandoned, why a file looks the way it does, or what "the bug" refers to.

## Where it lives

`.claude/handoffs/<repo-name>/YYYY-MM-DD_HHMM_<kebab-case-description>.md`

`<repo-name>` is the current repo's directory name (`basename "$(git rev-parse --show-toplevel)"`).
Date and time are local, 24-hour. These documents are personal continuity notes, not
project history — they stay out of git. Before writing the first handoff in a repo,
check whether `.gitignore` already excludes `.claude/handoffs/`; if not, add a line:

```
.claude/handoffs/
```

Don't gitignore all of `.claude/` — a project may have other things checked in there
(skills, settings) that should stay tracked. Only the handoffs subdirectory is local
scratch.

## Gather the facts before writing

Run these, don't guess:

```bash
git rev-parse --short HEAD          # commit
git branch --show-current           # branch
basename "$(git rev-parse --show-toplevel)"  # repo name
date +%Y-%m-%dT%H:%M:%S%z           # timestamp with timezone
```

## Document structure

```markdown
---
date: 2026-07-13T15:30:00-07:00
git_commit: a3f21c9
branch: feature/handoff-skill
repo: AI
topic: "Short, specific title of what this handoff covers"
tags: [relevant, component, names]
status: in_progress
---

# Handoff: {concise description}

## Task(s)
What you were working on, and the status of each thread (done / in progress / planned
but not started). If following a plan or spec document, name it and say which phase
you're on.

## Recent Changes
What changed in this session, as `path/to/file.ext:line` references — not code dumps.
A reader can open the file themselves; they need to know *where* to look and *why* it
changed, not read a diff a second time.

## Learnings
Anything a cold-start reader needs to know that isn't obvious from the code: a root
cause you found, a pattern you're following, a dead end you already ruled out and why.
Use file:line references where useful.

## Chronicle Candidates
Scan the Learnings above: is anything here durable enough to matter months from now,
independent of this specific task — a decision and its rationale, an architectural
fact, a gotcha worth never rediscovering the hard way? If yes, list it here in one line
each. This is a marker for later, not an action — the "chronicle" knowledge-memory
system doesn't exist yet, so nothing needs to happen with this section now. Leave it
empty (with a one-line "nothing durable this session" note) if nothing qualifies;
don't force an entry just to fill the section.

## Artifacts
Every file this session produced or updated that the next session needs to read to
pick up the work — plans, specs, key implementation files. Exhaustive, not a highlight
reel.

## Action Items & Next Steps
Concrete next steps, ordered. If you know the very next command or file to open, say so.

## Other Notes
Anything useful that doesn't fit above.
```

## Writing it

1. Review the conversation and `git status`/`git diff` to ground the document in what
   actually happened, not just what you remember.
2. Fill in every section. If a section genuinely has nothing to report, say so briefly
   rather than deleting the heading — a reader shouldn't wonder if you forgot it.
3. Keep it concise but complete: more information beats less, but a wall of pasted code
   is not information. Prefer `file:line` references over inline snippets; only paste
   a short excerpt when it's the direct subject of unresolved debugging.
4. Write the file, then tell the user:

```
Handoff created: .claude/handoffs/<repo>/<filename>.md

Resume it in a new session with:
/resume-handoff .claude/handoffs/<repo>/<filename>.md
```
