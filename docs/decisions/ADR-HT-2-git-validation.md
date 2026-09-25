# ADR: Git commit and branch validation

- **Status**: Accepted
- **Date**: 2026-09-25
- **Ticket**: [HT-2](../backlog.md)

## Context

The project needs a consistent commit-message and work-branch policy that gives developers fast local feedback without adding a Node.js toolchain to this Java and Maven repository. Local hooks alone are opt-in and bypassable, while existing history includes older commit messages that should not be rewritten.

## Options Considered

1. **Dependency-free POSIX shell hooks plus pull-request CI**
   - Advantages: Fits the existing toolchain, keeps the grammar in one small validator, provides local feedback and central enforcement, and avoids rewriting existing history.
   - Costs: Shell portability requires focused tests, and developers must opt in to the local hook path.
2. **Node.js commitlint and Husky**
   - Advantages: Mature Conventional Commits ecosystem and richer parser support.
   - Costs: Adds a second package ecosystem and dependency surface to a Java-only learning project.
3. **CI-only validation**
   - Advantages: No local installation step.
   - Costs: Feedback arrives late and does not provide the requested pre-commit/pre-push workflow.

## Decision

Use executable POSIX-shell scripts under `.githooks/` and `scripts/`. The shared validator accepts the eleven project-approved Conventional Commits types, requires `HT-<number>` or `HT-X` as the scope, validates work branches as `type/ticket/short_description`, and treats `dev` and `main` as protected integration-branch exceptions. A repository-local installer configures `core.hooksPath=.githooks`. GitHub Actions validates the pull-request source branch and every commit in the base-to-head range for either protected branch.

## Consequences

- Developers can install the same checks locally without project dependencies.
- Pull-request CI catches local-hook bypasses and validates only newly introduced commits.
- Existing commits using the older `HT-N: description` style remain intact and are not retroactively rejected.
- Shell behavior and GitHub Actions range handling are maintained by the repository test harness.
- Hook installation is opt-in and can still be bypassed with Git's `--no-verify` flags; CI is the enforcement boundary.

## Links

- Backlog: [HT-2](../backlog.md)
- Plan: [HT-2 plan](../plans/HT-2-pre-commit-hook.md)
- Code: [Git convention validator](../../scripts/validate-git-conventions.sh)
- Tests: [Git convention tests](../../scripts/test-git-conventions.sh)
- Supersedes or related: None
