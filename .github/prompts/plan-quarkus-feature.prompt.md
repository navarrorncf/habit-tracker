---
name: Plan a Quarkus Feature
description: "Use when planning a new Quarkus endpoint, entity, persistence behavior, configuration change, or learning exercise before editing files."
argument-hint: "Describe the feature or concept to plan"
agent: "plan"
---

# Plan a Quarkus Feature

Plan the requested change without editing files.

Inspect [project rules](../../AGENTS.md), the relevant scoped instructions in
`../../.github/instructions/`, nearby Java code, tests, configuration, and the
Maven project definition before making recommendations.

Return:

1. The behavior and learning goal in concrete terms.
2. Existing patterns that should be reused and any pattern that is missing.
3. The smallest file-level change set.
4. Required Quarkus extensions, configuration, schema, or seed-data changes,
   clearly separated from optional improvements.
5. Tests to add or update, including the fastest useful check.
6. Commands to run and assumptions that need approval.
7. The Quarkus concepts and annotations this exercise will teach.

Do not invent database credentials, add dependencies, or change architecture
without identifying the decision and its tradeoffs.