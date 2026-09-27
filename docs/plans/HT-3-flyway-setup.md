# Plan: HT-3 - Flyway schema foundation

- **Status**: Complete
- **Created**: 2026-09-25
- **Completed**: 2026-09-25
- **Backlog**: [HT-3](../backlog.md)

## Discovery Summary

- **Outcome**: `ready for planning`
- **Confirmed scope**:
  - Add Quarkus Flyway support for the existing PostgreSQL datasource.
  - Let Flyway own forward-only schema evolution through a first versioned migration.
  - Add a minimal active-record Panache `Habit` entity with generated `Long id` and required, non-unique `name`.
  - Use PostgreSQL DevServices for dev/test and keep datasource credentials external.
  - Run automatic Flyway migration only in dev/test profiles; in any other profile the migration execution is a separate release concern.
  - Validate the Hibernate model against the Flyway-managed schema.
- **Non-goals**:
  - Habit CRUD/API, user ownership, authentication, seed data, rollback scripts, production migration orchestration, or deployment changes.
  - Retaining the unused generated `MyEntity` scaffold as a persistence entity.
- **Acceptance checks**:
  - Flyway is a BOM-managed Quarkus dependency, validates during migration, and applies the baseline migration at startup.
  - Hibernate schema validation succeeds against the migration-created `habit` table and sequence.
  - A test persists and reloads a `Habit` with a generated ID and the expected name.
  - Existing greeting tests remain unchanged and pass, including packaged startup coverage.
  - `./mvnw verify -B` passes when implementation is complete.
- **Assumptions**:
  - `PanacheEntity` remains the project convention and its default generated `Long` identifier is appropriate for the baseline.
  - A `VARCHAR(255) NOT NULL` name is the smallest useful database contract; uniqueness and application-level validation are deferred.
  - Quarkus PostgreSQL DevServices is available through the existing JDBC extension and a local container runtime.
- **Risks**:
  - Editing an applied migration would invalidate Flyway history; future changes must use new versioned migrations.
  - Hibernate and Flyway must agree on sequence metadata; the focused test verifies this before broader checks.
  - Tests depend on Docker or Podman for PostgreSQL DevServices; the environment must not be weakened to hide that dependency.
- **Gaps**:
  - The repository does not select a production deployment platform or migration-job mechanism; production migrations must run as a separate release step before application rollout.
- **Dependencies**:
  - Existing Quarkus 3.39.5 BOM, `quarkus-jdbc-postgresql`, Maven wrapper, and a container runtime for DevServices.
- **Affected surfaces**:
  - Maven dependency management, Panache entity model, Flyway resources, Hibernate configuration, database schema, persistence tests, backlog, plan, and ADR.
- **Unresolved questions**:
  - None blocking implementation.

## Goal and Learning Goal

- **Behavioral goal**: Start dev/test with a Flyway-managed PostgreSQL schema containing the baseline `Habit` table, while production expects a separately migrated schema and Hibernate validates rather than generates it.
- **Learning goal**: Practice Quarkus extension configuration, Flyway versioned migrations, Panache active-record entities, generated identifiers, DevServices, and schema validation.

## Implementation Plan

1. Add `quarkus-flyway`, Flyway startup/validation settings, and Hibernate schema validation configuration.
2. Add `Habit`, its sequence-compatible baseline migration, and remove the unused generated entity and seed scaffold.
3. Add focused `@QuarkusTest` coverage for migration startup and persistence; use the existing packaged integration test to verify production-mode startup.
4. Run focused tests, full Maven verification, diagnostics, and final diff review.
5. Complete this plan and move HT-3 to `Done`.

## Affected Files

- [pom.xml](../../pom.xml) - add `quarkus-flyway` without a hard-coded version.
- [Habit.java](../../src/main/java/com/navarrorncf/Habit.java) - new active-record Panache entity.
- `src/main/java/com/navarrorncf/MyEntity.java` - removed generated scaffold.
- [application.properties](../../src/main/resources/application.properties) - Flyway startup and Hibernate schema ownership settings.
- [V1.0.0__create_habit_table.sql](../../src/main/resources/db/migration/V1.0.0__create_habit_table.sql) - first schema migration.
- `src/main/resources/import.sql` - removed obsolete commented seed scaffold.
- [HabitTest.java](../../src/test/java/com/navarrorncf/HabitTest.java) - migration and persistence tests.
- [backlog.md](../backlog.md) - HT-3 lifecycle state.
- [ADR-HT-3-flyway-schema-management.md](../decisions/ADR-HT-3-flyway-schema-management.md) - durable schema ownership decision.

## Documentation Updates

- Record the Flyway/Hibernate schema ownership decision in the linked ADR.
- Keep the broad Habit CRUD/API idea in the backlog as future work.

## Linked Decisions

- [ADR-HT-3 Flyway schema management](../decisions/ADR-HT-3-flyway-schema-management.md) - Flyway owns forward-only schema evolution and Hibernate validates it.

## Verification

```text
./mvnw test
./mvnw verify -B
./mvnw verify -B -DskipITs=false
```

The focused `./mvnw test` check passed with PostgreSQL DevServices, Flyway migration startup, Hibernate schema validation, and Habit persistence assertions. `./mvnw verify -B` and `./mvnw verify -B -DskipITs=false` also passed; the latter exercised the packaged application through `GreetingResourceIT`.

## Implementation Notes

- The current Quarkus key is `quarkus.hibernate-orm.schema-management.strategy=validate`; the older `database.generation` key was not introduced. Flyway validation remains part of `migrate-at-start` through its default validate-on-migrate behavior; a separate pre-migration `validate-at-start` setting would reject the pending baseline migration.
- `PanacheEntity` uses a generated `Long` ID with sequence metadata, so the migration creates `habit_seq` with an allocation increment of 50 rather than using `BIGSERIAL`.
- `Habit.findById` needed an explicit `Habit` target type in the test because `var` inferred Panache's upper bound.
- The generated `MyEntity` class and commented `import.sql` were removed so the persistence model has one intentional entity and one schema owner.
- Automatic migration is enabled only for `%dev` and `%test`; production requires a separate migration step before startup.
- A temporary `HabitIT` wrapper was not retained because `@QuarkusIntegrationTest` rejects inherited CDI injection; the existing `GreetingResourceIT` provides packaged startup coverage while Habit has no REST contract yet.

## Outcome and Deviations

- **What shipped**: Added Flyway schema ownership, profile-scoped startup migration, the `Habit` entity and baseline PostgreSQL migration, Hibernate validation, focused persistence tests, and the HT-3 decision/plan records.
- **Files**: [Flyway configuration](../../src/main/resources/application.properties), [Habit entity](../../src/main/java/com/navarrorncf/Habit.java), [migration](../../src/main/resources/db/migration/V1.0.0__create_habit_table.sql), [tests](../../src/test/java/com/navarrorncf/HabitTest.java), and [ADR](../decisions/ADR-HT-3-flyway-schema-management.md).
- **Verification**: `./mvnw test`, `./mvnw verify -B`, and `./mvnw verify -B -DskipITs=false` passed with PostgreSQL DevServices and packaged integration startup.
- **Deviations**: Removed the separate `quarkus.flyway.validate-at-start` setting because it validates before `migrate-at-start` and rejects a pending baseline migration; Flyway validates during migration by default. Did not retain a `HabitIT` wrapper because inherited CDI injection is unsupported in `@QuarkusIntegrationTest`. Production migration orchestration remains deployment-specific and is documented rather than added to this Quarkus-only ticket.
- **Follow-up**: Habit CRUD/API remains a future backlog idea.
