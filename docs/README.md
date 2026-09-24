# Documentation Guide

This directory is the durable project knowledge layer. Keep the backlog broad, put active work in a focused plan, and record important design choices as separate decisions.

## Document Map

| Location | Purpose | Default context |
| --- | --- | --- |
| `backlog.md` | Broad ideas, ticket stages, and completed ticket index | Read when selecting or locating work |
| `plans/` | Discovery summaries and implementation plans for individual tickets | Read only for the active ticket |
| `decisions/` | Durable architecture and design decisions | Read only when linked or relevant |
| `ai-assisted-development.md` | AI workflow principles and role boundaries | Read when changing the workflow |

## Reading Protocol

1. Read [AGENTS.md](../AGENTS.md) for project rules and the lifecycle.
2. Locate the ticket in [backlog.md](backlog.md).
3. For active work, read only that ticket's plan under `plans/`.
4. Follow links from the plan to relevant decisions under `decisions/`.
5. Read user-facing documentation or nearby code only when the task requires it.

Do not scan all plans, decisions, or completed history by default. Links are the routing mechanism that keeps context focused.

## Ticket Lifecycle

- Ideas remain broad and unnumbered until work is picked up.
- Picking up an idea assigns the next unused `HT-N` ticket ID and moves it to `In Progress`.
- Backlog and workflow maintenance uses the reserved `HT-X` reference. It does not consume a numeric ID and is not a substitute for a product or learning ticket.
- Discovery challenges the scope, assumptions, risks, gaps, dependencies, and affected surfaces.
- A ticket that is ready for implementation gets a plan under `plans/`.
- Implementation updates the plan with files, tests, documentation, deviations, and follow-up work.
- Completion moves the same ticket to `Done` with its completion date, outcome, and durable links.
- Older completed entries may move to a dated archive only when the `Done` section becomes difficult to scan.
