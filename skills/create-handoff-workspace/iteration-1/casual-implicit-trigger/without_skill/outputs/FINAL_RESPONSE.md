Wrote `HANDOFF.md` in the repo root. Summary:

- Branch `feature/rate-limiter`, building a token-bucket `RateLimiter`.
- `allow(key)` is still `NotImplementedError` — the core piece left to build.
- `_refill()` is stubbed (`pass` + TODO) — uncommitted change.
- `rate_limiter_test.py` is untracked and empty, just a TODO comment.
- Nothing committed since `e1d2867 wip: add token bucket skeleton`.

Next steps I jotted down: design per-key bucket state (tokens + last-refill timestamp), implement `_refill()` (elapsed-time-based refill capped at capacity), implement `allow()` (refill then consume a token if available), write tests for under/over capacity and refill-over-time, decide on a refill rate (not parameterized yet — only `capacity` is), then commit.

Enjoy lunch — it's all in HANDOFF.md when you're back.
