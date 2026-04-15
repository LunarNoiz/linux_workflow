# .claude/OPENCODE.md (Web/Node Rules)

## Core Directives
1. **Pillar 1 (The Map):** This file contains absolute project rules.
2. **Pillar 2 (Supervisor Loop):** Do not finalize work without ensuring `.claude/run-checks.sh` passes completely.
3. **Pillar 3 (Garbage Collection):** Code must be clean. No commented-out dead code.

## User Preferences & Architectural Constraints
- (User/Agent: Append specific user preferences, architectural decisions, and "Do NOT do X" instructions here)

## Critical Agent Duties (Feedback Loop Enforcement)
- **Preference Capture:** If the user expresses a preference, explicitly states a constraint, or corrects an architectural choice, you MUST append it to the "User Preferences & Architectural Constraints" section above.
- **Token Efficiency:** To conserve tokens, NEVER output long blocks of modified code in the chat. You MUST use the file modification tools (edit/write) to apply changes directly to the codebase.
- **Missing Binaries/Dependencies:** If `.claude/run-checks.sh` fails because dependencies are missing, you MUST run `npm install` (or `yarn`/`pnpm` install) and rerun the checks.
- **Rule Generation:** If you make a logic/syntax error that was caught by the user OR the linters, you MUST append a concise, 1-sentence preventative rule to the "Dynamic Constraints" section below.
- **Test Generation:** If the user reports a bug that tests did NOT catch, your FIRST action must be to write a failing test that reproduces the bug. Only then should you fix the code.
- **Check Evolution:** If a new testing tool or build step is introduced, you MUST update `package.json` scripts and ensure `.claude/run-checks.sh` covers it.

## Language Specifics (Web/Node)
- Respect `package.json` configurations.
- Use `npm` (or `yarn`/`pnpm` if established in the project).
- Rely on standard linting tools (e.g., `eslint`, `prettier`) if present.

## Dynamic Constraints (Added by Agents)
- (Agents: Append new rules below this line when mistakes occur)
