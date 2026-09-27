---
name: code-review
description: "Use when reviewing pull requests, code diffs, or Quarkus and Maven changes for correctness, regressions, security, tests, configuration, build, or CI risks."
argument-hint: "Describe the pull request or diff to review"
user-invocable: true
---

# Code Review

Use this skill for a read-only review of a pull request, change, or diff. It is
the shared review procedure for GitHub's automated pull-request reviewer and
the local Quarkus Reviewer. The invoking agent supplies the available tools and
publishing mechanism; this skill supplies the review method and report contract.

## Boundaries

- Do not modify source, tests, configuration, documentation, or repository
  history while reviewing.
- Use only focused, non-destructive checks when they can distinguish a possible
  finding or establish an important limitation.
- Do not treat passing tests as proof that the design or behavior is correct.
- Do not report a speculative style preference as a defect. Report a finding
  only when there is a concrete trigger, impact, and actionable fix or test.
- Distinguish problems introduced by the change from pre-existing observations.
  Mention pre-existing risks only when they affect the changed behavior or are
  necessary to explain a review limitation.

## Procedure

1. **Orient**
   - Read the project contract, applicable scoped instructions, and this skill.
   - Identify the pull request intent, changed files, and relevant base and head
     behavior.
   - Inspect the complete diff, including additions, deletions, and test or
     configuration changes.
2. **Trace the behavior**
   - Read the nearest controlling implementation, callers, tests, and
     configuration needed to understand the changed path.
   - Check the normal path, failure paths, boundary inputs, compatibility, and
     security implications that the diff can affect.
   - Prefer repository evidence over assumptions about framework behavior.
3. **Verify selectively**
   - Run a focused test, static check, or build command only when it provides
     evidence for or against a suspected issue.
   - Keep checks deterministic and local. Do not depend on personal services,
     undeclared processes, credentials, or destructive setup.
   - Record meaningful test gaps, environment limitations, and unverified
     assumptions in the report.
4. **Classify findings**
   - Order findings by severity and then by practical impact.
   - Use `Critical` for a likely security breach, data loss, or blocking outage;
     `High` for a likely severe correctness or security regression; `Medium`
     for a bounded user or operational defect; and `Low` for a smaller concrete
     correctness or maintainability risk.
   - Do not inflate severity for missing polish. A missing test is a finding
     when it leaves a meaningful behavior or failure path unprotected.
5. **Report**
   - Put findings first. Each finding must identify the severity, file and line
     or diff location, triggering condition, concrete impact, and a focused fix
     or test.
   - If no findings are supported by the evidence, say so explicitly and list
     remaining test gaps or residual risks instead of inventing issues.

## Quarkus and Maven Profile

Apply only the checks relevant to the changed surface:

- **REST**: resource contracts, HTTP methods and status codes, validation,
  serialization, error responses, and compatibility for existing consumers.
- **CDI and persistence**: bean scopes, injection, transaction boundaries,
  Panache usage, lazy-loading boundaries, and behavior under failure or
  concurrent requests.
- **Schema and database**: Flyway versioning and ordering, deterministic
  forward-only migrations, schema validation, PostgreSQL assumptions, and the
  absence of credentials or machine-specific settings.
- **Configuration and security**: profile selection, environment overrides,
  secret handling, authentication and authorization boundaries, and assumptions
  about external services.
- **Tests**: deterministic fixtures and isolation, meaningful assertions,
  failure-path coverage, and the distinction between `@QuarkusTest` and
  `@QuarkusIntegrationTest`.
- **Build and delivery**: Maven lifecycle behavior, dependency and version
  changes, native-image implications, CI consequences, and whether generated
  or build output was included accidentally.
- **Project workflow**: consistency with `AGENTS.md`, scoped instructions,
  ticket plans, decisions, and the learning goal of the change.

## Output

Use this structure:

### Findings

List findings first, ordered by severity. For each finding, include:

- **Severity and location**: for example, `High - src/main/...:42`.
- **Risk**: the concrete behavior and affected user, data, or operation.
- **Evidence**: the code path, condition, or focused check supporting it.
- **Suggested fix or test**: the smallest change that would address or verify it.

If there are no supported findings, write `No findings.` under this heading.

### Open Questions and Assumptions

Record unresolved product or implementation questions, environment limitations,
and assumptions that could change the conclusion.

### Test Gaps and Residual Risks

Name relevant untested paths, unavailable services, or risks that do not meet
the threshold for a finding.

### Change Summary

Briefly describe what the change does and what was reviewed. Keep this section
after findings and risk information.