# Project Conventions

> This file is read by every agent in the pipeline before taking any action.
> Fill in every section before running the IT Solution Architect.
> The more specific you are here, the less the agents have to guess.

---

## Project Overview

**Name:** [Project name]
**Description:** [One sentence — what this project does]
**Type:** [API / Web App / CLI tool / Data pipeline / Agent system / Other]
**Deployment Target:** [Local only / GitHub Pages / Railway / Render / AWS / Other]

---

## Tech Stack

| Technology | Role |
|------------|------|
| [Language] | [e.g. Primary language] |
| [Framework] | [e.g. Web framework] |
| [Other tools] | [Role] |

---

## File Structure

```
[project-name]/
├── [describe your intended structure here]
└── [or leave blank and let the Architect define it]
```

---

## Code Conventions

- **Language version:** [e.g. Python 3.11+, Node 20+]
- **Variable naming:** [e.g. snake_case for Python, camelCase for JS]
- **File naming:** [e.g. kebab-case, snake_case]
- **Function naming:** [e.g. snake_case, camelCase]
- **Class/model naming:** [e.g. PascalCase]
- **Error handling:** [e.g. Always use HTTPException with descriptive detail messages]
- **Logging:** [e.g. print() for now / use logging module / no logging in v1]

---

## Environment Variables

- All secrets and API keys MUST use environment variables
- Document all required env vars in `.env.example` with placeholder values
- NEVER hardcode `localhost`, API keys, passwords, or environment-specific URLs
- `.env` is always excluded from git via `.gitignore`

---

## Git Conventions

- **Branch naming:** `feature/[TASK-ID]-[short-description]`
- **Commit format:** `feat([scope]): [description] — [TASK-ID]`
- **No direct pushes to main** — all changes via pull requests

---

## Review Standards

- All tasks must pass Code Review (acceptance criteria + convention compliance)
- All tasks must pass Security Review (no secrets, no hardcoded env values)
- Review findings are documented in `docs/reviews/` and `docs/security-reviews/`

---

## Out of Scope (v1)

> List things that are explicitly NOT being built in this iteration.
> This prevents scope creep and keeps agents focused.

- [e.g. No authentication in v1]
- [e.g. No database — in-memory or flat file only]
- [e.g. No deployment — local development only]
