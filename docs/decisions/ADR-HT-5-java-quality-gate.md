# ADR-HT-5: Java quality gate

- **Status**: Proposed
- **Date**: 2026-09-27
- **Ticket**: [HT-5](../backlog.md)

## Context

The repository has a Maven verification build and GitHub Actions CI, but no
repeatable Java formatting, style, or bug-analysis policy. The project uses
JDK 25 and Quarkus, and the gate must cover both production and test sources
without changing application behavior or adding an external analysis service.
The rollout should demonstrate that CI can reject the current baseline before
those findings are corrected.

## Options Considered

1. **Spotless with Google Java Format, Checkstyle Google checks, and SpotBugs**
   - Advantages: Deterministic formatting, established Java style rules, and
     bytecode analysis using Maven-native tooling; local and CI commands share
     one configuration.
   - Costs: The existing sources must be cleaned, plugin compatibility with
     JDK 25 must be verified, and framework false positives may need narrow
     documented suppressions.
2. **Report-only checks or a remote Sonar service**
   - Advantages: A softer rollout or broader dashboard/reporting capability.
   - Costs: Findings would not block merges or would require external service
     configuration and credentials, which adds operational coupling.
3. **Project-owned custom Checkstyle rules and local Git-hook enforcement**
   - Advantages: More control over style policy and earlier local feedback.
   - Costs: Extra ruleset and hook maintenance; local hooks are opt-in and
     cannot replace CI enforcement.

## Decision

Use Spotless with Google Java Format, the Checkstyle plugin's built-in Google
checks, and SpotBugs default analysis. Include `src/main/java` and
`src/test/java`. Bind each check to Maven's `verify` phase so the existing CI
command, `./mvnw verify -B`, is the blocking quality gate. Developers may run
`spotless:apply` to fix formatting locally; Checkstyle and SpotBugs findings are
fixed in source unless a narrow, evidence-based framework false positive is
documented at the suppression site.

The first pull request will carry the gate before the current Java baseline is
cleaned. Its failing run is intentional validation of the enforcement path;
follow-up commits on the same pull request will resolve the findings.

## Consequences

- CI and local verification use the same Maven lifecycle configuration.
- Java formatting becomes deterministic and applies to production and test code.
- The initial cleanup produces a one-time source diff, after which quality debt
  is rejected at the verification boundary.
- Plugin versions and JDK 25 compatibility must be maintained as build tooling
  evolves.
- No non-Java formatting, local pre-push enforcement, broad suppression file,
  or remote analysis service is introduced by HT-5.

## Links

- Backlog: [HT-5](../backlog.md)
- Plan: [HT-5 plan](../plans/HT-5-linting-formatting-ci.md)
- Code: [Maven build](../../pom.xml)
- Tests: [Java tests](../../src/test/java/)
- Supersedes or related: None
