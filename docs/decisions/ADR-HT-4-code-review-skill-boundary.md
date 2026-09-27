# ADR-HT-4: Shared code-review skill boundary

- **Status**: Accepted
- **Date**: 2026-09-27
- **Ticket**: [HT-4](../backlog.md)

## Context

GitHub's automatic pull-request reviewer requested a repository skill at
`.github/skills/code-review/SKILL.md`. The local `Quarkus Reviewer` already
contained a useful review checklist, but keeping that checklist only in the
agent would leave the hosted reviewer without the project's review standards.
Duplicating the checklist in the agent, prompt, and skill would allow the
standards to drift.

The local agent also has responsibilities that are not review methodology: it
defines the reviewer identity, invocation metadata, and a read-only tool
boundary. Those responsibilities should remain local to the agent.

## Options Considered

1. **Keep the methodology in the local agent**
   - Advantages: smallest immediate change and no new shared file.
   - Costs: GitHub cannot use the local agent file as the requested skill;
     hosted and local review would not share one source of truth.
2. **Duplicate the methodology in the skill, agent, and prompt**
   - Advantages: each invoker has a self-contained checklist.
   - Costs: changes must be synchronized manually and conflicting guidance can
     produce inconsistent reviews.
3. **Put the methodology in a shared skill and keep invoker boundaries local**
   - Advantages: GitHub and the local reviewer use one review contract while
     each caller keeps its own tool and role policy.
   - Costs: local agents must explicitly load the skill, and GitHub behavior
     still needs a manual pull-request acceptance check.

## Decision

Use `.github/skills/code-review/SKILL.md` as the single source of truth for the
read-only review procedure, severity and evidence guidance, Quarkus/Maven
profile, and findings-first output contract. Give the skill a generic `code-review`
name for GitHub discovery while making its current project profile explicitly
Quarkus-aware.

Keep `.github/agents/quarkus-reviewer.agent.md` responsible for the local
reviewer identity, frontmatter, available `[read, search, execute]` tools, and
the instruction to follow the skill. Keep the review prompt as a thin local
invoker rather than another copy of the checklist.

## Consequences

- GitHub automatic review and the local reviewer have one repository-owned
  review procedure.
- Tool permissions and role identity remain caller-specific and are not implied
  by the skill.
- The Quarkus/Maven profile is reusable within this repository but should be
  expanded or split if a future project needs materially different review rules.
- GitHub skill discovery remains an external behavior that must be confirmed on
  a test pull request; local Maven checks cannot prove it.

## Links

- Backlog: [HT-4](../backlog.md)
- Plan: [HT-4 code-review skill plan](../plans/HT-4-code-review-skill.md)
- Skill: [code-review skill](../../.github/skills/code-review/SKILL.md)
- Agent: [Quarkus Reviewer](../../.github/agents/quarkus-reviewer.agent.md)