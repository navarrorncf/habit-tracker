---
name: discovery-interview
description: "Use when starting a backlog ticket and clarifying scope, assumptions, risks, gaps, dependencies, or implementation impact before planning."
argument-hint: "Describe the backlog ticket to challenge"
user-invocable: true
---

# Discovery Interview

Use this read-only workflow before planning a selected backlog ticket. Its job is
 to challenge the request until the intended behavior, boundaries, and risks are
clear enough to plan. It is a discovery gate, not an implementation workflow.

## Boundaries

- Do not edit files, add dependencies, change configuration, or implement code.
- Do not invent requirements to fill gaps. Surface them as questions or risks.
- Do not paste a full conversation transcript into the repository.
- Do not recommend implementation work until the discovery output is complete.
- Preserve the existing approval boundaries in `AGENTS.md`.

If the selected idea has no ticket ID, stop and ask the coordinator to assign the
next unused ID and move it to `In Progress` before continuing. Ticket IDs are
permanent once assigned.

## Context

Read only the context needed for this ticket:

1. `AGENTS.md` for project rules and the ticket lifecycle.
2. `docs/backlog.md` for the selected ticket and its links.
3. A linked active plan or decision, if one already exists.
4. Nearby code, tests, configuration, or documentation only when it helps answer
a discovery question.

Do not scan all plans, decisions, completed tickets, or unrelated code by default.

## Interview

Ask focused questions in rounds. Use repository evidence to sharpen the
questions, but keep the conversation with the maintainer responsible for the
behavior.

### 1. Outcome

- What user, developer, or learning outcome should exist when this is complete?
- Why is it valuable now?
- What would demonstrate that the outcome is real?

### 2. Scope

- What behavior is explicitly in scope?
- What is explicitly out of scope?
- Which failure paths, validation rules, or edge cases matter?
- What is the smallest useful result?

### 3. Acceptance

- What observable checks determine completion?
- Which checks should be automated, and which may remain manual?
- What documentation or learning material should be updated?

### 4. Assumptions and gaps

Challenge assumptions about:

- data shape, ownership, lifecycle, and existing records;
- API consumers, compatibility, validation, and error responses;
- configuration, environments, secrets, and deployment;
- performance, concurrency, transactions, and failure recovery;
- security, authorization, privacy, and external integrations;
- existing patterns, test coverage, and framework or version constraints.

Record missing information as a gap instead of silently choosing an answer.

### 5. Dependencies and impact

Identify prerequisites, blocked work, integration points, affected code and
configuration, schema or seed-data implications, tests, documentation, and
possible follow-up tickets. Identify decisions that may deserve an ADR.

### 6. Risk review

For each meaningful risk, state its likelihood or impact when useful, how it can
be reduced, and whether it blocks planning. Pay particular attention to database
changes, public API changes, security behavior, dependency changes, deployment,
data migration, concurrency, and irreversible decisions.

## Scaled depth

Choose the smallest depth that is honest about the risk:

- **Quick**: one-file, local, reversible work with no API, data, security,
  dependency, or deployment impact. Confirm outcome, scope, acceptance, and one
  risk or gap check.
- **Standard**: multi-file work, REST behavior, configuration, persistence,
  tests, or a new project pattern. Walk through all interview sections.
- **High risk**: schema or data migration, breaking API behavior, security,
  external services, deployment, dependency/version changes, concurrency, or
  difficult-to-reverse architecture. Walk through all sections and identify
  blockers, mitigation options, approvals, and ADR candidates.

A quick interview may conclude with a short brief. A standard or high-risk
interview must produce the full structured output below.

## Output contract

Return a concise discovery brief with these headings:

- **Discovery status**: `refine backlog`, `ready for planning`, or `park/block`.
- **Ticket**: ID and current backlog stage.
- **Outcome and learning goal**: the result and what the work should teach.
- **Confirmed scope**: behavior included.
- **Non-goals**: behavior deliberately excluded.
- **Acceptance checks**: observable completion checks and failure paths.
- **Assumptions**: assumptions that were confirmed or still need validation.
- **Risks and mitigations**: impact, mitigation, and approval needs.
- **Gaps and dependencies**: missing information, prerequisites, and blockers.
- **Affected surfaces**: code, configuration, data, tests, documentation, and deployment.
- **Decision candidates**: choices that may require an ADR, with alternatives if known.
- **Open questions**: unresolved questions that affect the next step.
- **Handoff**: what the planner should carry into the active plan.

Use `ready for planning` only when the scope is explicit, acceptance checks are
credible, and no unresolved blocker is being hidden as an implementation detail.
Use `refine backlog` when the idea needs a clearer outcome or boundary. Use
`park/block` when a prerequisite, risk, or missing decision prevents responsible
planning.

When the status is `ready for planning`, the next workflow is
`plan-quarkus-feature`. The planner should copy the distilled brief into the
active plan; it should not silently change the confirmed scope or resolve a
blocking question without recording that change.
