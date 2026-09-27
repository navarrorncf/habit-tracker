# Plan: HT-4 - Shared code-review skill

- **Status**: Complete
- **Created**: 2026-09-27
- **Completed**: 2026-09-27
- **Backlog**: [HT-4](../backlog.md)

## Discovery Summary

- **Outcome**: `ready for planning`
- **Confirmed scope**:
  - Create `.github/skills/code-review/SKILL.md` as the shared review procedure
    for GitHub pull-request review and the local Quarkus Reviewer.
  - Use the generic `code-review` skill name required by GitHub, with a
    Quarkus/Maven-aware project profile.
  - Move reusable review methodology, taxonomy, evidence criteria, and output
    contract out of the local reviewer agent.
  - Keep the local agent's identity, invocation metadata, read-only tools, and
    role boundary.
  - Remove duplicated review guidance from the local review prompt.
- **Non-goals**:
  - No GitHub Actions, CI workflow, permissions, secrets, or external service
    integration.
  - No application, database, dependency, Maven, or test-code changes.
  - No claim that local checks prove GitHub's hosted reviewer behavior.
- **Acceptance checks**:
  - The skill exists at the exact GitHub-discoverable path with valid frontmatter,
    a read-only procedure, Quarkus/Maven checks, and a findings-first output
    contract.
  - `Quarkus Reviewer` keeps its name, invocation hint, user-invocability, and
    `[read, search, execute]` tool boundary while following the skill.
  - The review prompt still invokes the same agent without maintaining a second
    checklist.
  - `git diff --check` and `./mvnw verify -B` are run successfully or their
    limitations are reported.
  - A maintainer manually confirms skill discovery and behavior on a later test
    pull request.
- **Assumptions**:
  - GitHub's automatic review feature already runs for this repository and has
    requested the `.github/skills/code-review/SKILL.md` path.
  - The hosted reviewer and local agent can adapt the procedure to their own
    tools and reporting mechanisms.
- **Risks**:
  - Duplicated guidance could drift between GitHub and local review. The skill
    becomes the single procedure and invokers link to it.
  - A generic skill name could imply framework neutrality. The skill labels its
    current Quarkus/Maven checks as an applicable project profile.
  - Hosted GitHub behavior cannot be proven by repository tests. A manual test
    pull request is the acceptance check.
- **Gaps**:
  - No local fixture verifies GitHub's hosted custom-skill discovery.
- **Dependencies**:
  - GitHub's existing automatic review feature and a later non-sensitive test
    pull request.
- **Affected surfaces**:
  - `.github` customization metadata and review guidance.
  - Backlog, plan, and architecture decision documentation.
- **Unresolved questions**:
  - None blocking implementation. GitHub-hosted discovery remains a manual
    post-implementation validation.

## Goal and Learning Goal

- **Behavioral goal**: GitHub automatic review and the local Quarkus Reviewer
  use one repository-owned code-review procedure.
- **Learning goal**: Understand the boundary between reusable skills and
  role-specific agents, including how review procedures can be shared without
  sharing tool permissions.

## Implementation Plan

1. Add the shared code-review skill with generic discovery metadata, a
   read-only review procedure, Quarkus/Maven checks, and a findings-first report
   contract.
2. Update the local reviewer agent and review prompt to delegate to the skill
   while preserving the local agent's read-only tool boundary.
3. Register HT-4 in the backlog and record the skill/agent boundary in an ADR.
4. Validate the focused diff, run the Maven verification gate, and manually
   confirm local prompt invocation and later GitHub skill discovery.

## Affected Files

- `.github/skills/code-review/SKILL.md` - shared review procedure.
- `.github/agents/quarkus-reviewer.agent.md` - local reviewer role and skill
  delegation.
- `.github/prompts/review-quarkus-change.prompt.md` - local prompt delegation.
- `docs/backlog.md` - HT-4 lifecycle entry.
- `docs/plans/HT-4-code-review-skill.md` - this plan.
- `docs/decisions/ADR-HT-4-code-review-skill-boundary.md` - durable boundary
  decision.

## Documentation Updates

- Add the shared skill, ticket plan, and boundary ADR.
- Keep GitHub Actions configuration out of this ticket.

## Linked Decisions

- [ADR-HT-4](../decisions/ADR-HT-4-code-review-skill-boundary.md) - Defines
  which review guidance belongs in the shared skill versus the local agent.

## Verification

```text
git diff --check
./mvnw verify -B
```

Also manually invoke the local review prompt and confirm the skill is applied
by GitHub automatic review on a later test pull request.

## Implementation Notes

- The current agent contained both local role metadata and the reusable review
  checklist. The checklist is now the skill's source of truth.
- No CI, application, dependency, or external integration changes are needed
  for skill discovery.
- The local agent retains `[read, search, execute]` and now explicitly follows
  the shared skill. The review prompt also links to the same skill instead of
  carrying a second checklist.
- GitHub automatic pull-request review successfully discovered and applied the
  skill, confirmed by the maintainer after the change was pushed.

## Outcome and Deviations

- **What shipped**: Added the GitHub-discoverable, Quarkus/Maven-aware
  code-review skill and delegated the local reviewer and prompt to it. Added the
  HT-4 backlog, plan, and boundary decision records. GitHub automatic
  pull-request review successfully discovered and applied the skill.
- **Files**: `.github/skills/code-review/SKILL.md`,
  `.github/agents/quarkus-reviewer.agent.md`,
  `.github/prompts/review-quarkus-change.prompt.md`, `docs/backlog.md`, this
  plan, and `docs/decisions/ADR-HT-4-code-review-skill-boundary.md`.
- **Verification**: `git diff --check` passed; frontmatter and trailing
  whitespace checks passed; the duplicate-checklist check passed; and
  `./mvnw verify -B` passed with 3 tests, 0 failures, and 0 errors. The local
  Quarkus Reviewer pass reported no findings, and GitHub automatic review was
  confirmed successful on the pull request.
- **Deviations**: None.
- **Follow-up**: None.