# Changelog

All notable changes to the Agent Pipeline Kit are documented here.

---

## v1.1.0 — 2026-05-21

### Autonomous Project Manager

The Project Manager no longer requires human approval at each handoff. It delegates tasks, routes completed work through review gates, and makes backlog routing decisions autonomously.

**Changes:**
- **PM runs without human gating** — no more "approve the backlog" checkpoint or per-handoff approval pauses. The PM reads the backlog and starts delegating immediately after the Requirements Agent finishes.
- **Intelligent routing on rejection** — when a review gate rejects a task, the PM decides: send back to the Coding Agent for rework, or mark `BLOCKED` in the backlog and move on to the next available task.
- **3-strike rule** — tasks that fail review 3 times are automatically marked `BLOCKED`. The PM keeps working on other tasks and notifies the human about blockers.
- **New task state: `REWORK`** — tracks when a task is sent back to the Coding Agent after a review rejection, distinct from a fresh `IN PROGRESS` assignment.
- **Human notifications, not approvals** — the PM notifies the human at phase completions, blockers, and pipeline end. The human watches; the PM drives.
- **Auto-triggered Project Summary** — when all tasks reach `DONE`, the PM spawns the Project Summary Agent automatically. No manual trigger needed.

### Multi-Terminal Visibility

- **`watch-pipeline.sh`** — new tmux script that sets up a multi-pane terminal layout so you can see what each agent is doing in its own window
- **QUICKSTART updated** with setup instructions for tmux, iTerm2, and VS Code terminal layouts
- **`docs/task-log.md`** now includes PM routing decisions (not just state transitions), designed for live-tailing with `watch`

### Question Escalation Chain

All subagents are now prohibited from asking the human questions directly during the development phase. The escalation path is:

1. **Subagent** encounters ambiguity → reports question to **Project Manager**
2. **PM checks `docs/project-plan.md`**, `CLAUDE.md`, and task context for the answer
3. **If the PM finds the answer** → responds to the subagent directly, logs the Q&A
4. **If the PM cannot find the answer** → asks the human (the only time the pipeline pauses)

This keeps you out of the weeds on questions the documentation already covers while ensuring real gaps surface fast. The IT Solution Architect is the only exception — it speaks to you directly during the discovery phase, since that conversation *is* the documentation.

**Updated agents:** All 7 subagents now include a "never ask the human directly" rule. The PM includes the full resolution process and logging format for question escalations.

---

## v1.0.0 — 2026-05-15

### Initial Release

Extracted from the [personal-portfolio](https://github.com/brett-hardiman/personal-portfolio) project and generalized for use on any software project.

**Agents included:**
- IT Solution Architect (Opus) — discovery and architecture planning
- Requirements Agent (Sonnet) — backlog decomposition with Given/When/Then acceptance criteria
- Project Manager (Opus) — orchestration, parallelism, state tracking
- Coding Agent (Sonnet) — task implementation with self-check
- Code Review Agent (Sonnet) — acceptance criteria verification and convention compliance
- Security Review Agent (Sonnet) — secrets, input handling, deployment readiness
- CI/CD Integration Agent (Sonnet) — git branching, commits, pull requests
- Project Summary Agent (Sonnet) — README generation from actual project state

**Key changes from the portfolio version:**
- All portfolio-specific assumptions removed (HTML/CSS/JS, GitHub Pages, static site conventions)
- Agents now read `CLAUDE.md` to learn project conventions dynamically
- `CLAUDE.md` is a structured template with placeholder sections to fill in per project
- `docs/` scaffold included with `.gitkeep` files to preserve empty directories
- QUICKSTART.md rewritten for general use with a specific example for the Requirements Generator API project
