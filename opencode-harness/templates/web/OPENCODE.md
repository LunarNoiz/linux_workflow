# OPENCODE.md (Web/Node Rules)

## Core Directives
1. **Pillar 1 (The Map):** This file contains absolute project rules.
2. **Pillar 2 (Supervisor Loop):** Do not finalize work without ensuring `./run-checks.sh` passes completely.
3. **Pillar 3 (Garbage Collection):** Code must be clean. No commented-out dead code.

## Critical Agent Duties (Feedback Loop Enforcement)
- **Missing Binaries/Dependencies:** If `./run-checks.sh` fails because dependencies are missing, you MUST run `npm install` (or `yarn`/`pnpm` install) and rerun the checks.
- **Rule Generation:** If you make a logic/syntax error that was caught by the user OR the linters, you MUST append a concise, 1-sentence preventative rule to the "Dynamic Constraints" section below.
- **Test Generation:** If the user reports a bug that tests did NOT catch, your FIRST action must be to write a failing test that reproduces the bug. Only then should you fix the code.
- **Check Evolution:** If a new testing tool or build step is introduced, you MUST update `package.json` scripts and ensure `./run-checks.sh` covers it.

## Language Specifics (Web/Node)
- Respect `package.json` configurations.
- Use `npm` (or `yarn`/`pnpm` if established in the project).
- Rely on standard linting tools (e.g., `eslint`, `prettier`) if present.

## Dynamic Constraints (Added by Agents)
- (Agents: Append new rules below this line when mistakes occur)
