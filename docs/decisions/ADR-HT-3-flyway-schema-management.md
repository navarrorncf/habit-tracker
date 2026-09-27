# ADR: Flyway schema management

- **Status**: Accepted
- **Date**: 2026-09-25
- **Ticket**: [HT-3](../backlog.md)

## Context

The project currently relies on Quarkus development defaults for database schema generation and contains only a commented `import.sql` scaffold. The first real entity needs a repeatable schema definition that can evolve without allowing Hibernate to silently change database structure.

The project also uses PostgreSQL DevServices in development and tests, while production connection details must remain external. The initial migration must match the generated identifier metadata used by `PanacheEntity`.

## Options Considered

1. **Flyway migrations with Hibernate schema validation**
   - Advantages: Versioned, reviewable, forward-only schema changes; startup applies migrations and Hibernate detects model/schema drift.
   - Costs: Developers must add a new migration for every schema change and keep sequence/table metadata aligned with the entity model.
2. **Hibernate-generated schema**
   - Advantages: Minimal setup and convenient live reload for early experiments.
   - Costs: Schema changes are not versioned, can be destructive or environment-dependent, and do not establish a production migration history.
3. **Flyway migrations with Hibernate schema generation disabled and no validation**
   - Advantages: Clear ownership boundary and fewer startup checks.
   - Costs: Mapping drift can go unnoticed until runtime, weakening the learning and safety value of the migration setup.

## Decision

Use the Quarkus Flyway extension with migrations in the default `db/migration` classpath directory. Apply migrations automatically in dev and test profiles; Flyway validates migration history as part of that migration operation. Production application startup does not run migrations automatically: a separate release step must run them before the application starts. Disable Flyway clean operations and configure Hibernate with `quarkus.hibernate-orm.schema-management.strategy=validate`. Do not use `import.sql` for seed data or add rollback scripts.

The first migration creates the `habit_seq` sequence and `habit` table required by the active-record `Habit` entity. PostgreSQL DevServices remains the dev/test database provider; no credentials or production JDBC URL are committed.

## Consequences

- Schema evolution is explicit, reviewable, and forward-only.
- Hibernate catches model/schema drift during startup instead of generating tables.
- Applied migration files must not be edited; later changes require new versioned migrations.
- Development and tests require a Docker- or Podman-compatible runtime for PostgreSQL DevServices.
- Production deployments need a separate migration job or release step with DDL-capable credentials before application rollout; the repository does not prescribe a deployment platform yet.
- Production rollback policy and data transformation procedures remain follow-up concerns.

## Links

- Backlog: [HT-3](../backlog.md)
- Plan: [HT-3 plan](../plans/HT-3-flyway-setup.md)
- Code: [Habit entity](../../src/main/java/com/navarrorncf/Habit.java), [baseline migration](../../src/main/resources/db/migration/V1.0.0__create_habit_table.sql)
- Tests: [HabitTest](../../src/test/java/com/navarrorncf/HabitTest.java)
- Supersedes or related: None
