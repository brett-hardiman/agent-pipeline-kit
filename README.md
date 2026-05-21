# Agent Pipeline Kit

[![Built With](https://img.shields.io/badge/Built%20With-Claude%20Code-1DB954)](https://docs.anthropic.com/en/docs/claude-code)
[![Agents](https://img.shields.io/badge/Agents-8-7F77DD)](https://github.com/brett-hardiman/agent-pipeline-kit)
[![License](https://img.shields.io/badge/License-MIT-222222)](LICENSE)

A portable team of 8 AI agents that plan, build, review, and ship software autonomously — powered by [Claude Code](https://docs.anthropic.com/en/docs/claude-code). The Project Manager delegates, routes, and decides without waiting for your approval at every step.

**Live site:** [bretthardiman.com](https://bretthardiman.com) — the portfolio site was built entirely by this pipeline.

---

## The Idea

Most people use AI to write code one prompt at a time. This kit does something different: it runs a full software development team where every role — architect, developer, reviewer, project manager — is an AI agent with a specific job, specific rules, and specific handoff points.

You describe what you want to build in plain English. The agents handle the rest: designing the system, breaking work into tasks, writing the code, reviewing it for quality, auditing it for security, and committing it to git with proper branching and pull requests.

You stay in control at every checkpoint. The agents do the repetitive work.

---

## The 8 Agents

Every agent has a defined role, reads from specific files, and writes to specific files. No agent does someone else's job. Here is the full team.

### Agent 1 — IT Solution Architect

The Architect is always the first agent to run. It sits down with you and asks questions: what are you building, who is it for, what technology should it use, what is out of scope. It will push back on bad ideas — if you ask for a heavy framework where a simple solution would work, it will say so and explain why.

Once the conversation is done, the Architect produces a technical blueprint (`docs/project-plan.md`) that becomes the single source of truth for every other agent. Think of it as the building plans before construction starts.

### Agent 2 — Requirements Agent

The Requirements Agent reads the blueprint and breaks it into individual work items — each one small enough for a single developer (the Coding Agent) to complete in one sitting. Every work item includes specific acceptance criteria written in a testable format: "Given this condition, when the user does this, then this should happen."

This is the same process a Business Analyst would follow on a real software team. The output is a backlog of task files in `docs/backlog/`, plus an index that lists every task with its dependencies and status.

### Agent 3 — Project Manager

The Project Manager is the hub and it runs autonomously. It reads the backlog, understands which tasks depend on other tasks, and coordinates the team without waiting for your approval at each handoff. It assigns work to the Coding Agent, routes completed work through review gates, and makes routing decisions when work comes back — sending it to the next gate, back to the Coding Agent for rework, or marking it blocked in the backlog if there is a deeper problem.

The PM also maximizes parallelism — when two tasks have no dependency on each other, it runs them at the same time. It never writes code itself. It never pauses for permission. Its job is to keep the pipeline moving. You watch it work; it notifies you at milestones and when things go wrong.

The PM is also the single point of contact for any question raised mid-pipeline. When a subagent needs clarification, it reports the question to the PM, which walks a defined escalation chain (see [The Question Escalation Chain](#the-question-escalation-chain) below) and only surfaces a question to you when no project document can answer it.

### Agent 4 — Coding Agent

The Coding Agent receives one task at a time and builds exactly what the acceptance criteria specify — nothing more, nothing less. Before reporting completion, it runs a self-check against every criterion to catch obvious issues before the work hits review.

It follows the conventions defined in the project's `CLAUDE.md` file exactly: naming patterns, file locations, error handling style, everything. If the conventions say use `snake_case`, it uses `snake_case`.

### Agent 5 — Code Review Agent

After the Coding Agent finishes a task, the Code Review Agent checks the work. It verifies two things: does the code actually meet the acceptance criteria, and does it follow the project conventions? It produces a structured finding document in `docs/reviews/`.

The verdict is binary — APPROVED or REJECTED. Partial passes are rejections. If the Code Review Agent finds a problem, it documents exactly what needs to change and sends the work back. It never rewrites code itself.

### Agent 6 — Security Review Agent

The Security Review Agent is the last gate before code gets committed. It checks for hardcoded secrets (API keys, passwords), exposed environment values, input handling issues, and anything that would be dangerous in a production deployment.

Any hardcoded secret is an automatic rejection, no exceptions. Like the Code Review Agent, it documents findings and sends work back — it never fixes code itself. Its output goes to `docs/security-reviews/`.

### Agent 7 — CI/CD Integration Agent

CI/CD stands for Continuous Integration / Continuous Deployment — the practice of automatically testing and deploying code changes. This agent handles all git operations: creating a feature branch for each task, committing only the relevant files, and opening a pull request.

It never pushes code directly to the main branch. Everything goes through a pull request so there is a clear record of what changed and why.

### Agent 8 — Project Summary Agent

The last agent to run. After all tasks are complete, the Project Summary Agent reads everything — the project plan, the task log, the actual source code — and writes a clear, accurate `README.md` that explains what was built, how it works, and how to run it.

It writes for two audiences at once: a non-technical person who wants to understand what the project does, and a developer who just downloaded the code and wants to run it in five minutes.

---

## How the Pipeline Flows

The agents execute in a specific order. The Project Manager runs the pipeline autonomously — delegating tasks, routing completed work, and making backlog decisions without human approval at each step.

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│   YOU describe what you want to build                               │
│    │                                                                │
│    ▼                                                                │
│   ┌──────────────────────┐                                          │
│   │  IT Solution         │  Interviews you, challenges assumptions, │
│   │  Architect           │  produces docs/project-plan.md           │
│   └──────────┬───────────┘                                          │
│              │                                                      │
│              ▼                                                      │
│   ┌──────────────────────┐                                          │
│   │  Requirements        │  Breaks the plan into individual tasks   │
│   │  Agent               │  with acceptance criteria                │
│   └──────────┬───────────┘                                          │
│              │                                                      │
│              ▼                                                      │
│   ┌──────────────────────────────────────────────────────────┐      │
│   │  Project Manager (autonomous)                            │      │
│   │                                                          │      │
│   │  Owns the backlog. Delegates. Routes. Decides.           │      │
│   │  No human approval needed per handoff.                   │      │
│   └──────────┬───────────────────────────────────────────────┘      │
│              │                                                      │
│    ┌─────────┴─────────┐     (parallel when no dependencies)        │
│    ▼                   ▼                                            │
│   ┌────────┐   ┌────────┐                                           │
│   │ Coding │   │ Coding │   Each task follows this loop:            │
│   │ Agent  │   │ Agent  │                                           │
│   └───┬────┘   └───┬────┘       Coding Agent                       │
│       │            │                 │                              │
│       ▼            ▼                 ▼                              │
│   ┌────────────────────┐        Code Review ──┐                    │
│   │  Code Review Agent │             │        │ REJECTED →         │
│   └──────────┬─────────┘             ▼        │ back to PM →       │
│              │                  Security ──────┤ rework or          │
│              ▼                  Review   │     │ backlog            │
│   ┌────────────────────┐             ▼  │     │                    │
│   │  Security Review   │        CI/CD ──┘                          │
│   │  Agent             │        Integration                        │
│   └──────────┬─────────┘             │                              │
│              │                       ▼                              │
│              ▼                     DONE → PM assigns next task      │
│   ┌────────────────────┐                                            │
│   │  CI/CD Integration │  Branches, commits, opens pull request     │
│   │  Agent             │                                            │
│   └──────────┬─────────┘                                            │
│              │                                                      │
│              ▼  (when ALL tasks are DONE)                           │
│   ┌──────────────────────┐                                          │
│   │  Project Summary     │  Writes the final README (auto-triggered)│
│   │  Agent               │                                          │
│   └──────────────────────┘                                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Key points:**
- The PM runs autonomously — it delegates, routes, and decides without pausing for your approval
- Rejected work goes back to the PM, which decides: rework (send back to Coding Agent) or backlog (mark blocked, move on)
- After 3 failed reviews, a task is marked `BLOCKED` — the PM keeps working on other tasks
- Every piece of code still passes through two independent review gates before it is committed
- The PM notifies you at phase completions and pipeline end — you watch, you don't gate
- Subagents never ask you questions directly — they route every question through the PM (see below)

---

## The Question Escalation Chain

In v1.1 the kit gained a strict communication discipline: **only two agents are allowed to speak to you directly.** Everything else flows through the Project Manager.

- **IT Solution Architect** talks to you during discovery. That conversation is the source of truth for the whole project, so it stays direct. Once the Architect hands off `docs/project-plan.md`, its job is done and the line closes.
- **Project Manager** is your single point of contact for the rest of the pipeline. Every other agent reports to it.

When a subagent (Coding, Code Review, Security Review, CI/CD, Requirements, Project Summary) needs clarification — e.g. the Security Review Agent wants to know the deployment target, or the Coding Agent finds an ambiguous acceptance criterion — it does **not** prompt you. It reports the question back to the PM with context specific to its role.

The PM then walks a 4-step resolution chain:

1. **Check `docs/project-plan.md`** — does the Architect's blueprint already answer this?
2. **Check `CLAUDE.md`** — is it covered by project conventions?
3. **Check the task file** — does the acceptance criteria or task context resolve it?
4. **Escalate to you** — only if none of the above cover the question.

Either way, every Q&A is logged in `docs/task-log.md` in a dedicated format, so you can see what was asked, where the answer came from, and how it got resolved without scrubbing through agent output.

The net effect: fewer interruptions, every answer grounded in the project's own documents, and a complete written trail of every decision.

---

## Why This Is a Separate Repo

The agents are not tied to any specific project. They are infrastructure — like a toolbox that works in any workshop.

Keeping the kit in its own repository means:

- **Reuse without copying.** When you start a new project, you copy in the `.claude/agents/` folder and the `docs/` scaffold. You do not copy someone else's source code, configuration files, or project-specific conventions with it. Your new project stays clean.

- **Update once, benefit everywhere.** If you improve an agent — for example, making the Security Review Agent check for a new class of vulnerability — you update it in one place. Next time you pull the kit into a project, you get the improved version.

- **No accidental coupling.** If the agents lived inside a specific project (say, a portfolio site), they would inevitably accumulate project-specific assumptions: references to HTML files, static site deployment targets, specific naming patterns. Separating them forces every agent to be truly generic — they learn about your project by reading `CLAUDE.md`, not from hardcoded knowledge.

- **Simpler git history.** Each project's commit history contains only that project's work. The agent definitions have their own history of improvements, tracked separately.

To use the kit in any project, you copy two things:

```bash
# From the agent-pipeline-kit repo into your project
cp -r agent-pipeline-kit/.claude your-project/
cp -r agent-pipeline-kit/docs your-project/
```

Then fill in your project's `CLAUDE.md` with the relevant conventions, and the agents adapt to whatever you are building.

---

## What You Need

- **Claude Code** — the CLI tool the agents run on. Install with `npm install -g @anthropic-ai/claude-code`
- **Agent Teams enabled** — set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in your environment
- **Opus model access** — the Project Manager and IT Solution Architect agents use Opus. The Max plan is recommended for agent team workloads.

Full setup instructions, usage examples, and troubleshooting are in [QUICKSTART.md](QUICKSTART.md).

---

## Project History

This pipeline was originally built to construct [bretthardiman.com](https://bretthardiman.com) — a personal portfolio site. The 8 agents planned, implemented, reviewed, and deployed the entire site: 26 tasks across 4 phases, zero frameworks, zero npm packages. The full story of that build is in the [portfolio repository](https://github.com/brett-hardiman/personal-portfolio).

After seeing how well the agents worked together, the decision was made to extract them into a standalone kit so they could be reused on any project — starting with a FastAPI-based [Requirements Generator API](https://github.com/brett-hardiman/requirements-api).

---

## What's In the Kit

```
agent-pipeline-kit/
├── .claude/
│   └── agents/
│       ├── project-manager.md           # Orchestrator
│       ├── it-solution-architect.md     # Discovery & architecture
│       ├── requirements-agent.md        # Backlog decomposition
│       ├── coding-agent.md              # Implementation
│       ├── code-review-agent.md         # Quality gate
│       ├── security-review-agent.md     # Security gate
│       ├── cicd-integration-agent.md    # Git operations
│       └── project-summary-agent.md     # README generation
├── docs/
│   ├── backlog/                         # Task files go here
│   ├── reviews/                         # Code review findings go here
│   ├── security-reviews/                # Security review findings go here
│   └── task-log.md                      # State transition log
├── CLAUDE.md                            # Template — fill in per project
├── QUICKSTART.md                        # Detailed setup and usage guide
├── CHANGELOG.md                         # Version history
├── watch-pipeline.sh                    # Tail task-log/reviews in a second terminal
├── .gitignore
└── README.md                            # This file
```

---

*Built by [Brett Hardiman](https://bretthardiman.com). Powered by Claude Code.*
