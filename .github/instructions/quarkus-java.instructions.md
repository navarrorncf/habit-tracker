---
name: Quarkus Java Guidelines
description: "Use when creating or modifying Java application code, REST resources, CDI beans, Panache entities, or services in this Quarkus project."
applyTo: "src/main/java/**/*.java"
---

# Quarkus Java Guidelines

- Inspect nearby classes before choosing a package, annotation, persistence
  pattern, or response shape.
- Keep HTTP concerns in REST resources. Move business rules into a separate
  application layer when they are reused, stateful, or more complex than the
  resource should own.
- Use CDI scopes and injection consistently with the existing code. Explain
  unfamiliar Quarkus or Jakarta annotations in the change summary.
- Use Hibernate ORM with Panache in the established style. Do not switch
  between active record and repository patterns without a concrete reason.
- Put transaction boundaries around operations that write persistent state and
  verify the boundary with a test. Avoid adding transactions merely to silence
  an error without understanding the persistence operation.
- Prefer Quarkus-supported extensions and configuration over custom framework
  plumbing. Check whether a needed capability already belongs in a Quarkus
  extension before adding a library.
- Keep entities, API contracts, and persistence concerns separate when the
  endpoint requires a stable external shape. Do not introduce DTOs solely for
  ceremony; explain the boundary when adding them.
- Preserve the project's Java version and formatting style. Keep generated
  code and unrelated refactors out of a focused change.