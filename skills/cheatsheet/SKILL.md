---
name: cheatsheet
description: Generate an up-to-date reference of every keybinding and CLI tool shortcut in the dotfiles setup — AeroSpace, WezTerm, herdr, tmux, Neovim, and CLI tools like zoxide/fzf/bat/fd/lazygit/yazi/gh/jq. Use this whenever the user runs /cheatsheet, asks "what are my bindings again", "how do I use zoxide/fd/lazygit", wants a refresher on a shortcut they've forgotten, or wants a printed/sidebar reference of the whole setup. User-invocable as /cheatsheet.
user-invocable: true
---

# Cheatsheet

Generates a single, accurate reference document by reading the *actual current*
config files — never from memory, never from what a previous run of this skill
produced. Bindings drift as the dotfiles repo evolves; a stale cheatsheet is worse
than no cheatsheet because it's silently wrong.

## Where the source of truth lives

All paths below are under `~/developer/dotfiles/home/`:

| Layer | Read this file | What to extract |
|---|---|---|
| AeroSpace | `.config/aerospace/aerospace.toml` | Everything under `[mode.main.binding]` |
| WezTerm | `.config/wezterm/wezterm.lua` | The `config.keys` table |
| herdr | `.config/herdr/config.toml` | Everything under `[keys]`, including `prefix` |
| tmux | `.tmux.conf` | Every `bind`/`bind-key` line |
| Neovim | `.config/nvim/lua/keys.lua` and every `.config/nvim/lua/plugins/*.lua` | `vim.keymap.set` calls and each plugin spec's `keys = {...}` table |

Read every one of these fresh with the Read tool before writing anything. Do not
reuse bindings from earlier in the conversation, from the dotfiles README, or from
your own training data about what these tools' defaults are — this repo's configs
override defaults, and the whole point of this skill is that it can't drift out of
sync with them.

## CLI tools without a bindings file

`zoxide`, `fzf`, `bat`, `fd`, `lazygit`, `yazi`, `gh`, `jq` aren't configured via
keybinding files — they're used through their own commands. For these, write a
short "most-used commands" cheat block per tool from your own knowledge of the
tool, but keep it tight (5-8 lines each, the commands someone actually reaches for
daily, not a full man-page). If `~/developer/dotfiles/home.nix` configures a
tool's shell integration (e.g. `programs.fzf` binds `Ctrl+R`/`Ctrl+T`), read that
file too and include the integration, not just the bare CLI.

## Output

Produce two things:

1. **Print the full reference in your response**, grouped by layer with a heading
   per tool, tables for keybindings. Someone should be able to read your chat
   response alone and have everything.
2. **Write the same content to `~/developer/dotfiles/CHEATSHEET.md`**, so it
   persists as a file the user can open in an editor split or terminal pane as a
   standing reference — that's the actual point of this skill existing as a command
   rather than a one-off answer. Overwrite the file each run; it's generated, not
   hand-maintained.

After writing, tell the user how to open it as a sidebar in whatever pane/split
scheme they're using — e.g. a herdr/tmux side pane running `bat CHEATSHEET.md`, or
a Neovim vertical split (`:vsplit ~/developer/dotfiles/CHEATSHEET.md`). Keep this
one line, don't over-explain.

## Formatting

- One `##` heading per layer (AeroSpace, WezTerm, herdr, tmux, Neovim, CLI Tools).
- Tables with `Keys | Action` columns for anything binding-based.
- Keep the file skimmable — this is a reference to glance at mid-work, not prose to
  read start to finish. No long explanations of *why* a binding exists; that
  belongs in the dotfiles README, not here.
