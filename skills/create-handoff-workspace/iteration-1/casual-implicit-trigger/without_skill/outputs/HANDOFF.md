# Handoff: rate limiter (2026-07-13)

## Where things stand
Branch: `feature/rate-limiter`
Building a token-bucket `RateLimiter` in `src/rate_limiter.py`.

- `RateLimiter.__init__(capacity)` — done, just stores capacity.
- `RateLimiter.allow(key)` — **not implemented** (`raise NotImplementedError`). This is the core method that needs to decide whether a request for `key` is allowed.
- `RateLimiter._refill()` — stubbed, just a `pass` with `# TODO: implement token refill based on elapsed time`.
- `src/rate_limiter_test.py` — empty, only a `# TODO: write tests for RateLimiter.allow()` comment. Untracked (never git-added).

## Uncommitted state
- `src/rate_limiter.py` has unstaged changes (the `_refill` skeleton).
- `src/rate_limiter_test.py` is untracked.
- Nothing has been committed since `e1d2867 wip: add token bucket skeleton`.

## Next steps
1. Design token storage — need per-key bucket state (tokens remaining + last-refill timestamp), likely a dict keyed by `key`.
2. Implement `_refill()`: compute elapsed time since last refill, add tokens at some rate, cap at `capacity`.
3. Implement `allow(key)`: call `_refill()`, check if >=1 token available, consume and return True/False.
4. Write tests in `rate_limiter_test.py` (currently empty) — cover: under capacity allows, over capacity blocks, refill over time allows again.
5. Decide refill rate — not yet specified/parameterized anywhere (capacity is the only constructor arg so far).
6. `git add` the new test file once it has content; commit.
