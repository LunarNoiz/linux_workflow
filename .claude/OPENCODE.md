# .claude/OPENCODE.md (Generic Rules)

## Core Directives
1. **Pillar 1 (The Map):** This file contains absolute project rules.
2. **Pillar 2 (Supervisor Loop):** Do not finalize work without ensuring `.claude/run-checks.sh` passes completely.
3. **Pillar 3 (Garbage Collection):** Code must be clean. No commented-out dead code.

## User Preferences & Architectural Constraints
- (User/Agent: Append specific user preferences, architectural decisions, and "Do NOT do X" instructions here)

## Critical Agent Duties (Feedback Loop Enforcement)
- **Preference Capture:** If the user expresses a preference, explicitly states a constraint, or corrects an architectural choice, you MUST append it to the "User Preferences & Architectural Constraints" section above.
- **Token Efficiency:** To conserve tokens, NEVER output long blocks of modified code in the chat. You MUST use the file modification tools (edit/write) to apply changes directly to the codebase.
- **Rule Generation:** If you make a logic/syntax error that was caught by the user OR the linters, you MUST append a concise, 1-sentence preventative rule to the "Dynamic Constraints" section below.
- **Check Evolution:** If a new testing tool or build step is introduced, you MUST update `.claude/run-checks.sh` to include it.

## Dynamic Constraints (Added by Agents)
- When developing Neovim plugins or custom lua modules, always ensure the chosen namespace (folder name inside `lua/`) does not collide with existing or popular plugins (e.g., use `oc_harness` instead of `opencode`).
- (Agents: Append new rules below this line when mistakes occur)
