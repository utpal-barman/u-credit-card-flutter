---
name: release-package
description: Cuts a release of this Flutter package — bumps pubspec.yaml version, rewrites CHANGELOG.md from PR commits since the last tag, refreshes the README version pin, opens a release PR to main, and prepares the matching git tag. Use whenever the user asks to "release", "cut a release", "ship a version", "bump the version", "publish", "tag a release", or names a target version like "release v1.6.0" — even when they don't say the word "release" explicitly (e.g. "make a 1.6 PR", "we're ready to ship 1.6").
---

# release-package

A repeatable release workflow for the `u_credit_card` Flutter package. The skill produces a single release PR against `main` plus a tag plan; it does **not** push tags or merge anything itself.

## Why this skill exists

Releases for this package touch four files in a fixed pattern (`pubspec.yaml`, `CHANGELOG.md`, `README.md`, then a git tag). Doing it by hand causes drift: a forgotten README pin, a CHANGELOG that's a copy-paste of `git log`, a tag that points at the wrong commit. The skill exists so every release looks the same and reviewers (Utpal) only have to check content, not mechanics.

## When to trigger

Trigger on any of these intents, even when phrased loosely:

- "release / cut a release / ship / publish / tag a release"
- "bump the version to X" or "release v1.6.0"
- "make a release PR" / "1.6 PR"
- "what's the next version?" followed by an instruction to prepare it

Do **not** trigger when the user just asks to view the changelog, list tags, or look at past releases. Read-only inspection is not a release.

## Hard rules (read before acting)

1. **Always release from the latest `develop`, and target `main`.** Never from a feature branch, never from `main` itself. Run `git fetch origin develop` first. The release branch (`release/vX.Y.Z`) must be cut from `origin/develop`, and the PR's base must be **`main`** — this is the single documented exception to the repo's "all PRs target `develop`" rule, and it exists because `publish.yml` fires on push to `main` plus a `v*` tag. Non-negotiable for this repo. See [[git-ops-skill]].
2. **CHANGELOG range is `lastTag..origin/develop`** — not `..HEAD`. The local branch is irrelevant to what's actually shipping.
3. **Never push the tag yourself.** Create it locally on the release commit *after* the PR merges, and leave the push as an explicit step the user runs. A premature tag pinned to a not-yet-merged commit is a mess to undo.
4. **Reviewer is `@utpal-barman`.** Always request review from this GitHub user on the release PR. (They are the repo owner and have asked to sign off on every release.)
5. **Version scheme is `vMAJOR.FEATURE.MINORFIX`** (semver-shaped, with the user's vocabulary). Use the picker rules below — don't guess.

## Version picker

Look at the commits in `lastTag..origin/develop` and decide:

| Highest commit type present | Bump |
|---|---|
| Breaking change (`!` after type, or `BREAKING CHANGE:` footer, or removed/renamed public API) | MAJOR (`2.0.0` from `1.5.0`) |
| Any `feat:` / `feat(...)` | FEATURE (`1.6.0` from `1.5.0`) |
| Only `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `perf:`, `style:`, deps bumps | MINORFIX (`1.5.1` from `1.5.0`) |

If the user named a specific version (e.g. "release v1.6.0"), use that — but if it disagrees with what the commits suggest, surface the mismatch in one sentence before proceeding. Don't silently override.

## The workflow

Execute these steps in order. After each step, briefly say what you did before moving on so the user can interrupt if something looks off.

### 1. Verify state and pick the version

```bash
git fetch origin develop --tags
git describe --tags --abbrev=0           # last tag, e.g. v1.5.0
git log <lastTag>..origin/develop --pretty=format:"%h %s"
```

Confirm with the user the version you intend to cut if (a) they didn't specify one, or (b) their request conflicts with the picker rule.

### 2. Cut the release branch from develop

```bash
git checkout -B release/vX.Y.Z origin/develop
```

Use `-B` (not `-b`) so re-running the skill recovers cleanly if the branch already exists locally.

### 3. Bump `pubspec.yaml`

Edit only the `version:` line. Don't reformat the file. Match the existing version style (no build metadata unless the previous line had one — `1.0.0+5` style is legacy; modern entries here are `X.Y.Z`).

### 4. Rewrite the CHANGELOG entry

Prepend a new section under `# Changelog` (above the previous top entry). Use this exact shape — it matches the file's existing style:

```markdown
## [X.Y.Z] <emoji>

### <Category>

- <Human-readable bullet>
- <Human-readable bullet>
```

**Categories to use** (only include the ones that have content):

- `Features` — new public API, new parameters, new widgets
- `Fixes` — bug fixes, regressions, deprecation warning fixes
- `Improvements` — refactors, perf, test coverage that users would care about
- `Chores` — dependency bumps, tooling, CI (collapse to one bullet if many)
- `Docs` — README/CHANGELOG/example updates worth calling out
- `Deprecated` — soft removals announced this release
- `Breaking` — anything requiring caller changes

**Emoji for the heading** — pick by dominant category, mirroring past entries:
- Features → 🚀 — Fixes → 🐞 — Deprecated → 🛑 — Chores/Tooling → 🔧 — Docs → 📝 — Breaking → 💥

**Human-readable rules** (this is the part that matters most — the CHANGELOG is for humans, not a `git log` dump):

- Drop the conventional-commit prefix. `feat: Add CreditCardController for programmatic card flipping` → `Added CreditCardController for programmatic card flipping`.
- Drop noise: `(#34)`, author names, hashes, "WIP", "small fix", "address review comments".
- Collapse multiple related commits into one bullet (e.g. five `test:` commits → one bullet under Improvements).
- Lead with the **user-facing effect**, not the implementation. "Replaced deprecated `Matrix4.scale` with `scaleByDouble`" → "Fixed deprecation warnings on Flutter 3.x by migrating to `Matrix4.scaleByDouble`".
- Prefer past tense, sentence case, no trailing period unless the bullet is multi-clause.
- Skip dependabot bumps of dev-only deps unless they changed surface (e.g. `very_good_analysis` major bump that forced lint fixes — mention the lint fixes, not the bump).
- Skip purely internal commits (CLAUDE.md, AGENTS.md, .clauderc) unless the user opts in.

**Example transformation** (from this repo, for v1.6.0):

Raw commits on develop since v1.5.0:
```
885f222 chore(deps): Bump very_good_analysis from 9.0.0 to 10.2.0 (#36)
8c8cd14 docs: add AGENTS.md and CLAUDE.md for agent context (#35)
409c730 feat(#32): Add CreditCardController for programmatic card flipping (#34)
```

Human-readable entry:
```markdown
## [1.6.0] 🚀

### Features

- Added `CreditCardController` for programmatic card flipping — call `controller.flip()`, `flipToFront()`, or `flipToBack()` from anywhere in your widget tree

### Chores

- Bumped `very_good_analysis` to `^10.2.0`
```

(The agent-context docs commit is internal-only and gets dropped.)

### 5. Update README

Replace every version pin (e.g. `u_credit_card: ^1.5.0`) with the new version. There are typically two occurrences — the badge-like header line and the install snippet. Don't touch unrelated content.

If the release introduces a new public API (e.g. a new controller), also check whether the README's usage section needs a one-line example added. If it does, propose the addition to the user before writing it; don't invent code.

### 6. Commit, push, open the PR

```bash
git add pubspec.yaml CHANGELOG.md README.md
git commit -m "chore(release): bump to vX.Y.Z"
git push -u origin release/vX.Y.Z
```

Use `chore(release): bump to vX.Y.Z` for both the commit and the PR title. The repo's older history uses bare `release: ...` but the PR title lint (`amannn/action-semantic-pull-request`) rejects that — `chore(release):` keeps commit and PR title aligned and passes the check. See [[pr-title-lint]] and [[git-ops-skill]].

Open the PR against `main` and request review from `utpal-barman`:

```bash
gh pr create \
  --base main \
  --head release/vX.Y.Z \
  --title "chore(release): bump to vX.Y.Z" \
  --reviewer utpal-barman \
  --assignee utpal-barman \
  --body "$(cat <<'EOF'
## Release vX.Y.Z

<one-paragraph summary of what's in this release, derived from the CHANGELOG entry>

### Highlights
<2-4 bullets, the most important changes in plain English>

### Changelog
See `CHANGELOG.md` for the full entry.

### Release checklist
- [ ] CHANGELOG entry reads naturally to someone who hasn't seen the commits
- [ ] README version pin updated
- [ ] pubspec.yaml version matches PR title
- [ ] After merge: tag `vX.Y.Z` on the merge commit and push

cc @utpal-barman
EOF
)"
```

Return the PR URL to the user.

### 7. Prepare the tag and the back-merge (do not run either)

After the PR is open, tell the user the exact commands to run *after* the PR merges:

```bash
# 1. Tag main's merge commit — this is what publishes to pub.dev
git checkout main
git pull origin main
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z

# 2. Back-merge so develop doesn't drift behind main
git checkout develop
git pull origin develop
git merge --ff-only origin/main   # falls back to a merge commit if develop moved
git push origin develop
```

Do not run these yourself. Tagging an unmerged commit, or pushing a tag the user hasn't agreed to, is the kind of mistake that's tedious to clean up on a published package.

**The back-merge is not optional.** The release PR lands the version bump, CHANGELOG, and README pins on `main` only. Skip step 2 and `develop` — the branch every other PR targets — is permanently behind on those three files, so the next release computes its CHANGELOG range from a stale base.

## Edge cases

- **No commits since the last tag.** Refuse and surface this — there's nothing to release. Don't create an empty release PR.
- **Local branch dirty.** Stash or refuse. Never `git checkout -B` over uncommitted work.
- **Tag already exists** (local or remote). Stop and ask. The version was probably already cut.
- **`develop` is behind a feature branch the user thinks is "the release".** Tell them: the work must be merged to `develop` first; releases come from `develop`. Offer to wait or to help open the feature PR first.
- **Hotfix off an older tag** (patching a shipped version without taking everything on `develop`). Not supported by this skill yet — fall back to manual and tell the user.

## Reviewer vs. assignee

The release PR's reviewer should be `@utpal-barman` — but if the PR author *is* `utpal-barman` (the usual case), GitHub silently drops the self-review-request. In that case fall back to `--assignee utpal-barman` so the PR still surfaces on their dashboard. The `gh pr create` invocation above passes both flags; the reviewer flag becomes a no-op when self, and the assignee flag does the real work.

## What success looks like

A single commit on `release/vX.Y.Z` that touches exactly `pubspec.yaml`, `CHANGELOG.md`, and `README.md`; a PR titled `chore(release): bump to vX.Y.Z` against `main` with `@utpal-barman` as reviewer (or assignee if self); and a clear next-step instruction for the user to tag after merge. Nothing else changes.
