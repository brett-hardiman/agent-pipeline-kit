# Changelog

All notable changes to the Agent Pipeline Kit are documented here.

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
