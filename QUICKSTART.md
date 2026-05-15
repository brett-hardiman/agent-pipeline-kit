# Agent Pipeline Kit — Quick Start

A portable 8-agent Claude Code pipeline for any software project. Drop this kit into a new repo, fill in `CLAUDE.md`, and point the IT Solution Architect at what you want to build.

---

## What's In the Kit

```
agent-pipeline-kit/
├── .claude/
│   └── agents/
│       ├── project-manager.md         # Orchestrator — coordinates all agents
│       ├── it-solution-architect.md   # Discovery & architecture planning
│       ├── requirements-agent.md      # Backlog decomposition & task files
│       ├── coding-agent.md            # Implementation
│       ├── code-review-agent.md       # AC verification & standards compliance
│       ├── security-review-agent.md   # Security audit & deployment readiness
│       ├── cicd-integration-agent.md  # Git branching, commits, PRs
│       └── project-summary-agent.md  # README generation
├── docs/
│   ├── backlog/                       # Requirements Agent outputs here
│   ├── reviews/                       # Code Review Agent outputs here
│   ├── security-reviews/              # Security Review Agent outputs here
│   └── task-log.md                    # Project Manager tracks state here
├── CLAUDE.md                          # ← Fill this in before starting
├── .gitignore
└── QUICKSTART.md                      # This file
```

---

## Prerequisites

**1. Claude Code installed**
```bash
npm install -g @anthropic-ai/claude-code
```

**2. Agent Teams enabled**

Add to your shell profile or run before each session:
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

Or add to your Claude Code `settings.json`:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**3. Model access**

The Project Manager and IT Solution Architect use Opus. Make sure your Anthropic plan supports it. Max plan is recommended for agent team workloads.

---

## Setup (New Project)

**1. Create your project directory**
```bash
mkdir my-project && cd my-project
git init
```

**2. Copy this kit into it**
```bash
cp -r /path/to/agent-pipeline-kit/. .
```

**3. Fill in `CLAUDE.md`**

Open `CLAUDE.md` and complete every section:
- Project overview and type
- Tech stack
- Code conventions (naming, error handling, etc.)
- Anything that is explicitly out of scope for v1

The more specific you are, the less the agents guess. Guessing produces rework.

**4. Launch Claude Code**
```bash
claude
```

---

## Running the Pipeline

### Step 1 — Kick off the IT Solution Architect

```
Use the it-solution-architect agent. Here's what I want to build:

[Describe your project in plain English. Include: what it does, who uses it,
any hard constraints on tech stack or deployment, and what success looks like.]
```

The Architect will ask you questions. Answer them. Push back if it suggests something wrong — it will push back on you too if your ideas have problems. This conversation is the most valuable part of the process.

### Step 2 — Automatic handoff

Once the Architect saves `docs/project-plan.md`, it reports to the Project Manager, who spawns the Requirements Agent. You do not need to do anything.

### Step 3 — Backlog review checkpoint

The Project Manager pauses and asks you to review the backlog before coding begins. Open `docs/backlog/index.md` and check:
- Are all the right tasks there?
- Are any tasks missing?
- Does the dependency order make sense?

This is your highest-leverage moment. Catching scope issues here costs minutes. Catching them in code review costs hours.

Approve when ready: `"Backlog looks good, proceed with coding."`

### Step 4 — Watch it build

The Project Manager assigns tasks to the Coding Agent. Each completed task flows through:

```
Coding Agent → Code Review → Security Review → CI/CD Integration → DONE
```

You get milestone updates at the end of each phase. You do not need to manage individual tasks.

### Step 5 — README generation

After all phases complete, ask the Project Manager to run the Project Summary Agent:

```
"All phases are done. Please run the project-summary-agent to generate the README."
```

---

## Running on an Existing Project

The kit works on projects already in progress:

1. Copy `.claude/agents/` into your existing repo
2. Fill in or update `CLAUDE.md` with your actual conventions
3. Create the `docs/` scaffold if it does not exist
4. You can run individual agents without the full pipeline — for example:
   - Run just the Code Review Agent against a specific file
   - Run just the Security Review Agent before a release
   - Run just the Project Summary Agent to regenerate the README

---

## Example: Requirements Generator API

To run this kit against the `requirements-api` project:

1. Copy `.claude/agents/` into the `requirements-api/` directory
2. The `CLAUDE.md` there is already filled in — review it and adjust if needed
3. Launch Claude Code from the `requirements-api/` directory
4. Kick off the Architect:

```
Use the it-solution-architect agent. I want to build a FastAPI backend
that accepts a plain-text project description and returns structured user
stories with acceptance criteria. It uses the Anthropic Claude API.
The CLAUDE.md in this project already defines the conventions — please
read it and use it as your architectural starting point.
```

---

## Tips

- **Monitor token usage** — run `/usage` in Claude Code periodically. Agent teams consume tokens across all active agents.
- **Start with a tight scope** — tell the Architect to limit to 2-3 phases for your first run. You can always add phases.
- **The backlog checkpoint is real** — do not just say "looks good" without reading it. The Coding Agent implements exactly what the task files say.
- **Check `docs/task-log.md`** — the Project Manager logs every state transition. If something goes wrong, start here.
- **CLAUDE.md is the brain** — every agent reads it. The more complete it is, the less agents deviate from your intentions.

---

## Troubleshooting

**Agents not appearing?**
- Verify files are in `.claude/agents/` — the path is exact, including the leading dot
- Check YAML frontmatter for tab characters — use spaces only

**Agent Teams not working?**
- Confirm `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set in your environment
- Opus model access is required for PM and Architect agents

**Token budget running low?**
- Switch the Coding Agent to Haiku for simple or repetitive tasks by temporarily changing the `model:` field
- Reduce backlog scope — tell the Architect to cut the lowest-priority phase
- Use `/compact` in Claude Code to compress conversation history

**Agent making wrong decisions?**
- Almost always a `CLAUDE.md` problem — add more specificity to the relevant section
- Check that `CLAUDE.md` is in the project root, not a subdirectory
