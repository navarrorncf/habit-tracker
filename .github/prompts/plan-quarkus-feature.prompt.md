---
name: Plan a Quarkus Feature
description: "Use after a backlog ticket has passed discovery to plan a Quarkus endpoint, entity, persistence behavior, configuration change, or learning exercise before editing files."
argument-hint: "Describe the feature or concept to plan"
agent: "plan"
---

# Plan a Quarkus Feature

Plan the selected backlog ticket without editing files. This prompt consumes a
discovery brief; it does not replace the discovery interview.

Inspect [project rules](../../AGENTS.md), the relevant scoped instructions in
`../../.github/instructions/`, nearby Java code, tests, configuration, and the
Maven project definition before making recommendations. Also read the relevant
entry in `../../docs/backlog.md` and the active ticket plan when one exists.

Return:

1. The discovery status and a concise summary of confirmed scope, non-goals,
    assumptions, risks, gaps, dependencies, affected surfaces, and unresolved
    questions. Do not hide a blocker in an implementation detail.
2. The behavior and learning goal in concrete terms.
3. Existing patterns that should be reused and any pattern that is missing.
4. The smallest file-level change set.
5. Required Quarkus extensions, configuration, schema, or seed-data changes,
   clearly separated from optional improvements.
6. Tests to add or update, including the fastest useful check.
7. Commands to run and assumptions that need approval.
8. Documentation updates, ADR candidates, and the Quarkus concepts and
    annotations this exercise will teach.

Do not begin implementation. Do not invent database credentials, add
dependencies, or change architecture without identifying the decision and its
tradeoffs. Do not silently resolve an unresolved discovery question; record it
in the plan or return the ticket to discovery.