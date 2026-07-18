# AI Harness — Build Roadmap

Portable, GitHub-backed AI tooling: one repo installed by symlink onto any machine,
working identically across Claude Code / Codex / Gemini / Cursor. Easy wins first,
custom systems last. Every external import gets a security audit before install
(same treatment beads got).

## Phase 0 — Repo skeleton + installer  *(the thing everything hangs off)*

- [ ] Repo layout:
  ```
  instructions/   # single-source agent instructions (see Phase 1)
  skills/         # curated skills, one dir each
  hooks/          # slim safety tripwires (rebuilt, not v1's regex farm)
  mcp/            # MCP server configs (chrome-devtools, codanna, …)
  settings/       # settings.json fragments (permissions.deny, plugins)
  memory/         # OKF knowledge bundle (Phase 3) — travels with the repo
  install.sh      # symlinks everything into ~/.claude, ~/.codex, ~/.gemini, ~/.agents
  ```
- [ ] `install.sh`: idempotent, `--dry-run`, per-provider targets, backs up non-symlink
  collisions. Deletes the neutralized v1 hook stubs in `~/.claude/hooks`.
- [ ] Push to GitHub (private — memory/ will hold project knowledge).

## Phase 1 — Instructions symlinks  *(easy win #1)*

- [ ] Write ONE lean source file: `instructions/agents.md` — working style, env/secrets
  convention, tooling table. No slop: if a rule never changed an outcome, it's out.
- [ ] Symlink targets: `~/CLAUDE.md`, `~/AGENTS.md`, `~/.codex/AGENTS.md`,
  `~/.gemini/GEMINI.md`. Provider-specific deltas (if ever needed) live in tiny
  `instructions/claude.md` etc. that include the shared core.

## Phase 2 — Skills + browser tooling  *(easy wins #2–4)*

- [ ] Rewrite the keepers small and sharp (no over-triggering descriptions, no overlap):
  `git-commit`, `verify`, `secrets` (.env.schema + varlock runtime injection — audit
  varlock first; Secure Enclave local encryption, `keychain()` plugin for Keychain storage),
  `frontend-design`, `go-backend`, `debug`.
- [ ] Audit + import external skill packs: HumanLayer skills, Google's modern-web
  guidance skill, Vercel `agent-browser` skill (CLI already installed).
  *(research exact repos at implementation time — audit each before install)*
- [ ] MCP wiring in `mcp/`: Chrome DevTools MCP (debugging: console/network/traces);
  claude-in-chrome extension already active.
- [ ] Execution safety settings fragment (`settings/`) — replaces v1's regex hooks entirely:
  - `permissions.defaultMode: "auto"` in user settings — classifier-reviewed autonomy.
    Blocks curl|bash, exfil, force-push, reset --hard, rm -rf with unresolved vars,
    reverse shells/tunnels, credential printing — everything v1's hooks attempted, trained
    not regexed. Replaces `--dangerously-skip-permissions` for day-to-day work.
  - `sandbox.enabled: true` + auto-allow — OS-enforced (Seatbelt) fs/network walls on every
    Bash command. Writes confined to cwd + tmp; no network domain reachable without approval
    or `allowedDomains` allowlist.
  - `sandbox.credentials`: deny-read `~/.ssh`, `~/.aws`, etc. for Bash subprocesses — closes
    the "Bash side door" the old Read-hook never covered. Keeps existing `permissions.deny`
    Read rules as the tool-side twin.
  - Known frictions to config: `excludedCommands` for gh/gcloud/docker (sandbox-incompatible),
    pre-seed `allowedDomains` (github.com, npm, package registries).
  - NO regex hooks. Deny rules + ask rules apply in every mode incl. bypass; classifier +
    sandbox do the rest.
- [ ] Shared skills dir `~/.agents/skills/` symlinked per provider where supported.
- [ ] Devcontainer recipe: `.devcontainer/` template based on Anthropic's reference
  container (default-deny egress firewall — only npm/GitHub/Anthropic reachable).
  The ONLY sanctioned home for `bypassPermissions` runs; drop into any project.

## Phase 3 — OKF knowledge memory  *(custom system #1)*

Decision 2026-07-19: confirmed build order is git-commit skill → **Chronicle next,
ahead of Pebbles** (repo renamed from working title "OKF" — see naming decision
above). No dependency blocks this: Chronicle stands alone (the task→knowledge flow
only matters once both exist), and it's the lower-risk build (markdown/frontmatter,
no DB engine) vs. Pebbles' real engineering lift (Go + embedded Dolt). Also gives us
somewhere to durably record decisions made during this project itself.

**Spec convention adopted from OpenSpec** (github.com/Fission-AI/OpenSpec, researched
not installed — a documentation pattern, not code, so no audit needed): specs use
delta sections (`ADDED Requirements` / `MODIFIED Requirements`) instead of being
rewritten in place, plus explicit proposed/active/archived lifecycle states. Applies
to pebbles/spec.md and future spec docs going forward — NOT a tool adoption, we keep
doing spec-driven development exactly as we have been, just borrowing this one idea.

**Pebbles/OpenSpec-convention/Chronicle boundary** (2026-07-19 — flagged as real
crossover risk, resolved same way as the Pebbles/Chronicle split above): without a
rule, ROADMAP.md, per-repo spec docs, and Pebbles issues could all drift into
claiming to be "the plan" for the same work. The rule:
- **Spec docs** (delta-tracked, per-repo, e.g. `pebbles/spec.md`) = WHAT to build —
  requirements/behavior for a feature, evolved via ADDED/MODIFIED sections.
- **Pebbles issues** = the WORK to build against a spec. Reference it by name: never
  restate its content.
- **Chronicle notes** = durable decisions/rationale that outlive a single spec — e.g.
  *why* Dolt over SQLite. When a spec's change is fully applied (OpenSpec "archived")
  and contains lasting rationale, that rationale graduates into a Chronicle decision
  note — same one-directional graduation as Pebbles → Chronicle.
- **ROADMAP.md** = top-level cross-repo narrative and phase sequencing ONLY. No
  feature-level requirement detail — that belongs in each repo's own spec doc.

- [ ] `memory/` as an Open Knowledge Format bundle: markdown + YAML frontmatter
  (`type` required), relationships as wiki-style cross-links, `index.md` per dir
  for progressive disclosure. No runtime, no DB — the graph IS the link structure.
- [ ] Concept types: `project`, `decision`, `preference`, `runbook`, `reference`.
- [ ] An `okf` skill teaching agents to read (start at index.md, follow links) and
  write (one concept per file, link liberally, update index).
- [ ] Sync = git push/pull. Portable by construction.
- [ ] **Obsidian-compatible by design**: `memory/` doubles as an Obsidian vault (vault = any
  folder). Rules that make both worlds work: YAML frontmatter (= Obsidian Properties,
  `tags` become Obsidian tags), relative markdown links (OKF-compliant, GitHub-renderable,
  and Obsidian's graph view resolves them), one concept per file. `.obsidian/` gitignored
  (device-local UI state). Humans browse/edit in Obsidian with graph view; agents use the
  okf skill against the same files — neither knows the other exists.

## Phase 4 — Pebbles v2  *(custom system #2 — per-project task memory)*

- [ ] Spec approved at `~/developer/pebbles/spec.md` (embedded Dolt, minimal core:
  issues/deps/ready/focus/handoff, plain vocabulary, zero telemetry, -race tests).
- [ ] Build in vertical slices: init/create/list → deps+ready → focus/handoff/start
  → history/export → README + agent onboarding snippet.
- [ ] `pebbles` skill in this repo teaching agents the `pb start --json` loop.

## Phase 5 — Semantic code search  *(wire before build)*

- [ ] Wire codanna (already installed via homebrew): per-project index, MCP server
  config in `mcp/`, small skill for query patterns. Evaluate on real repos.
- [ ] Judge it: symbol accuracy, semantic recall, speed, language coverage.

## Phase 6 — Custom indexer  *(only if codanna hits a ceiling)*

- [ ] If built: Go/Rust, everything embedded in one SQLite file — FTS5 (BM25),
  sqlite-vec (local embedding model, e.g. EmbeddingGemma-class via ONNX),
  tree-sitter symbol graph in relation tables, hybrid rank fusion (RRF).
- [ ] No Neo4j: a server dependency on every machine breaks portability, and code
  graphs don't need Cypher. Revisit only with evidence.

## Phase 7 — Orchestration layer  *(post-Pebbles; inspired by Kun's workflow, built on native features)*

- [ ] **Overnight loop** (our GNHF): thin wrapper over native `/loop`/background tasks —
  objective OR `pb ready` queue as the work source, worktree per task, token/iteration
  caps, explicit stop conditions, commits-per-iteration log. Pebbles integration is the
  differentiator: wake up to a worked-through ready queue.
Decision 2026-07-12: BUILD all three ourselves, using Kun's audited designs as reference
(same call as beads→Pebbles). Audits of kunchenguid/{no-mistakes,lavish-axi,gnhf} all
passed and now serve as design docs. Build order: loop → pipeline → visual planning.

- [ ] **Overnight loop (ours)** — smallest build, do first.
  Steal from gnhf: dedicated branch + worktree so `reset --hard` rollbacks never touch
  the checkout; fresh context per iteration seeded with base context + carried learnings;
  token/iteration caps + explicit stop conditions; commit per iteration.
  Ours adds: `pb ready --json` as the work source (wake up to a worked-through queue).
- [ ] **Ship pipeline (ours)** — start as a skill chaining native pieces (EnterWorktree,
  /code-review, Monitor for CI); graduate to a CLI only if the skill hits limits.
  Steal from no-mistakes: intent extraction from the session; adversarial review in a
  FRESH context; recorded evidence (screenshot/log/video) proving the change works;
  risk assessment that gates how much human review a PR gets; babysit PR until merge.
  Anti-patterns to avoid (found in audit): agents in bypass mode by default → ours runs
  auto mode + sandbox; default-on telemetry → ours has none, per standing rules.
- [ ] **Visual planning (ours)** — biggest build, last.
  Steal from lavish: design-system-aware HTML artifacts; annotate/comment on elements;
  decisions round-trip to the agent via long-polling; loopback-only server, HMAC-signed
  session tokens, origin/referer checks, sandboxed iframe (his security model is worth
  copying wholesale). Lean start: Artifact tool + design.json before building the server.
- [ ] Treehouse + firstmate: DEFERRED by choice (2026-07-12) — firstmate is Kun's
  gastown-equivalent orchestrator; revisit once lavish/no-mistakes/gnhf are bedded in.
  Native worktrees + Agent tool cover the gap meanwhile.
- [ ] Validated overlaps from his stack we already have: CLAUDE.md↔AGENTS.md symlinks
  (Phase 1), skill audit rule, gh CLI over GitHub MCP, worktree isolation. Voice input:
  Claude Code has native voice mode; OpenSuperWhisper optional for other harnesses.

## Environment track — dotfiles  *(nix-darwin, built 2026-07-12 — user wants to learn Nix)*

- [x] Standalone repo: `~/developer/dotfiles` → github.com/GalainDev/dotfiles (public,
  old April history preserved; AeroSpace config folded in). A Nix flake (own
  authorship, Kun's structure as reference):
  flake.nix → configuration.nix (macOS defaults, declared Homebrew inventory,
  cleanup="none" NOT his "zap") + home.nix (symlinks via mkOutOfStoreSymlink).
  bootstrap.sh installs Determinate Nix once; rebuild.sh applies changes.
- [x] WezTerm + Kun's minimal nvim (8 plugins, no LSP) + user's own tmux.conf
  (keybindings preserved; TPM/resurrect/continuum fixed and actually running).
- [x] **Phase 1 delivered via home.nix**: one `home/AGENTS.md` (v0 written) fanned out
  to ~/.claude/CLAUDE.md, ~/.codex/AGENTS.md, ~/.gemini/GEMINI.md. Claude settings
  (auto mode + deny rules) also repo-managed via symlink.
- [ ] First-run: user executes `./bootstrap.sh` (sudo, interactive). Later exercises:
  flip cleanup→"uninstall", add _HIHideMenuBar, adopt programs.zsh + starship.
- [ ] OpenSuperWhisper (optional) — local Whisper voice input; Claude Code also has
  native voice mode. Seed its initial-prompt with project vocabulary.

## Naming + scoping decision — 2026-07-13

Repo map finalized (7 standalone repos, each on GitHub):
`dotfiles` (done) · `AI` (harness: skills/hooks/mcp/settings, Claude+Codex only —
Gemini dropped) · `pebbles` (task state, spec'd) · **`chronicle`** (knowledge memory,
was "OKF system" — replaces earlier working name) · **`afterhours`** (overnight loop,
our gnhf) · **`flawless`** (ship pipeline, our no-mistakes) · **`atelier`** (visual
planner, our lavish). Each new-build repo takes design inspiration from its Kun
equivalent (already audited, see Phase 7) but is our own implementation.

**Pebbles vs Chronicle scope** — the boundary that prevents these from collapsing
into each other:
- **Pebbles = state.** "What's true about work right now" — issue open/blocked/done,
  dependencies, focus. Everything expected to change; natural endpoint is closing.
  Time horizon: days–weeks. `pb handoff` is strictly session-to-session continuity —
  disposable, overwritten, never meant to be searched later.
- **Chronicle = knowledge.** "What we know, and why" — decisions + rationale,
  runbooks, durable facts. Written once, rarely revised, must be findable months
  later by a different session. Time horizon: indefinite. This is the OKF markdown
  bundle (YAML frontmatter + wiki-links), Obsidian-vault-compatible.
- **Flow is one-directional**: task → knowledge, never the reverse. If closing a
  Pebbles issue teaches something durable, it graduates OUT into a Chronicle note
  (optionally back-linking the issue). Pebbles issues hold only enough context to
  work the task now — they must not become the archive.

**Pebbles architecture clarification**: `.pebbles/` is ONE database per repository,
not per branch or worktree — resolved via the git common dir so every worktree of a
repo (afterhours spins one per issue) shares the same ready queue and locks. Task
graph is branch-agnostic by default (an issue doesn't care which git branch is
checked out). Dolt's native branching stays available as an opt-in later feature for
per-feature-branch task graphs, not the default. Add this as an explicit note in
pebbles/spec.md before building.

## Skills reset — 2026-07-13

Ripped out everything: rust-analyzer-lsp plugin uninstalled, all skills removed across
every provider (Claude/Codex/Gemini/Cursor + shared ~/.agents/skills — was only
`find-skills`). Installed anthropics/skills' official **skill-creator** into
~/.agents/skills/skill-creator, symlinked into ~/.claude/skills. This is now THE tool
for Phase 2: its with-skill-vs-baseline subagent runs + assertions + benchmark viewer
ARE the implementation of the "skills earn their context through evals" standing rule
below — use it to build every skill from here, not just adopt it as one skill among many.
Rebuild `git-commit`/`verify`/`secrets`/`frontend-design`/`go-backend`/`debug` etc.
through its draft → test → review → improve loop, one at a time.

## Standing rules

- Audit before install for anything third-party (provenance → egress → exec → install path).
- **Skills earn their context through evals.** Every skill we write or import gets
  benchmarked on a small fixed task set: with-skill vs without, measuring success rate,
  tokens, and turns. A skill that doesn't measurably improve outcomes is context tax —
  cut it. Popularity ≠ efficacy (the 177k-star skill that made agents worse). Same bar
  for our own tools once built (loop/pipeline/planning): each ships with its eval.
- No default-on telemetry in anything we build. No regex security theatre — native
  `permissions.deny` + sandbox first, hooks only as tested tripwires.
- Old harness archive: `github.com/GalainDev/claude-harness` (v1.0.0/v1.1.0).
