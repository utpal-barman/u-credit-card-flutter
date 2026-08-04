# Branching, CI, and releases

How work flows from a branch to a published pub.dev version.

## What exists now

**`main` is the default and integration branch.** It was created from `develop` at `e32ef2a` (identical content) and took over in `#39`. `develop` still exists and is still protected, but is no longer used for integration.

- **All new work branches off the latest `origin/main`** — never off `develop`, another feature branch, or whatever happens to be checked out.
- Branch names: `feat/…`, `fix/…`, `chore/…`, `docs/…`, `release/vX.Y.Z`.
- PRs target `main`. Merging is gated on one approving review from the code owner and conversation resolution.
- `.claude/` tooling commits may go straight to `main`; everything else goes through a PR.

**Protection** — `main` and `develop` carry identical classic rules: 1 required approving review, code-owner review, conversation resolution required, no force-push, no deletion, no required status-check contexts, admins not enforced, signatures not required. Force-push is rejected on both even with `--force-with-lease`, so nothing that lands can be rewritten — only reverted.

**CI**

- `.github/workflows/main.yml` (PR validation) — triggers on push to `main` and on any PR. Jobs: semantic PR title, markdown spell-check, `dart format --line-length 80 --set-exit-if-changed lib test`, `flutter analyze lib test`.
- `.github/workflows/publish.yml` — publishes to pub.dev via OIDC on push to `main` and on a `v*` tag.

**Releases** are driven by the `release-package` skill: cut `release/vX.Y.Z` from `origin/main`, bump `pubspec.yaml`, rewrite the `CHANGELOG.md` entry by hand, refresh the two README version pins, PR to `main`, then tag `main`'s merge commit after it lands. Tags are never pushed by an agent. Latest release: `v1.6.0`.

## Decisions

- **`main` over `develop`.** A single integration branch that is also the publish trigger removes the develop→main promotion step and the drift it invited.
- **Version bumps and CHANGELOG belong to the release flow only.** Feature and fix PRs never touch `pubspec.yaml` `version:` or `CHANGELOG.md`, so release content stays reviewable in one diff.
- **Tag the merge commit, not the release branch tip.** Tagging an unmerged commit on a published package is tedious to undo.

## The trap worth remembering

The pre-existing `main` protection rule arrived with **`lockBranch: true`** (branch read-only) and **`requiresCommitSignatures: true`**, while local commits are unsigned. That combination would have rejected every merge into `main`. Both were turned off during the migration.

If merges into `main` ever start failing, check those two first:

```bash
gh api graphql -f query='{repository(owner:"utpal-barman",name:"u-credit-card-flutter"){
  branchProtectionRules(first:10){nodes{pattern lockBranch requiresCommitSignatures}}}}'
```

`required_signatures` is **not** a field on the REST protection `PUT` payload — it has its own `PUT`/`DELETE` sub-endpoint at `branches/<b>/protection/required_signatures`.

## Open

1. **`develop` still exists**, still protected, no longer integrated into, and now gets **no CI on push** (the workflow only triggers on `main`). Deleting it is the maintainer's call.
2. **No required status checks** on either branch — the protection rules have an empty contexts list, so PR validation is advisory and merging is gated only on review. Making `pr_validation` / `spell-check` / `semantic_pull_request` required is a small change if wanted.
3. **Default-branch switches don't retarget open PRs.** None were open during the migration, so nothing was stranded, but a pre-switch PR would still be merging into a dead branch.
