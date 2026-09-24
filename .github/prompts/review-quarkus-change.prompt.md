---
name: Review a Quarkus Change
description: "Use when reviewing a Quarkus or Maven change for correctness, regressions, missing tests, configuration risks, and learning value."
argument-hint: "Describe the change or leave empty to review the current diff"
agent: "Quarkus Reviewer"
---

# Review a Quarkus Change

Review the current diff and the surrounding code. Do not edit files.

Prioritize findings over summary. For each finding, include severity, a
clickable file reference when available, the concrete risk, and a focused fix
or test. Check:

- REST behavior, HTTP contracts, validation, and error handling;
- CDI scopes, transaction boundaries, and Panache usage;
- configuration profiles, secrets, and PostgreSQL assumptions;
- test isolation, coverage of failure paths, and the distinction between
  `@QuarkusTest` and `@QuarkusIntegrationTest`;
- dependency, native-image, build, and CI implications;
- whether the change teaches and follows the project's documented patterns.

State clearly when no issue is found, then list remaining test gaps and a short
change summary.