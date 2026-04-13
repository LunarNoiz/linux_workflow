# OPENCODE.md (C/C++ Rules)

## Core Directives
1. **Pillar 1 (The Map):** This file contains absolute project rules.
2. **Pillar 2 (Supervisor Loop):** Do not finalize work without ensuring `./run-checks.sh` passes completely.
3. **Pillar 3 (Garbage Collection):** Code must be clean. No commented-out dead code.

## Critical Agent Duties (Feedback Loop Enforcement)
- **Missing Build Tools:** If `./run-checks.sh` fails because `make`, `cmake`, or compilers are missing, you must instruct the user to install them.
- **Rule Generation:** If you make a logic/memory error that was caught by the user OR the linters/tests, you MUST append a concise, 1-sentence preventative rule to the "Dynamic Constraints" section below.
- **Test Generation:** If the user reports a bug that tests did NOT catch, your FIRST action must be to write a failing test that reproduces the bug. Only then should you fix the code.
- **Check Evolution:** If a new testing tool or build step is introduced, you MUST update `./run-checks.sh` to include it.

## Language Specifics (C/C++)
- Ensure memory management is strict (avoid leaks).
- Adhere to the established build system (`CMake` or `Make`).
- Check for compiler warnings; treat them as errors if possible.

## Dynamic Constraints (Added by Agents)
- (Agents: Append new rules below this line when mistakes occur)
