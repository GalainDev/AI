# Handoff: Rate Limiter (token bucket)

Date: 2026-07-13
Branch: `feature/rate-limiter`

## Where things stand

Implementing a token-bucket rate limiter in `src/rate_limiter.py`. Nothing
is working yet — this is early/skeleton stage.

- `RateLimiter.__init__(capacity)` stores capacity, nothing else.
- `RateLimiter.allow(key)` is still `raise NotImplementedError` — not
  implemented.
- `RateLimiter._refill()` was just stubbed out (uncommitted) with a TODO
  to implement token refill based on elapsed time. Currently just `pass`.
- `src/rate_limiter_test.py` is a new, empty file (untracked) containing
  only a TODO comment: "write tests for RateLimiter.allow()". **No tests
  have been written yet.**

## Uncommitted changes (not yet committed)

- `src/rate_limiter.py` — modified, adds the `_refill` stub (see diff
  below).
- `src/rate_limiter_test.py` — new/untracked, empty test file placeholder.

```diff
diff --git a/src/rate_limiter.py b/src/rate_limiter.py
index a1faead..0e47958 100644
--- a/src/rate_limiter.py
+++ b/src/rate_limiter.py
@@ -4,3 +4,7 @@ class RateLimiter:
 
     def allow(self, key):
         raise NotImplementedError
+
+    def _refill(self):
+        # TODO: implement token refill based on elapsed time
+        pass
```

Nothing has been committed since `e1d2867 wip: add token bucket skeleton`.
These changes are sitting in the working tree only — remember to `git add`
/ `git commit` (or stash) before switching branches or machines.

## Next steps, in order

1. Decide on and implement the token bucket state needed for refill:
   likely a `tokens` counter and a `last_refill` timestamp set in
   `__init__`.
2. Implement `_refill()`: compute elapsed time since `last_refill`, add
   `elapsed * refill_rate` tokens (capped at `capacity`), update
   `last_refill`.
3. Implement `allow(key)`: call `_refill()`, then check/consume a token
   for `key` (note — capacity is currently global, not per-key; decide
   whether rate limiting should be per-key or shared before writing
   tests).
4. Write the actual tests in `src/rate_limiter_test.py` (currently just a
   TODO stub) — at minimum:
   - `allow()` returns True while tokens remain, False once exhausted.
   - Tokens refill correctly over (mocked) elapsed time.
   - Behavior at capacity boundary (no over-fill).
   - Per-key isolation, if that's the intended design (see point 3).
5. Run the test suite and confirm green before considering this done.

## Open questions to resolve before continuing

- Is `capacity`/refill per-key or shared across all keys? The `allow(key)`
  signature suggests per-key, but no per-key storage exists yet.
- What refill rate / time unit should `_refill` use? Not yet decided or
  passed into `__init__`.
- No test framework/runner config found in the repo (no `pytest.ini`,
  `pyproject.toml`, etc.) — confirm which test runner to use for
  `rate_limiter_test.py`.

## How to resume

```
cd <repo>
git status        # confirm the same uncommitted diff described above
git diff          # re-check src/rate_limiter.py changes
cat src/rate_limiter_test.py   # confirm still just the TODO stub
```

Then pick up at "Next steps" above, starting with implementing `_refill`.
