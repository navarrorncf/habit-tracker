# Plan: HT-5 - Linting, formatting, and CI quality gate

- **Status**: Complete
- **Created**: 2026-09-27
- **Completed**: 2026-09-27
- **Backlog**: [HT-5](../backlog.md)

## Discovery Summary

- **Outcome**: `ready for planning`
- **Confirmed scope**:
  - Add pinned Maven plugins for Spotless with Google Java Format, Google Checkstyle, and SpotBugs.
  - Check all handwritten Java production and test sources.
  - Bind the checks to Maven `verify`, keeping `./mvnw verify -B` as the single CI command.
  - Clean existing findings only after an initial pull request proves the gate fails on the current baseline.
  - Document local check and formatting commands in `CONTRIBUTING.md` and link it from `README.md`.
  - Record the quality-policy decision in an ADR.
- **Non-goals**:
  - No non-Java formatting, local pre-push hook, baseline exclusion file, report-only rollout, remote analysis service, or application behavior change.
- **Acceptance checks**:
  - The initial PR run fails on actual pre-existing quality findings.
  - Later commits on the same PR resolve the findings and produce a passing CI run.
  - Focused quality goals and `./mvnw test` and `./mvnw verify -B` pass after cleanup.
  - Contributor documentation and links are accurate.
- **Assumptions**:
  - Selected plugin versions support Maven Wrapper, JDK 25, and Quarkus 3.39.5; focused goals will confirm compatibility.
  - Checkstyle's built-in `google_checks.xml` is available from the plugin.
  - SpotBugs exceptions are added only after a finding is reviewed as a genuine framework false positive.
- **Risks**:
  - Google Checkstyle may expose style debt; format and fix current sources rather than adding broad suppressions.
  - Java 25 bytecode may require newer analysis tooling; adjust only to a compatible pinned version if validation proves the selected version insufficient.
  - SpotBugs may report CDI or Panache patterns; prefer source fixes and document any narrow exception.
- **Gaps**:
  - The exact initial findings are intentionally not resolved before the first PR validation run.
- **Dependencies**:
  - Approved Maven plugin additions and a maintainer-created pull request for the external CI validation.
- **Affected surfaces**:
  - `pom.xml`, `.github/workflows/ci.yml`, handwritten Java sources and tests, backlog/plan/ADR documentation, `CONTRIBUTING.md`, and `README.md`.
- **Unresolved questions**:
  - None blocking implementation. The initial CI run will determine the concrete Java cleanup list.

## Goal and Learning Goal

- **Behavioral goal**: Make formatting, Java style, and bug analysis blocking parts of the Maven verification lifecycle and GitHub Actions.
- **Learning goal**: Understand Maven plugin lifecycle bindings, test-source analysis, and how a CI quality gate fails and recovers across commits on one pull request.

## Implementation Plan

1. Add lifecycle-bound Spotless, Checkstyle, and SpotBugs configuration without cleaning the current Java baseline.
2. Run focused Maven checks to confirm plugin and JDK compatibility, then create the initial PR and observe its real CI failure.
3. Format and fix the reported Java findings in follow-up commits on the same PR.
4. Verify the focused goals, test suite, and complete Maven build, then update this plan and the backlog outcome.

## Affected Files

- `pom.xml` - Quality plugin versions, source scope, and `verify` bindings.
- `.github/workflows/ci.yml` - Describe the existing single Maven quality-gate build step.
- `src/main/java/**/*.java` - Format and fix findings after the initial failing PR run.
- `src/test/java/**/*.java` - Format and fix findings after the initial failing PR run.
- `CONTRIBUTING.md` - Local quality workflow.
- `README.md` - Link to contributor guidance.
- `docs/backlog.md` - HT-5 lifecycle and outcome.
- `docs/decisions/ADR-HT-5-java-quality-gate.md` - Durable tool and policy decision.

## Documentation Updates

- Add the contributor quality workflow and link it from the README.
- Keep the initial failing and subsequent passing CI results in this plan.

## Linked Decisions

- [ADR-HT-5 Java quality gate](../decisions/ADR-HT-5-java-quality-gate.md)

## Verification

```text
./mvnw spotless:check -B
./mvnw checkstyle:check -B
./mvnw spotbugs:check -B
./mvnw test
./mvnw verify -B
```

The first pull request must fail on the unclean Java baseline before the source
cleanup is added. The same pull request must pass after the cleanup commits.

## Implementation Notes

- 2026-09-27: Initial implementation slice added lifecycle configuration and documentation while intentionally leaving Java findings untouched for PR validation.
- 2026-09-27: `./mvnw spotless:check -B` resolved Spotless 2.46.1 and Google Java Format 1.28.0, then failed on formatting differences in all five handwritten Java files.
- 2026-09-27: `./mvnw checkstyle:check -B` resolved Checkstyle 3.6.0 and the built-in Google checks and passed with zero violations.
- 2026-09-27: `./mvnw spotbugs:check -B` resolved SpotBugs 4.9.8.2, completed test analysis on JDK 25, and reported zero bugs or errors.
- 2026-09-27: `./mvnw verify -B` ran the existing three tests successfully, then failed at the lifecycle-bound Spotless check on the same five intentional baseline findings.
- 2026-09-27: The initial pull-request validation failed as intended at the quality-gate build step for the five Spotless findings; no Checkstyle or SpotBugs finding was reported.
- 2026-09-27: `./mvnw spotless:apply -B` formatted the five reported files. The focused Spotless, Checkstyle, and SpotBugs goals then passed; the fast test suite and the complete `./mvnw verify -B` lifecycle also passed.
- 2026-09-27: SpotBugs continues to print a non-fatal missing optional class warning for `jakarta.json.bind.annotation.JsonbTransient`; it reports zero bugs and errors and does not affect the gate.
- 2026-09-27: PR #9's follow-up commit `2e16219` passed the GitHub Actions `build` check. The separate automated pull-request review was still in progress when checked.

## Outcome and Deviations

- **What shipped**: Added Spotless with Google Java Format, Google Checkstyle, and SpotBugs to the Maven verification lifecycle; formatted the existing Java baseline; documented local quality commands; and retained one blocking `./mvnw verify -B` CI command.
- **Files**: `pom.xml`, `.github/workflows/ci.yml`, `README.md`, `CONTRIBUTING.md`, all five handwritten Java files, the HT-5 ADR, this plan, and `docs/backlog.md`.
- **Verification**: The initial PR #9 run failed on the five expected Spotless findings. Follow-up commit `2e16219` passed the GitHub Actions build. Local focused checks, `./mvnw test`, `./mvnw verify -B`, and `git diff --check` passed.
- **Deviations**: SpotBugs emits a non-fatal warning for the optional `jakarta.json.bind.annotation.JsonbTransient` class; it reports zero bugs and errors and does not fail the build.
- **Follow-up**: None.
