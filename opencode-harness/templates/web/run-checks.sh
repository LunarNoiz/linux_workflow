#!/bin/bash
# run-checks.sh (Web/Node)

echo "Running Web/Node checks..."

if ! command -v npm >/dev/null 2>&1; then
    echo "ERROR: 'npm' is missing! Cannot proceed."
    exit 1
fi

if [ ! -d "node_modules" ]; then
    echo "ERROR: node_modules not found. Agents MUST run npm install before proceeding."
    exit 1
fi

if [ ! -f "package.json" ]; then
    echo "ERROR: package.json not found. Agents MUST initialize the project first."
    exit 1
fi

# Strict Linting Enforcement
if grep -q '"lint"' package.json; then
    echo "Running npm run lint..."
    npm run lint || { echo "ERROR: Linting failed."; exit 1; }
else
    echo "ERROR: 'lint' script missing from package.json! Agents MUST configure a linter (like ESLint) and add a 'lint' script."
    exit 1
fi

# Strict Testing Enforcement
if grep -q '"test"' package.json; then
    if grep -q '"echo \\"Error: no test specified\\""' package.json; then
        echo "ERROR: Default empty test script detected in package.json! Agents MUST set up a real testing framework (Jest, Vitest, etc.)."
        exit 1
    else
        echo "Running npm run test..."
        npm run test || { echo "ERROR: Tests failed."; exit 1; }
    fi
else
    echo "ERROR: 'test' script missing from package.json! Agents MUST configure tests."
    exit 1
fi

echo "All checks passed successfully."
exit 0
