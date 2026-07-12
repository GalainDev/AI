# AI harness

Skills, hooks, MCP configs, and settings fragments for Claude Code and Codex.
One repo, `./install.sh`, both providers stay in sync.

## Layout

| Dir | Owns |
|---|---|
| `skills/` | One directory per skill (SKILL.md + optional scripts/references/assets) |
| `hooks/` | Claude Code hook scripts (Codex has no hook system yet) |
| `mcp/` | MCP server configs |
| `settings/` | settings.json fragments (permission modes, deny rules, sandbox config) |
| `memory/` | *(unused — durable knowledge memory lives in the sibling `chronicle` repo)* |

## Install

```sh
./install.sh            # symlink everything into ~/.claude and ~/.codex
./install.sh --dry-run  # preview only
```

Gemini is deliberately not targeted — dropped from scope.

## Skills

Built through [`skill-creator`](skills/skill-creator) — every skill here is drafted,
tested against real prompts (with-skill vs baseline), and iterated on based on
quantitative assertions + human review before being considered done. See
`skills/skill-creator/SKILL.md` for the loop.

| Skill | Status |
|---|---|
| `skill-creator` | Vendored from [anthropics/skills](https://github.com/anthropics/skills) (Apache 2.0), unmodified |

## Sibling repos

This harness is one piece of a larger suite, each repo standalone:

- [`dotfiles`](https://github.com/GalainDev/dotfiles) — the machine (terminal, editor, WM)
- [`pebbles`](https://github.com/GalainDev/pebbles) — task state (issues, dependencies, ready queue)
- [`chronicle`](https://github.com/GalainDev/chronicle) — durable knowledge memory (OKF format)
- [`afterhours`](https://github.com/GalainDev/afterhours) — overnight agent loop
- [`flawless`](https://github.com/GalainDev/flawless) — ship pipeline (review, evidence, PR)
- [`atelier`](https://github.com/GalainDev/atelier) — visual planning surface
