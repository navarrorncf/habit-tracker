# Plan: HT-2 - Commit and branch validation hooks

- **Status**: Complete
- **Created**: 2026-09-25
- **Completed**: 2026-09-25
- **Backlog**: [HT-2](../backlog.md)

## Discovery Summary

- **Outcome**: `ready for planning`
- **Confirmed scope**:
  - Validate commit headers as `type(HT-<number>|HT-X): description`.
  - Allow the canonical types `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, and `revert`.
  - Allow optional Conventional Commits body and footer lines after a valid header.
  - Validate work branches as `type/HT-<number>|HT-X/short_description`.
  - Allow lowercase letters, digits, hyphens, and underscores in branch descriptions.
  - Enforce locally with dependency-free POSIX shell hooks and centrally for pull requests in GitHub Actions.
  - Treat `dev` and `main` as the protected integration-branch exceptions.
- **Non-goals**:
  - Rewriting existing history, adding Node tooling, validating tags, or changing the Maven build.
  - Preventing `--no-verify` bypasses outside CI.
  - Adding merge-message or breaking-change exceptions.
- **Acceptance checks**:
  - Valid and invalid commit, branch, pre-push, and commit-range cases are covered by the shell test harness.
  - The installer configures repository-local `core.hooksPath=.githooks`.
  - Pull-request CI validates the source branch and every commit from base to head without revalidating legacy protected-branch history.
  - `./mvnw verify -B` passes.
- **Assumptions**:
  - The explicit eleven-type allowlist is the project interpretation of the accepted Conventional Commits types.
  - The shared validator is the only source of truth for hooks and CI.
  - CI checks the actual pull-request head SHA with complete history.
- **Risks**:
  - Shell portability and GitHub commit-range behavior can cause false rejects; keep expressions centralized and test both local and CI-shaped inputs.
  - Local hooks are opt-in and bypassable; CI provides the repository-level enforcement.
- **Gaps**:
  - This repository had no existing hook or shell-test convention, so `.githooks/` and `scripts/` establish one.
- **Dependencies**:
  - Git, POSIX shell, and the existing GitHub Actions workflow; no new project dependency.
- **Affected surfaces**:
  - Git hooks, shell scripts, CI configuration, contributor instructions, workflow documentation, backlog, plan, and decision record.
- **Unresolved questions**:
  - None blocking implementation.

## Goal and Learning Goal

- **Behavioral goal**: Reject non-conforming commit messages and pushed work branches locally and in pull-request CI.
- **Learning goal**: Practice portable Git hook plumbing, shell validation, Git ref input, and GitHub Actions commit-range checks.

## Implementation Plan

1. Add the shared validator and executable local hook wrappers.
2. Add the opt-in installer and dependency-free shell test harness.
3. Wire pull-request branch and commit-range validation into CI.
4. Document the policy and record the tooling decision.
5. Verify the shell checks, temporary Git integration behavior, and Maven build.

## Affected Files

- `scripts/validate-git-conventions.sh` - Shared commit, branch, pre-push, and commit-range validation.
- `scripts/test-git-conventions.sh` - Dependency-free behavior test harness.
- `.githooks/commit-msg` - Commit message hook wrapper.
- `.githooks/pre-push` - Branch validation hook wrapper.
- `.githooks/install.sh` - Repository-local hook-path installer.
- `.github/workflows/ci.yml` - Pull-request validation and full-history checkout.
- `AGENTS.md` - Contributor workflow policy.
- `docs/ai-assisted-development.md` - Implemented Hook primitive example.
- `docs/decisions/ADR-HT-2-git-validation.md` - Durable tooling decision.
- `docs/backlog.md` - Ticket lifecycle state.

## Documentation Updates

- Document the exact commit and branch grammar, installation command, `dev` and `main` exceptions, CI enforcement, and hook bypass limitations in `AGENTS.md`.
- Update the Hook primitive example to point to the implemented Git policy.

## Linked Decisions

- [ADR-HT-2 Git validation](../decisions/ADR-HT-2-git-validation.md) - Dependency-free hooks with CI enforcement.

## Verification

```text
./scripts/test-git-conventions.sh
./mvnw verify -B
```

Additional checks include shell syntax validation, temporary-repository hook behavior, and pull-request-style commit-range validation.

## Implementation Notes

- Discovery confirmed `HT-2`, local hooks plus CI, POSIX shell, the eleven-type allowlist, flexible lowercase branch slugs, optional commit body/footer lines, and `dev` and `main` as the protected integration exceptions.

## Outcome and Deviations

- **What shipped**: Added the shared validator, executable `commit-msg` and `pre-push` hooks, repository-local installer, shell test harness, pull-request branch and commit-range validation, contributor documentation, and the ADR.
- **Files**: [Validator](../../scripts/validate-git-conventions.sh), [tests](../../scripts/test-git-conventions.sh), [.githooks/](../../.githooks/), [CI workflow](../../.github/workflows/ci.yml), [AGENTS.md](../../AGENTS.md), and [backlog](../backlog.md).
- **Verification**: Shell syntax checks passed; the harness passed 51 cases; temporary repository integration confirmed valid pushes, invalid `dev` push rejection, and invalid commit rejection; workspace diagnostics found no errors; `./mvnw verify -B` passed with exit code 0.
- **Deviations**: Added explicit handling for Git's `HEAD` local ref in pre-push input so `git push origin HEAD` still validates the current branch. Extended the protected integration-branch exception and CI targets from `main` to `dev` and `main`.
- **Follow-up**: None.
