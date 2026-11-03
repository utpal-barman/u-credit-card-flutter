# Branching, CI, and releases

How work flows from a branch to a published pub.dev version.

## What exists now

Two long-lived branches with different jobs:

- **`develop` — the integration branch.** Every PR targets it, and every branch is cut from it. `.claude/` tooling commits may be pushed to it directly; everything else goes through a PR.
- **`main` — the default and publish branch.** It receives *only* release PRs, and `publish.yml` fires on push to `main` plus a `v*` tag. Never push to it directly.

`main` is the repository default (so it's what visitors and `git clone` land on), but it is not where day-to-day work integrates.

**Branch names:** `feat/…`, `fix/…`, `chore/…`, `docs/…`, `release/vX.Y.Z`.

**Protection** — `develop` and `main` carry identical classic rules: 1 required approving review, code-owner review, conversation resolution required, no force-push, no deletion, no required status-check contexts, admins not enforced, signatures not required. Force-push is rejected on both even with `--force-with-lease`, so nothing that lands can be rewritten — only reverted. Admins can bypass the review requirement with `gh pr merge --admin`.

**CI**

- `.github/workflows/main.yml` (PR validation) — triggers on push to `develop` or `main`, and on any PR. Jobs: semantic PR title, markdown spell-check over `**/*.md`, `dart format --line-length 80 --set-exit-if-changed lib test`, `flutter analyze lib test`.
- `.github/workflows/publish.yml` — publishes to pub.dev via OIDC on push to `main` and on a `v*` tag.

Spell-check covers **all** tracked markdown with `useGitignore: true`, so `.claude/context/` and `.claude/skills/` are CI gates; `.claude/commands/` is gitignored and therefore skipped. The word list lives in `.github/cspell.json`.

**Releases** (`release-package` skill)

1. Cut `release/vX.Y.Z` from `origin/develop`; CHANGELOG range is `lastTag..origin/develop`.
2. Bump `pubspec.yaml`, rewrite the `CHANGELOG.md` entry by hand, refresh the two README version pins.
3. PR to **`main`** — the single documented exception to "all PRs target `develop`", because publishing is triggered from `main`.
4. After merge, tag `main`'s merge commit and push the tag; that publishes.
5. **Back-merge `main` → `develop`** so `develop` doesn't sit behind on the version/CHANGELOG/README files.

Tags are never pushed by an agent. Latest release: `v1.6.0`.

## Decisions

- **`develop` integrates, `main` publishes.** All PRs target `develop`; only release PRs reach `main`. The default branch stays `main` so what visitors see is what ships.
- **Step 5 is mandatory.** The release PR lands the bump, CHANGELOG, and README pins on `main` only. Skipping the back-merge leaves `develop` — the base for every other PR — permanently behind on those three files, and the next release then computes its CHANGELOG range from a stale base.
- **Version bumps and CHANGELOG belong to the release flow only.** Feature and fix PRs never touch `pubspec.yaml` `version:` or `CHANGELOG.md`, so release content stays reviewable in one diff.
- **Tag the merge commit, not the release branch tip.** Tagging an unmerged commit on a published package is tedious to undo.

## The trap worth remembering

The `main` protection rule was created with **`lockBranch: true`** (branch read-only) and **`requiresCommitSignatures: true`**, while local commits are unsigned. That combination rejects every merge into `main`. Both are now off, but they matter again the moment `main` starts refusing a release PR.

```bash
gh api graphql -f query='{repository(owner:"utpal-barman",name:"u-credit-card-flutter"){
  branchProtectionRules(first:10){nodes{pattern lockBranch requiresCommitSignatures}}}}'
```

`required_signatures` is **not** a field on the REST protection `PUT` payload — it has its own `PUT`/`DELETE` sub-endpoint at `branches/<b>/protection/required_signatures`.

## History worth knowing

`main` was created from `develop` and briefly became the integration branch too (`#39`, `#40`), before the model settled on the split above. `develop` was fast-forwarded to `main` to remove the resulting gap, so the two are level as of `489351d` — no divergence to reconcile.

## Open

1. **No required status checks** on either branch — the protection rules have an empty contexts list, so PR validation is advisory and merging is gated only on review. Making `pr_validation` / `spell-check` / `semantic_pull_request` required is a small change if wanted.
2. **Nothing enforces the back-merge.** Step 5 is a documented instruction, not automation. A missed back-merge is silent until the next release looks wrong.
3. **Default-branch switches don't retarget open PRs.** Relevant if the branch model is ever revisited again.
