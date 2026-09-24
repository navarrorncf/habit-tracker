---
name: Quarkus Test Guidelines
description: "Use when creating or modifying Quarkus tests, REST Assured tests, integration tests, test fixtures, or Maven test configuration."
applyTo: "src/test/**/*.java"
---

# Quarkus Test Guidelines

- Use `@QuarkusTest` for fast tests that exercise the application in the test
  runtime.
- Use `@QuarkusIntegrationTest` for tests that must exercise the packaged
  application. Keep the distinction explicit in the test name and summary.
- Use REST Assured for HTTP behavior and assert status codes and meaningful
  response content, not only that a request completes.
- Keep tests deterministic and isolated. Do not add sleeps, calls to personal
  services, or reliance on an undeclared local process.
- Follow nearby naming, fixture, and setup patterns. Add the smallest fixture
  needed to make the behavior clear.
- Test boundary cases and failure behavior when the change introduces them.
- Run `./mvnw test` for the fast feedback loop, then `./mvnw verify -B` before
  considering the change complete.
- If a test requires PostgreSQL or another external service that is not
  configured in the repository, state that limitation instead of silently
  weakening the test.