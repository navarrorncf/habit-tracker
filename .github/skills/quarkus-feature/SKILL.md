---
name: quarkus-feature
description: "Use when implementing or learning a focused Quarkus feature, REST endpoint, Panache persistence behavior, configuration change, or related test."
argument-hint: "Describe the Quarkus feature or learning exercise"
user-invocable: true
---

# Quarkus Feature Workflow

Use this skill for a change that should leave the repository in a verified,
understandable state. It is intentionally explicit so the workflow teaches
both Quarkus and AI-assisted development.

For a selected backlog ticket, run
`.github/skills/discovery-interview/SKILL.md` first. This skill assumes that
discovery returned `ready for planning` and that the resulting plan was
accepted. Do not use the implementation workflow to bypass unresolved scope,
risk, or dependency questions.

## Procedure

1. **Orient**

   Read [project guidelines](../../../AGENTS.md), the matching files under
   `../../instructions/`, and the nearest production code, tests, resources,
   and `pom.xml` sections. Identify the current pattern before proposing a new
   one.

2. **Plan**

   State the behavior, learning goal, smallest file-level change set, and
   verification command. Classify whether the change affects Java behavior,
   HTTP contracts, persistence, configuration, seed data, dependencies, native
   packaging, or CI.

3. **Check the boundary**

   Ask for approval before adding dependencies, changing versions, modifying
   CI or security settings, touching external services, changing deployment
   behavior, or performing destructive operations. Do not invent database
   credentials.

4. **Implement**

   Make the smallest coherent change. Keep REST, CDI, persistence, and
   configuration responsibilities in their appropriate boundaries. Add or
   update tests with the behavior, including meaningful failure paths.

5. **Verify narrowly**

   Run the cheapest relevant check immediately. Use `./mvnw test` for the fast
   suite. For an HTTP change, exercise the relevant test; for configuration or
   packaging changes, use the narrowest Maven phase that proves the behavior.

6. **Review**

   Inspect the diff for accidental files, secrets, generated output, unrelated
   formatting, and contradictions between code, tests, and documentation. Use
   the read-only Quarkus Reviewer when a second pass is useful.

7. **Complete**

   Run `./mvnw verify -B` when the implementation is complete. Report files
   changed, checks run and their results, Quarkus concepts learned, and any
   remaining uncertainty. Update the active ticket plan with final files,
   tests, documentation, deviations, and follow-up work. Move the same ticket
   to `Done` with its outcome and durable links. If a check cannot run, state
   why.

## Output format

Return these sections:

- **Behavior**: what changed and why.
- **Learning**: the Quarkus and AI workflow concepts involved.
- **Verification**: commands run and results.
- **Risks**: open questions, assumptions, or deferred work.