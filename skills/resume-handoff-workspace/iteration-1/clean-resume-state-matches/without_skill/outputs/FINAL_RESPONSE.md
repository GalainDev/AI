Resumed from `.claude/handoffs/resume-matches-repo/2026-07-10_1400_token-bucket-plan.md`.

**State check:** repo is on branch `feature/token-bucket` at commit `8514ee6`, working tree clean — matches the handoff exactly, no drift since it was written.

**Where things stand:**
- `docs/plan.md` has the 3-step plan: (1) refill logic, (2) wire into request middleware, (3) tests.
- `src/rate_limiter.py` is still a stub — `RateLimiter.allow()` just raises `NotImplementedError`. Nothing implemented yet.
- No middleware file or test files exist in the repo yet.
- Learning noted in the handoff: token bucket was chosen over sliding window for simpler refill math.

**Proposed plan (not yet executed):**
1. Implement `RateLimiter.allow()` in `src/rate_limiter.py` with token-bucket refill logic (track last-refill timestamp, replenish tokens based on elapsed time up to `capacity`, consume a token if available).
2. Wire the rate limiter into the request middleware (no middleware file exists yet, so this will involve creating one and integrating it into the request path).
3. Add tests covering refill timing, exhaustion/rejection behavior, and the middleware integration.

I've confirmed the plan and current state but have not made any code changes. Let me know if you'd like me to proceed with step 1 (or any other step).
