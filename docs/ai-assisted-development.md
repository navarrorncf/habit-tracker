# AI-Assisted Development

This repository treats AI assistance as a development workflow with explicit
boundaries, not as an invisible replacement for engineering judgment. The
portable project contract is in [AGENTS.md](../AGENTS.md). Client-specific
Copilot workflows live under `.github/`.

## Two configuration layers

`AGENTS.md` is the portable layer. It describes project facts, conventions,
commands, safety boundaries, and the definition of done. Keep it concise
because compatible agents may load it for every task.

The `.github/` layer adds features understood by GitHub Copilot and VS Code:

- `instructions/` contains focused rules that load for matching files or
  relevant tasks.
- `prompts/` contains reusable, single-purpose task templates.
- `agents/` contains role-specific agents with deliberately limited tools.
- `skills/` contains on-demand procedures and any small supporting resources.

These client-specific files improve the workflow, but the project must remain
understandable and safe when an agent only reads `AGENTS.md`.

## The primitives

Use the smallest primitive that fits the problem:

| Primitive | Purpose | Example in this project |
| --- | --- | --- |
| Always-on instructions | Rules for every task | Java, Quarkus, Maven, and safety rules in `AGENTS.md` |
| Scoped instructions | Rules for a file type or concern | REST code, tests, and resource configuration |
| Prompt | One focused request with a repeatable output | Plan a feature or review a change |
| Skill | A multi-step procedure used on demand | Implement and verify a Quarkus feature |
| Custom agent | A role with a purpose and tool boundary | Implementer, reviewer, or mentor |
| Hook | Deterministic lifecycle enforcement | A future check that asks before a dangerous command |
| MCP | An external tool or data integration | A future, explicitly approved service integration |
| Harness | The controlled loop around an agent | Context, action, checks, review, and result |

Instructions and prompts guide an agent. Skills organize repeatable work.
Custom agents control roles and tools. Hooks enforce selected behavior at
runtime. A harness combines these pieces with deterministic checks.

## Discovery gate

When a backlog ticket is selected, run the on-demand
`.github/skills/discovery-interview/SKILL.md` before planning. The discovery
workflow is read-only: it challenges the outcome, scope, non-goals, acceptance
checks, assumptions, risks, gaps, dependencies, and affected surfaces. It
returns `refine backlog`, `ready for planning`, or `park/block`.

Only a ticket marked `ready for planning` should move to the feature planner.
Copy the distilled discovery brief into the active ticket plan; do not store a
full conversation transcript or load unrelated plans and decisions.

## First workflow

After discovery returns `ready for planning`, use the following workflow for a
small feature or learning exercise:

1. State the goal and the behavior that should change.
2. Ask the agent to inspect nearby code, tests, configuration, and relevant
   project instructions before proposing an implementation.
3. Choose a focused prompt, skill, or agent. Use the mentor for explanations,
   the planner for design, the implementer for edits, and the reviewer for a
   second pass. Do not use the implementer to bypass discovery or planning.
4. Confirm the proposed file changes, dependency changes, configuration
   changes, and commands before allowing work that has external consequences.
5. Make the smallest implementation that fits existing patterns.
6. Run the narrowest relevant check first. For this project, use `./mvnw test`
   for the fast suite and `./mvnw verify -B` for the final build gate.
7. Review the diff, ask for unresolved risks, and record any new convention
   that future work should follow.

The agent should report what it inspected, what it changed, which checks ran,
and what remains uncertain. Passing tests do not replace reviewing the design
or the diff.

## Approval boundary

Agents may inspect the repository and run ordinary local checks. Ask for
approval before:

- deleting or rewriting data, files, or history;
- adding dependencies or changing versions;
- writing to external services, opening pull requests, or publishing artifacts;
- changing CI, deployment, authentication, or security configuration;
- committing secrets or machine-specific configuration.

The existing `.gitignore` excludes `.env`, build output, and local editor
state. Do not weaken those protections to make an agent workflow convenient.

## Context hygiene

- Start from the smallest relevant code surface and expand only when evidence
  requires it.
- For ticket work, read `AGENTS.md`, the relevant entry in `docs/backlog.md`,
  the active ticket plan, and only the decisions linked from that plan.
- Prefer links to durable project documentation over copying large instructions
  into prompts or agents.
- Keep prompts single-purpose and descriptions keyword-rich so the right one is
  discoverable.
- Do not put credentials, private prompts, model settings, or personal MCP
  endpoints in the repository.
- Update the relevant instruction or workflow when a project convention changes.

## Full harness, later

The first iteration uses a visible, manual harness. A fuller harness can add
hooks, validation scripts, task fixtures, and CI checks after repeated use
shows which failures are worth automating.

Hooks are appropriate for deterministic policy such as asking before a
destructive tool call. Evaluation fixtures are appropriate for checking
whether a known task produces the expected files and passing tests. Neither
should score prose style or replace human review. Automation adds confidence,
but also adds maintenance and coupling to a particular client or tool version.

## Updating this setup

When adding a new rule, first decide whether it applies to every task, a file
pattern, a single workflow, or a role. Put it in `AGENTS.md`, a scoped
instruction, a prompt, a skill, or an agent accordingly. Keep one source of
truth and remove stale rules instead of layering contradictory guidance.