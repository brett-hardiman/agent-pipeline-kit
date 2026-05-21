# Agent Pipeline Kit — Quick Start

A portable 8-agent Claude Code pipeline for any software project. Drop this kit into a new repo, fill in `CLAUDE.md`, and point the IT Solution Architect at what you want to build. The Project Manager runs autonomously — no handoff approvals needed.

---

## What's In the Kit

```
agent-pipeline-kit/
├── .claude/
│   └── agents/
│       ├── project-manager.md         # Autonomous orchestrator
│       ├── it-solution-architect.md   # Discovery & architecture planning
│       ├── requirements-agent.md      # Backlog decomposition & task files
│       ├── coding-agent.md            # Implementation
│       ├── code-review-agent.md       # Quality gate
│       ├── security-review-agent.md   # Security gate
│       ├── cicd-integration-agent.md  # Git operations
│       └── project-summary-agent.md   # README generation
├── docs/
│   ├── backlog/                       # Requirements Agent outputs here
│   ├── reviews/                       # Code Review Agent outputs here
│   ├── security-reviews/              # Security Review Agent outputs here
│   └── task-log.md                    # PM tracks state + routing decisions
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

### Step 2 — The PM takes over

Once the Architect saves `docs/project-plan.md`, it reports to the Project Manager. The PM spawns the Requirements Agent, receives the backlog, and **immediately begins delegating tasks to agents**. No approval checkpoint — the PM runs the pipeline autonomously.

The PM makes all routing decisions:
- Completed task → routes through Code Review → Security Review → CI/CD
- Rejected task → sends back to Coding Agent with findings, or marks `BLOCKED` and moves on
- All dependencies cleared → assigns next task immediately
- All tasks done → runs Project Summary Agent

### Step 3 — Watch it build

Open `docs/task-log.md` to see every state transition and routing decision the PM makes. You get notified at phase completions and pipeline end, but the PM does not pause for your approval.

**To see each agent working in real-time, use the multi-terminal layout** described below.

### Step 4 — README generation

Happens automatically. When all tasks reach `DONE`, the PM spawns the Project Summary Agent to generate the final README. No manual trigger needed.

---

## Watching the Agents Work (Multi-Terminal Layout)

The pipeline is designed so you can see what every agent is doing in real-time. Each agent runs in its own Claude Code session visible in a separate terminal pane.

### Option A — tmux (recommended)

tmux lets you split one terminal into multiple panes, each showing a different agent's activity.

**Setup script — save as `watch-pipeline.sh` in your project root:**

```bash
#!/bin/bash
# watch-pipeline.sh — Multi-pane agent pipeline monitor
# Usage: ./watch-pipeline.sh

SESSION="agent-pipeline"

# Kill existing session if it exists
tmux kill-session -t $SESSION 2>/dev/null

# Create session with the PM in the first pane
tmux new-session -d -s $SESSION -n "pipeline"

# Split into a 2x2 grid + bottom strip
# Layout:
#   ┌──────────────┬──────────────┐
#   │  PM / Arch   │   Coding     │
#   ├──────────────┼──────────────┤
#   │  Code Review │  Sec Review  │
#   ├──────────────┴──────────────┤
#   │        CI/CD + Logs         │
#   └─────────────────────────────┘

tmux split-window -h -t $SESSION
tmux split-window -v -t $SESSION:0.0
tmux split-window -v -t $SESSION:0.1
tmux split-window -v -t $SESSION

# Label each pane (shows in status bar)
tmux select-pane -t $SESSION:0.0 -T "PM / Architect"
tmux select-pane -t $SESSION:0.1 -T "Code Review"
tmux select-pane -t $SESSION:0.2 -T "Coding Agent"
tmux select-pane -t $SESSION:0.3 -T "Security Review"
tmux select-pane -t $SESSION:0.4 -T "CI/CD + Logs"

# Set bottom pane to tail the task log
tmux send-keys -t $SESSION:0.4 "watch -n 2 cat docs/task-log.md" Enter

# Set status bar to show pane titles
tmux set -t $SESSION pane-border-format " #{pane_title} "
tmux set -t $SESSION pane-border-status top

# Attach
tmux attach -t $SESSION
```

```bash
chmod +x watch-pipeline.sh
./watch-pipeline.sh
```

Then launch `claude` in the PM pane and kick off the Architect. As the PM delegates to agents, their activity appears in the Claude Code output of each respective session.

### Option B — iTerm2 Split Panes (macOS)

If you use iTerm2:
1. Open iTerm2
2. `Cmd+D` to split vertically, `Cmd+Shift+D` to split horizontally
3. Arrange into a grid — one pane per agent role
4. Run `claude` in the PM pane to start the pipeline
5. In the bottom pane, run `watch -n 2 cat docs/task-log.md` to live-tail the log

### Option C — VS Code Terminals

1. Open the integrated terminal
2. Click the split terminal icon (or `Ctrl+Shift+5`) to create multiple panes
3. Rename each pane (right-click → "Rename") to the agent role
4. Run `claude` in the PM pane
5. Dedicate one pane to `watch -n 2 cat docs/task-log.md`

### What You'll See

Each agent logs its activity to stdout as it works. The PM logs routing decisions to `docs/task-log.md`. Between the terminal panes and the live-tailing log, you get full visibility into:

- Which agent is working on which task right now
- What the PM decided to do with a completed/rejected task
- Which tasks are running in parallel
- Where the pipeline is in the overall backlog

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

The PM will take it from there — no further approvals needed until the pipeline completes.

---

## Tips

- **Monitor token usage** — run `/usage` in Claude Code periodically. Agent teams consume tokens across all active agents.
- **Start with a tight scope** — tell the Architect to limit to 2-3 phases for your first run. You can always add phases.
- **CLAUDE.md is the brain** — every agent reads it. The more complete it is, the less agents deviate from your intentions.
- **Check `docs/task-log.md`** — the PM logs every routing decision. If something goes wrong, start here.
- **The PM will mark tasks `BLOCKED` after 3 failed reviews** — check blocked tasks and either refine the acceptance criteria or adjust the project plan.
- **Use the multi-terminal layout** — it is the fastest way to understand what is happening across the pipeline.

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

**Task stuck in a loop?**
- The PM marks tasks `BLOCKED` after 3 review failures — check the finding documents in `docs/reviews/` or `docs/security-reviews/` to understand why
- Refine the acceptance criteria in the task file, then change the status back to `PENDING` to let the PM pick it up again

**tmux panes not showing agents?**
- Each agent runs within the PM's Claude Code session as sub-agents — their output streams in the PM pane by default
- To see individual agent detail, use `docs/task-log.md` live-tail plus the review/security-review output files
- For maximum visibility, run the pipeline with `--verbose` if supported by your Claude Code version
