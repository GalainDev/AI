# Handoff: Pagination Drift Fix (OFFSET → Cursor-Based)

**Date:** 2026-07-13
**Branch:** `fix/pagination-drift`
**Status:** Code complete, needs final review before merge

## Summary

Fixed a pagination drift bug in `list_items` (`src/pagination.py`) by switching
from OFFSET-based pagination to cursor-based pagination.

**Root cause:** `OFFSET`-based pagination recalculates each page's window by
row position (`OFFSET {offset} LIMIT {limit}`). If rows are inserted or
deleted between page requests, every row after the change shifts position,
so callers either skip rows or see duplicates across pages ("drift").

**Fix:** Replaced the offset with a cursor — the last-seen row's `id` — and
changed the query to select rows strictly after that cursor, ordered by
`id`. Page boundaries are now anchored to a stable row identity instead of a
row count, so inserts/deletes elsewhere in the table no longer shift
already-served pages.

## What changed

`src/pagination.py`, commit `faa15c0` (`fix: switch to cursor-based
pagination`):

```diff
-def list_items(offset, limit):
-    # old, buggy: page offset drifts when items are inserted mid-list
-    return db.query(f"SELECT * FROM items OFFSET {offset} LIMIT {limit}")
+def list_items(cursor, limit):
+    # fixed: cursor-based pagination avoids drift when rows are inserted
+    return db.query(
+        "SELECT * FROM items WHERE id > :cursor ORDER BY id LIMIT :limit",
+        cursor=cursor, limit=limit,
+    )
```

Note the signature change: `list_items(offset, limit)` →
`list_items(cursor, limit)`. Any caller of `list_items` needs to be updated
to pass the last-seen `id` instead of a row offset — check callers before
merging (none found in this repo, but this is a small fixture-sized
codebase; the real service likely has API/route handlers that call this).

Also worth double-checking: the old query used an f-string
(`OFFSET {offset} LIMIT {limit}`), the new one uses parameterized binds
(`:cursor`, `:limit`) — a nice side-effect fix for SQL-injection risk on
this path, but confirm `db.query` actually supports named-param binding the
way this code assumes (wasn't verified in this session).

## State / what's left

- Fix is implemented and committed. Considered **basically done**.
- **Needs final review** — nobody has reviewed this yet. In particular:
  - Confirm no remaining callers pass a numeric `offset` into `list_items`.
  - Confirm `db.query`'s bind-parameter syntax (`:cursor`, `:limit`) matches
    whatever DB layer this project actually uses.
  - No tests were added/run in this session — worth adding a test that
    inserts a row mid-pagination and asserts no drift/duplicate/skip.

## Pattern worth remembering (not just a one-off fix)

This was an instance of a general anti-pattern: **OFFSET-based pagination
drifts under concurrent writes.** Any endpoint that paginates with
`OFFSET`/`LIMIT` over a table that receives inserts or deletes between page
requests is susceptible to the same bug — skipped or duplicated rows for
users paging through results while data changes underneath them.

**Action item for whoever picks this up next:** grep the broader codebase
(this fix only touched `src/pagination.py`, one function in a small
service) for other `OFFSET`-based pagination call sites — other endpoints,
other services, admin/reporting queries, etc. — and evaluate whether they
need the same cursor-based treatment. This fix should be treated as the
first instance of a pattern, not a closed one-off.

## Suggested next steps

1. Get the diff reviewed (final review is the only thing blocking merge).
2. Search other services/endpoints for `OFFSET` pagination and file
   follow-up tickets/fixes per the pattern note above.
3. Add a regression test for insert-during-pagination.
4. Verify `db.query` bind-param support before merging.
