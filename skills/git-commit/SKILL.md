---
name: git-commit
description: Create git commits for the changes made in this session — reviews git status/diff, groups changes into logical commits, writes Conventional Commits messages, and executes them. Use this whenever the user says "commit this", "commit these changes", "let's commit", "create a commit", "check this in", or otherwise asks to save work to git history, even if they don't specify a message or which files. Also use it proactively at natural stopping points if the user says something like "commit as you go" earlier in the session.
---

# Git Commit

You're creating commit(s) for changes made in this session. The user invoking this
skill (directly or via a phrase like "commit this") is the explicit request to
commit — once you've drafted the plan below, execute it without pausing for further
confirmation. Don't ask "should I commit now?" after already deciding what to commit;
that question was answered when the skill was invoked.

## Process

1. **See what actually changed.**
   - `git status` for the full picture (staged, unstaged, untracked).
   - `git diff` and `git diff --staged` to read the actual content, not just filenames.
   - Use the conversation history to understand *why* the changes were made — that
     context rarely survives in the diff alone, and it's what makes a commit message
     useful six months from now.

2. **Group into logical commits.**
   Most sessions touch more than one concern. Split when the changes are separable
   *and each half is substantial enough to stand on its own* — e.g. a skill's code
   vs. an unrelated ROADMAP.md update, or a bug fix vs. a docs tweak that happened to
   land in the same session. Don't split just to split: if everything serves one
   change (a feature and its tests, a refactor and the callers it touched), keep it
   as one commit. When in doubt, prefer fewer commits — a slightly-too-broad commit
   is easier to live with than a trail of fragments that don't build independently.

   Trivial, incidental edits — a stray whitespace/newline fix, a typo caught in
   passing, reformatting a line you were already touching — don't earn their own
   commit even when they land in an otherwise-unrelated file. A standalone commit
   should represent a real, nameable change; if the diff is one line of formatting
   noise, fold it into whichever nearby commit is the closest fit (or the largest
   one, if none is obviously closest) rather than giving noise equal billing with
   substance.

3. **Write the message(s).**
   Format: Conventional Commits.
   ```
   <type>(<scope>): <imperative subject, ≤72 chars>

   <body — why, not what, wrap ~72 cols, omit if the subject says it all>
   ```
   - `type` — `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `build`, `ci`. Pick
     the one that matches the *primary* effect of the change; if a commit is hard to
     type, that's often a sign it should be split.
   - `scope` — the module/package/skill/dir most affected (e.g. `git-commit`,
     `install`, `roadmap`). Omit if the change is repo-wide or scope would be noise.
   - Subject: imperative mood ("add", "fix", "rename" — not "added"/"adds"), no
     trailing period.
   - Body: explain *why* the change was made, not a restatement of the diff — the
     diff already shows what changed. Skip the body entirely for genuinely
     self-explanatory commits; an empty body beats a padded one.
   - Never mention AI, Claude, or an agent as author/co-author, and never add a tool
     attribution trailer (e.g. no `Co-Authored-By`, no `Generated with...` line).

4. **Stage precisely and commit.**
   - `git add <specific files>` — always name files explicitly. Never `git add -A`
     or `git add .`: it's how unrelated scratch files, generated output, or
     in-progress work the user hasn't reviewed end up in a commit silently.
   - Never stage: `.env` (only `.env.schema` is meant to be committed — see the
     env-files convention in global instructions), files that look like throwaway
     debug/test scripts you created while working the problem, or anything that
     looks like another in-progress change you didn't make.
   - `git commit -m "<message>"` for each planned commit, in order.

5. **Confirm what landed.**
   Run `git log --oneline -n <k>` (k = number of commits you made) and `git status`
   once done, and report the commit(s) briefly. Don't push — pushing is a separate,
   explicitly-requested action.

## Example

Session touched `skills/git-commit/SKILL.md` (new skill) and `ROADMAP.md` (an
unrelated status update made in passing). These are two commits:

```
feat(git-commit): add commit skill with conventional-commit format

Rebuilt from HumanLayer's ci_commit.md as a reference, adapted to require
explicit file staging and drop the no-pause default in favor of the
harness's normal commit conventions.
```

```
docs(roadmap): mark git-commit skill as shipped
```

## Edge cases

- **Nothing staged and nothing changed**: say so, don't invent a commit.
- **Pre-commit hook fails**: fix the underlying issue and re-commit; never
  `--no-verify` unless the user explicitly says to skip hooks.
- **Ambiguous grouping** (e.g. a refactor that touches many unrelated-looking
  files but is genuinely one change): prefer one commit and explain the grouping
  briefly in the body, rather than fragmenting a change that doesn't actually
  decompose.
- **User already staged specific files themselves**: respect that staging as a
  signal of intent — commit what's staged rather than re-deriving groupings from
  scratch, unless it's clearly incomplete relative to the session's changes.
