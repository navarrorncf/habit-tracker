# Project Guidelines

## Project Context

- This is a learning project built with Java 25, Quarkus 3.39.5, Maven, Quarkus REST, Hibernate ORM with Panache, Jackson, and PostgreSQL.
- Use the Maven wrapper (`./mvnw`) so commands use the project's Maven configuration.
- Treat the existing code and configuration as the source of truth. Inspect nearby examples before introducing a new pattern. Where a pattern fails to exist, clarify and document the new pattern so the next time it's in place to be followed.

## Working Agreements

- Keep changes focused and explain unfamiliar Quarkus annotations, extensions, or configuration when they are introduced.
- Prefer the smallest change that satisfies the request. Do not add dependencies, change persistence patterns, or alter deployment configuration without explaining the reason and tradeoffs.
- Never commit credentials, local `.env` files, generated build output, or machine-specific AI configuration.
- Ask for approval before destructive commands, external writes, dependency changes with security or licensing implications, or broad repository changes.

## Build and Test

- Run the narrowest relevant check first, then run `./mvnw verify -B` before claiming a change is complete.
- Use `./mvnw quarkus:dev` for the development loop and live reload.
- Use `./mvnw test` for the fast test suite and `./mvnw package -Dnative` only when native packaging is relevant.
- If a check cannot run, report the reason and do not present the change as fully verified.

## Quarkus Boundaries

- Keep HTTP concerns in REST resources and business or persistence decisions in the appropriate application layer as the project grows.
- Use Panache consistently with the established model. Add transaction boundaries deliberately and test behavior at the layer where it matters.
- Prefer Quarkus-supported extensions and configuration conventions over custom framework plumbing.
- Keep environment-specific values externalized through Quarkus configuration and environment variables.

## Definition of Done

- The implementation, tests, and documentation agree with one another.
- Relevant tests pass, the final Maven verification has been attempted, and the resulting diff is focused.
- The final response names the files changed, checks run, and any remaining uncertainty.

## Documentation and Backlog

- The documentation map and selective-reading protocol live in [docs/README.md](docs/README.md); the broad ticket list is [docs/backlog.md](docs/backlog.md).
- Ideas remain unnumbered until picked up. Picking one up assigns the next unused permanent `HT-N` ticket ID.
- Run `.github/skills/discovery-interview/SKILL.md` before planning a selected ticket. Proceed to implementation only after the discovery result is `ready for planning` and the plan is accepted.
- Keep active discovery summaries and implementation details in the ticket plan. Keep durable cross-cutting decisions in `docs/decisions/`.
- Move completed tickets to the same backlog's `Done` section with outcome and durable links; archive only when that section becomes difficult to scan.

Detailed AI-assisted workflows live in [docs/ai-assisted-development.md](docs/ai-assisted-development.md). File-specific guidance lives under `.github/instructions/`.