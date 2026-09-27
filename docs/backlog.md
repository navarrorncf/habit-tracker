# Backlog

Feature and learning ticket IDs are assigned when work is picked up, not when an idea is first recorded. Numeric IDs are permanent and are never reused. Move the same ticket through the lifecycle instead of creating a second ticket for completion. Backlog and workflow maintenance uses the reserved `HT-X` reference and does not consume a numeric ID.

## Reserved Workflow Ticket

### HT-X: Backlog and workflow maintenance

- **Status**: Ongoing maintenance reference
- **Scope**: Changes to backlog entries, ticket lifecycle rules, documentation maps, plan or ADR templates, and the discovery/planning workflow.
- **Rule**: Use `HT-X` when the change maintains the project-management system itself and would otherwise require a self-referential feature ticket.
- **Current use**: This backlog-management update is tracked under `HT-X`.
- **Exclusions**: Do not use `HT-X` for product behavior, Quarkus learning work, or any other topic that belongs in the numeric ticket sequence.
- **ID policy**: `HT-X` is reserved, is not part of the numeric sequence, and remains available for future workflow-maintenance changes.

## Ideas

Unstarted topics live here without ticket IDs. Not necessarily ordered by priority.

- Linter, formatter and CI quality gate (GitHub workflows)
- Habit entity / model / CRUD / API
- Keycloak IDP integration
- User entity / model / CRUD / API >> user<>habit relation table
- Spike: Tracking modes (daily, weekly, 'x' times per 'y' period, every 'x' period, etc)
- Set up automatic code review in GitHub with a dedicated SKILL.md file

## In Progress

No active tickets.

## Blocked/Parked

No blocked or parked tickets.

## Done

### HT-3: Flyway schema foundation

- **Status**: Done
- **Completed**: 2026-09-25
- **Outcome**: Added BOM-managed Quarkus Flyway support, a versioned PostgreSQL migration for the baseline `Habit` schema, Hibernate schema validation, DevServices-backed persistence tests, and the accepted schema-management decision. Removed the unused generated entity and seed scaffold.
- **Follow-up**: Habit CRUD/API remains in the Ideas section.
- **Related files**: [HT-3 plan](plans/HT-3-flyway-setup.md), [Flyway schema decision](decisions/ADR-HT-3-flyway-schema-management.md), [Habit entity](../src/main/java/com/navarrorncf/Habit.java), [Habit migration](../src/main/resources/db/migration/V1.0.0__create_habit_table.sql), [Habit tests](../src/test/java/com/navarrorncf/HabitTest.java)

### HT-2: Commit and branch validation hooks

- **Status**: Done
- **Completed**: 2026-09-25
- **Outcome**: Added dependency-free POSIX-shell commit-message and pre-push branch validation, repository-local hook installation, pull-request CI enforcement, focused shell tests, contributor documentation, and an accepted tooling decision.
- **Follow-up**: None.
- **Related files**: [HT-2 plan](plans/HT-2-pre-commit-hook.md), [Git validation decision](decisions/ADR-HT-2-git-validation.md), [.githooks/](../.githooks/), [Git convention scripts](../scripts/)

### HT-0: Initial AI tooling

- **Status**: Done
- **Completed**: 2026-09-24
- **Reference**: `ad7b114` — `HT-0: adds AI tooling`
- **Outcome**: Added the portable project contract, AI-assisted development workflow, scoped instructions, reusable prompts, role-specific agents, the Quarkus feature skill, and CI baseline.
- **Follow-up**: HT-1
- **Related files**: [AGENTS.md](../AGENTS.md), [AI-assisted development workflow](ai-assisted-development.md), `.github/`

### HT-1: Project-management workflow

- **Status**: Done
- **Completed**: 2026-09-24
- **Outcome**: Established a docs-as-code backlog, discovery gate, per-ticket plans, and ADR lifecycle for project work.
- **Follow-up**: Future ideas receive the next unused ticket ID when picked up.
- **Related files**: [Documentation guide](README.md), `plans/`, `decisions/`, `.github/skills/discovery-interview/`
