# Context

Working notes organised **by feature slice**, not by date. One file per slice, each describing the current state of that area and the decisions behind it.

`AGENTS.md` is the source of truth for **how the package works**. This folder is for **what state a feature is in** — what exists, what was decided and why, what's still open.

## The rule

**When something is added to a feature, update that feature's slice in the same change.** Don't append a new dated entry, and don't create a second file for the follow-up work — edit the slice so it describes the world as it is now. A slice that lags the code is worse than no slice.

That means:

- New capability shipped → move it from *Open* to *What exists now* in its slice.
- Decision taken or reversed → update *Decisions*, keeping the reasoning.
- Plan approved and implemented → replace the plan with what actually shipped and a PR link.
- No slice fits → create one, named for the feature, and add it to the index below.

## Conventions

- Name files for the capability, generically: `typography-customization.md`. A slice outlives the ticket that prompted it.
- Reference **versions, PRs, and issues** rather than dates — `v1.6.0`, `#39` age better than "last Tuesday".
- Record what was **verified** vs **inferred**. A later reader can't tell them apart otherwise.
- Nothing secret. This folder is tracked in git, unlike `.claude/settings.local.json` and `.claude/commands/`.

## Slices

| Slice | Covers |
| --- | --- |
| [branching-ci-and-releases.md](branching-ci-and-releases.md) | Branch model (`develop` integrates, `main` publishes), protection rules, CI triggers, release and publish flow |
| [typography-customization.md](typography-customization.md) | Caller-supplied text styles across the card's text slots — planned, not implemented |
| [agent-tooling.md](agent-tooling.md) | Skills, the `/implement` command, this folder, what's gitignored under `.claude/` |
