#!/bin/bash
# run-checks.sh (Python)
# This script is the universal entrypoint for the Pillar 2 Supervisor loop.

echo "Running Python checks..."

# Strict Binary Enforcement
if ! command -v ruff >/dev/null 2>&1; then
    echo "ERROR: 'ruff' is missing! Agents MUST install it or instruct the user to install it before proceeding."
    exit 1
fi

if ! command -v pytest >/dev/null 2>&1; then
    echo "ERROR: 'pytest' is missing! Agents MUST install it or instruct the user to install it before proceeding."
    exit 1
fi

echo "Running ruff linter..."
ruff check . || exit 1

echo "Running pytest..."
pytest || exit 1

echo "All checks passed successfully."
exit 0
