# Agent tooling

The `.claude/` directory: what's there, what's shared, and what stays local.

## What exists now

**Skills** (`.claude/skills/`, tracked)

- `git-ops` — the single source of truth for commits, branches, pushes, and tags. Conventional Commits always; **never** an AI co-author trailer or "Generated with…" footer; always branch off the latest `origin/main`. Other skills defer to it for message format and trailer policy.
- `release-package` — the full release flow (cut from `origin/main`, bump, changelog, README pins, PR, tag plan). Never pushes tags or merges.

**Commands** (`.claude/commands/`, **gitignored**)

- `/implement <issue>` — takes a reported issue from triage → plan → expert review → implementation → PR. It **always runs in a worktree** (`EnterWorktree` before touching any file), investigates and reproduces before planning, posts the plan as an issue comment, then runs a six-expert agent panel (`flutter-expert`, `dart-expert`, `pub-expert`, `api-expert`, `oss-expert`, `mit-license-expert`) whose consensus is the gate on implementing. Each expert is read-only and must close with a parseable `VERDICT` / `BLOCKING` / `NON_BLOCKING` block.

**Context** (`.claude/context/`, tracked) — this folder. Feature slices, updated in place whenever something is added to the feature.

**Root files** — `CLAUDE.md` (points at `AGENTS.md`), `AGENTS.md` (the real project context: public API, layout invariants, controller lifecycle, commands, conventions), `.clauderc`.

## Decisions

- **`AGENTS.md` is the source of truth for how the package works**, so guidance stays consistent across every coding agent rather than being Claude-specific. `CLAUDE.md` deliberately just points at it.
- **Skills are tracked; local config and commands are not.** `.claude/settings.local.json` is per-machine and `.claude/commands/` is scratch tooling, so both are gitignored. The consequence: `/implement` works locally but is not shared or reviewed — tracking `.claude/commands/` (or promoting the command to a skill) is the open call.
- **The `/implement` panel is the gate, with three mandatory user checkpoints** that stop the run even on a unanimous approve: a breaking public API change, any licensing concern, or new `pubspec.yaml` dependencies. Those are the cases where an autonomous wrong call is expensive to walk back on a published package.
- **Two revision rounds, then stop and ask.** The command never implements over an unresolved `BLOCKING` verdict.
- **`/implement` always runs in a worktree.** It writes a reproduction test in Phase 1, before the panel has approved anything, and may abandon the approach entirely if the panel rejects it. In the main checkout that would leave the user's tree dirty with work that may never ship, and block them from using the repo while the panel runs. `EnterWorktree` also branches from `origin/main` by default, which is the base the command requires anyway.
- **`/implement` never touches `pubspec.yaml` `version:` or `CHANGELOG.md`** — see the release flow slice.

## How the agent team actually works

There is no `CreateTeam` tool in this harness. A team is formed by issuing **multiple `Agent` calls in a single message** (they run concurrently), each given a `name`. `SendMessage` to that name then resumes the agent **with its review context intact** — which is what lets the revision round send a changed plan back to only the dissenting experts, so they judge the delta instead of re-reading everything.

## Open

1. **`/implement` is gitignored.** Start tracking `.claude/commands/` and PR it, or move it to `.claude/skills/implement/SKILL.md` (already tracked), or leave it local-only by design.
2. **The command is untested end-to-end.** The one open issue was planned but paused before the panel ran, so the review-and-implement phases have never executed.
