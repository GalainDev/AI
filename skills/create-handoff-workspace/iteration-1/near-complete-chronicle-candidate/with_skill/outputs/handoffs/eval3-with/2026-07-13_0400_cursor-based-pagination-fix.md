---
date: 2026-07-13T04:00:09+0800
git_commit: faa15c0
branch: fix/pagination-drift
repo: eval3-with
topic: "Fix pagination drift by switching list_items to cursor-based pagination"
tags: [pagination, database, bugfix, pattern]
status: in_progress
---

# Handoff: Cursor-based pagination fix for drift bug

## Task(s)
- Fix pagination drift bug in `list_items` — **done, pending final review**. Switched
  the query from OFFSET-based pagination to cursor-based (keyset) pagination so that
  results no longer drift when rows are inserted mid-list.

## Recent Changes
- `src/pagination.py:1-6` — `list_items` signature changed from `(offset, limit)` to
  `(cursor, limit)`. Query changed from `SELECT * FROM items OFFSET {offset} LIMIT
  {limit}` (raw f-string interpolation) to a parameterized query:
  `SELECT * FROM items WHERE id > :cursor ORDER BY id LIMIT :limit`.
  See commit `faa15c0` (`fix: switch to cursor-based pagination`) for the full diff
  against the prior commit `d619fca`.

## Learnings
- Root cause: OFFSET-based pagination recomputes page position by row count on each
  request. If rows are inserted before the current offset between page fetches, the
  offset no longer lines up with the same logical position, so rows are skipped or
  repeated — this is the "pagination drift" bug.
- Fix: cursor/keyset pagination anchors each page to the last-seen `id` instead of a
  row count, so inserts elsewhere in the table don't shift the window. This is a
  standard, well-known fix for the class of bug, not something specific to this
  codebase.
- The `list_items` fix as merged only touches this one call site. No other paginated
  endpoints were changed in this session.

## Chronicle Candidates
- OFFSET-based pagination drifts when rows are inserted mid-list; cursor/keyset
  pagination (anchor on last-seen id, not row count) is the fix. This is a pattern,
  not a one-off — worth checking any other paginated endpoint in a codebase for the
  same OFFSET-based drift bug, not just fixing it once here.

## Artifacts
- `src/pagination.py` — the fixed `list_items` function.

## Action Items & Next Steps
1. Final review of `src/pagination.py` (the change is otherwise considered complete).
2. Audit the rest of the codebase for other paginated endpoints using OFFSET-based
   queries — they likely have the same drift bug and are candidates for the same
   cursor-based fix. No such audit has been done yet in this session.

## Other Notes
None.
