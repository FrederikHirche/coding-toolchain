---
name: coding-toolchain
description: Execute this repository's Claude-first AI Development Tool Chain in Codex. Use when the user invokes or discusses /kickoff, /status, /sprint, /ba, /architect, /ux, /refine, /analyze, /implement, /test-plan, /test-run, /review, /manual, /hotfix, /spike, /converge, /retro, /health-check, /coach, /impediment, a named PM/BA/AR/UX/FE/BE/QA/RV/MW/AC role, project gates, .phase state, or SB/CON/REQ/US/ADR/GAP/UX/SP/TP/TR/BUG/RV/DOC/RN/RETRO artifacts.
---

# Coding Toolchain

Treat `CLAUDE.md` as the canonical functional specification. This skill only translates
its activation model to Codex.

## Execute a command

1. Resolve the command name and project name from the request. Ask only when the missing
   value cannot be derived safely.
2. Read these files completely in order:
   - repository-root `CLAUDE.md`;
   - `.claude/commands/<command>.md`;
   - `toolchain/agents/_base-agent.md`;
   - every agent definition named by the command;
   - the referenced workflow and required protocols.
3. Read `projects/<name>/.phase`, its `INDEX.md` files and only the artifacts needed for
   the active phase.
4. Apply the command's preconditions and the gate protocol before writing.
5. Use the matching template for every artifact. Allocate the next six-digit ID from the
   actual project state, not from an assumption.
6. Update the target `INDEX.md`, artifact handoff and `.phase` when required.
7. Run the active role's Definition of Done and report unmet items as `OFFEN`.
8. End with the exact next command including the project name.

## Route commands

| Command family | Canonical sources |
|---|---|
| `/status`, `/sprint`, `/analyze` | command file, `orchestrator.md`, selected workflow |
| `/kickoff` | command file, `pm-agent.md`, stakeholder-brief and constitution templates |
| `/ba`, `/refine` | command file, `ba-agent.md`, requirements/story/backlog templates |
| `/architect`, `/spike`, `/converge` | command file, `architect-agent.md`, ADR/spike/gap-analysis templates |
| `/ux` | command file, `ux-agent.md`, UX template |
| `/implement` | command file, frontend/backend agent definitions |
| `/test-plan`, `/test-run` | command file, `qa-agent.md`, testing templates |
| `/review` | command file, `reviewer-agent.md`, review template |
| `/manual` | command file, `manual-writer-agent.md`, documentation templates |
| `/hotfix` | command file, hotfix workflow and all roles it activates |
| `/retro`, `/health-check`, `/coach`, `/impediment` | command file and `agile-coach-agent.md` |

## Preserve Claude priority

- Do not rewrite `.claude/commands/` into Codex-only syntax.
- Do not change a canonical agent prompt merely to fit a Codex adapter.
- Put Codex-only behavior under `.codex/`, `.agents/` or `AGENTS.md`.
- If this skill conflicts with `CLAUDE.md`, follow `CLAUDE.md`.

## Delegate carefully

Use native Codex agents only when explicitly requested, when `/sprint` benefits from
independent phase work, or when `/implement all` permits FE/BE parallelism. Preserve gate
order, API-contract dependencies and reviewer independence. The primary agent owns final
gate decisions, `.phase` changes and the user-facing handoff.
