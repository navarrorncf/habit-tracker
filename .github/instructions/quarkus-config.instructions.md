---
name: Quarkus Configuration Guidelines
description: "Use when modifying application.properties, Quarkus profiles, datasource settings, seed data, or other files under src/main/resources."
applyTo: "src/main/resources/**"
---

# Quarkus Configuration Guidelines

- Treat `application.properties` as the baseline configuration and use
  profile-specific files only for values that genuinely differ by environment.
- Prefer Quarkus configuration keys and environment-variable overrides over
  custom configuration plumbing.
- Never commit passwords, tokens, private URLs, or machine-specific settings.
  Keep local secrets in ignored environment files or the environment itself.
- Review configuration changes with the related Java code and tests. A new
  property should have a clear consumer and an intentional default or profile.
- Treat `import.sql` as deliberate seed data. Keep it minimal and explain any
  data that tests or development startup depend on.
- Do not enable production-only settings in the development profile or weaken
  security and logging defaults without documenting the reason.