# Contributing

## Prerequisites

Use JDK 25 and the Maven wrapper included in this repository.

## Java quality checks

The build checks formatting, style, and bug-prone code for handwritten Java in
`src/main/java` and `src/test/java`. Generated build output is not checked.

Run the complete local gate with:

```shell
./mvnw verify -B
```

Focused checks are available when working on a specific category:

```shell
./mvnw spotless:check -B
./mvnw checkstyle:check -B
./mvnw spotbugs:check -B
```

Spotless reports formatting differences without changing files. Apply the
approved Java formatting locally with:

```shell
./mvnw spotless:apply -B
```

Checkstyle and SpotBugs findings must be addressed in the source unless a
narrow, evidence-based framework false positive is documented at the
suppression site.

GitHub Actions runs `./mvnw verify -B` for pushes and pull requests targeting
`dev` or `main`. The quality gate is blocking, so the verification command must
pass before a change can merge.
