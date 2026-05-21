#!/bin/bash
# watch-pipeline.sh — Multi-pane agent pipeline monitor
#
# Opens a tmux session with labeled panes so you can see what each agent
# is doing in real-time. The bottom pane live-tails docs/task-log.md.
#
# Usage:
#   ./watch-pipeline.sh
#
# Layout:
#   ┌──────────────────┬──────────────────┐
#   │  PM / Architect  │   Coding Agent   │
#   ├──────────────────┼──────────────────┤
#   │  Code Review     │  Security Review │
#   ├──────────────────┴──────────────────┤
#   │          CI/CD + Task Log           │
#   └─────────────────────────────────────┘
#
# Start `claude` in the PM pane to kick off the pipeline.
# Agent activity streams in the PM pane; review outputs appear in docs/.
# The bottom pane shows the live task log with PM routing decisions.

SESSION="agent-pipeline"

# Kill existing session if present
tmux kill-session -t "$SESSION" 2>/dev/null

# Create session — first pane is PM / Architect
tmux new-session -d -s "$SESSION" -n "pipeline"

# Split into grid
tmux split-window -h -t "$SESSION"        # right column
tmux split-window -v -t "$SESSION:0.0"    # left bottom
tmux split-window -v -t "$SESSION:0.1"    # right bottom (now index shifts)
# Create bottom strip by splitting the full width
tmux select-pane -t "$SESSION:0.2"
tmux split-window -v -t "$SESSION:0.2" -p 25

# Label panes
tmux select-pane -t "$SESSION:0.0" -T "PM / Architect"
tmux select-pane -t "$SESSION:0.1" -T "Coding Agent"
tmux select-pane -t "$SESSION:0.2" -T "Code Review"
tmux select-pane -t "$SESSION:0.3" -T "Security Review"
tmux select-pane -t "$SESSION:0.4" -T "CI/CD + Task Log"

# Bottom pane: live-tail the task log
tmux send-keys -t "$SESSION:0.4" "echo '⏳ Waiting for docs/task-log.md updates...' && watch -n 2 -d cat docs/task-log.md 2>/dev/null || echo 'docs/task-log.md not found yet — start the pipeline first'" Enter

# Show pane titles in border
tmux set -t "$SESSION" pane-border-format " #{pane_title} "
tmux set -t "$SESSION" pane-border-status top
tmux set -t "$SESSION" pane-border-style "fg=colour240"
tmux set -t "$SESSION" pane-active-border-style "fg=colour39"

# Focus on PM pane
tmux select-pane -t "$SESSION:0.0"

# Attach
tmux attach -t "$SESSION"
