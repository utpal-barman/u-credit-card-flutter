---
name: git-ops
description: Performs git operations (commit, branch, push, tag, amend, rebase, stash) following this repo's conventions. Use whenever the user asks to "commit", "stage", "make a commit", "push", "rebase", "amend", "tag", or any git mechanics — even when phrased loosely ("save this", "ship it locally", "wrap this up in a commit"). Also use proactively before any commit you create on the user's behalf as part of another workflow.
---

# git-ops

The single source of truth for how this repo commits, branches, pushes, and tags. Other skills that touch git (e.g. `release-package`) defer to this one for message format and trailer policy.

## Why this skill exists

This repo's `git log` is clean and human-authored. The conventions are simple, but two of them (Conventional Commits format + no AI co-author trailers) are routinely violated by tools and assistants that ship "helpful" defaults. The skill exists to make those defaults wrong by default and the repo's conventions right by default.

## Hard rules (non-negotiable)

### 1. Conventional Commits, always

Every commit message uses this shape:

```
<type>(<optional-scope>): <subject>

<optional body, wrapped at ~72 chars, explaining the WHY>

<optional footer(s), e.g. BREAKING CHANGE: ..., Refs: #123>
```

**Allowed types** (use the most specific one that fits):

| Type | When to use |
|---|---|
| `feat` | A new user-facing feature, public API addition, or new widget/parameter |
| `fix` | A bug fix that changes runtime behavior |
| `chore` | Maintenance with no user-facing effect: dep bumps, version files, internal config |
| `docs` | README, CHANGELOG, code comments, package metadata strings |
| `refactor` | Code restructuring with no behavior change |
| `test` | Adding or improving tests; no production code change |
| `perf` | A change that measurably improves performance |
| `style` | Formatting, whitespace, lint fixes that don't touch logic |
| `build` | Build system, gradle, pubspec build config |
| `ci` | GitHub Actions, workflows |
| `release` | Version bump commits (`release: Bump to vX.Y.Z`) |

**Scope** is optional but encouraged when it clarifies the area. Examples from this repo: `feat(controller):`, `chore(deps):`, `refactor(test):`, `chore(example):`, `docs(readme):`. Skip scope only when the change is genuinely cross-cutting.

**Subject rules:**

- Imperative mood (`add X`, not `added X` or `adds X`).
- Lowercase first word after the prefix unless it's a proper noun (`feat: add CreditCardController` is fine).
- No trailing period.
- Aim for ≤ 72 chars; hard cap at 100.
- Describe the change, not the file you changed. "fix: replace deprecated Matrix4.scale with scaleByDouble" beats "fix: update card_controller.dart".

**Body rules** (optional but encouraged for non-trivial commits):

- Blank line between subject and body.
- Explain **why**, not **what** — the diff already shows what changed.
- Reference issues/PRs in a footer: `Refs: #32`, `Closes: #28`.

**Breaking changes:**

Either add `!` after the type/scope (`feat!: drop scale parameter`) or include a `BREAKING CHANGE: <description>` footer. Both is fine and explicit.

### 2. NEVER add AI co-author trailers

Forbidden — do **not** append any of these to commit messages, tag annotations, or PR bodies:

```
Co-Authored-By: Claude ...
Co-Authored-By: Cursor ...
Co-Authored-By: Copilot ...
🤖 Generated with [Claude Code](...)
Generated-by: <any AI tool>
```

If a default template (including Claude Code's built-in `git commit` template) includes one of these, strip it before committing. The user has stated this is a hard rule for this repo; a single offending commit visible on `git log` is enough to lose trust.

This applies to: `git commit`, `git commit --amend`, `git tag -a`, `gh pr create --body`, `gh release create --notes`. Everywhere.

### 3. Never use destructive operations without explicit user authorization

- No `git push --force` or `--force-with-lease` to shared branches (`develop`, `main`) unless the user explicitly says "force push develop" (or equivalent) in this session. Note: `develop` is also branch-protected on the remote, so force-push will be rejected by GitHub even if attempted.
- No `git reset --hard`, `git checkout -- .`, `git clean -fd`, `git branch -D` over unmerged work.
- No `--no-verify` to skip hooks.
- No `git config` changes.
- No `commit --amend` on commits that have been pushed to a shared branch.

If you hit a wall, surface the obstacle and ask. Never use a destructive shortcut to "make it go away".

## How to commit (the normal path)

1. **Inspect first.** `git status` and `git diff --staged` (or `git diff` if nothing staged yet) so you know what you're committing. Skip if you just made the edits yourself in this same turn.
2. **Stage explicit paths.** Prefer `git add <path1> <path2>` over `git add .` or `git add -A`. The latter can sweep in `.env`, scratch files, or unrelated work.
3. **Write the message** following the rules above. Use a heredoc to preserve formatting if the body is multi-line:

   ```bash
   git commit -m "$(cat <<'EOF'
   feat(controller): add CreditCardController for programmatic flipping

   Exposes flip(), flipToFront(), and flipToBack() so callers can drive
   the flip animation without a tap. Internally wraps the existing
   AnimationController so behavior matches user-initiated flips.

   Closes: #32
   EOF
   )"
   ```

4. **Verify.** `git log -1 --format=%B` to check the message looks right (no stray trailer, no truncation).

## Examples

Look at this repo's `git log` for the house style. Recent commits worth modeling on:

```
86fab79 fix: replace deprecated Matrix4.scale with scaleByDouble
f44892d refactor(test): use cascade operators in CreditCardController tests
0247c4e chore(example): bump Android Gradle Plugin to 8.6.0 and Kotlin to 2.1.0
07d2f6c docs: add blank lines for readability in README
c2f4aec test: Add comprehensive tests for CreditCardController
f856217 feat: Add CreditCardController for programmatic card flipping
```

Note the consistent scoping (`chore(example):` not `chore:`), the imperative subjects, and the absence of any AI trailer. Match this.

**Transformation examples:**

| Bad | Good |
|---|---|
| `Update README` | `docs: clarify install instructions for Flutter 3.x` |
| `Fix bug` | `fix(card): prevent overflow when number lacks spaces` |
| `WIP` | (don't commit WIP; squash or amend before pushing) |
| `feat: Added new controller (closes #32)` | `feat(controller): add CreditCardController\n\nCloses: #32` (move ref to footer, imperative mood) |
| `chore: stuff` | (rewrite — message is meaningless) |
| `feat: add flip\n\nCo-Authored-By: Claude ...` | `feat: add flip` (strip trailer) |

## Branches and pushes

- **Branch naming:** `feat/<short-slug>`, `fix/<short-slug>`, `chore/<short-slug>`, `release/v<X.Y.Z>`, `docs/<short-slug>`. Slug is lowercase, hyphenated, derived from the change ("programmatic-card-flipping", not "programmaticCardFlipping").
- **Pushing a new branch:** `git push -u origin <branch>` so upstream is set.
- **Pushing to `develop` directly** is allowed only for `.claude/` tooling commits (see [[skill-files-direct-to-develop]]). Everything else goes through a PR.
- **Force-push:** only on branches you own (`feat/*`, `fix/*`, `release/*` before merge) and only with `--force-with-lease`, never plain `--force`. Never force-push `develop` or `main` without explicit user authorization in the current session — and even then expect GitHub to reject it on protected branches.

## Tags

- Format: `v<MAJOR>.<MINOR>.<PATCH>` (leading `v`). Examples: `v1.6.0`, `v1.6.1`.
- Always annotated: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`.
- Tag the **merge commit on `develop` after the release PR merges**, not the release branch tip. See [[release-package-skill]].
- Push tags individually: `git push origin vX.Y.Z`, not `git push --tags` (which can sweep up old/local tags).

## Amend, rebase, reword

- **Amend** is fine for the commit you just made *if it hasn't been pushed*. After `git commit --amend`, double-check no co-author trailer was re-introduced (the template can sneak back).
- **Interactive rebase** is fine on private branches before pushing. Don't use the `-i` flag inside this skill's tooling — it requires a TTY. Instead, build the sequence via `git rebase --onto` or by squashing in the UI.
- **Reword on a pushed branch** requires force-push-with-lease and is allowed on your own branches. Not on `develop`/`main` (protected).

## What to do when the user says "commit this"

1. Run `git status` to see what's actually changed.
2. Decide on the type/scope by looking at the changed paths and the diff.
3. Write a Conventional Commits message — no trailer.
4. Stage only the paths that belong to the change (ask if mixed concerns appear in the working tree).
5. Commit. Confirm with the user and ask whether to push.

If the diff spans multiple logical changes (e.g. a `feat` plus an unrelated `chore`), propose splitting it into separate commits before staging. Don't bury work under a single vague subject.

## Failure modes to avoid

- Pushing a co-author trailer to `develop` (the headline reason this skill exists).
- Squashing a meaningful body into the subject line.
- Using `chore:` as a catch-all when `fix` / `refactor` / `docs` would be more honest.
- Letting a pre-commit hook failure cause an `--amend` on the wrong commit. If a hook fails, fix the issue, re-stage, and make a NEW commit.
- Running `git add .` when the working tree has untracked files you haven't looked at.
