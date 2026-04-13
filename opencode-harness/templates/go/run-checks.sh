#!/bin/bash
# run-checks.sh (Go)

echo "Running Go checks..."

# Strict Binary Enforcement
if ! command -v go >/dev/null 2>&1; then
    echo "ERROR: 'go' is missing! Ensure Go is installed and in PATH."
    exit 1
fi

if ! command -v staticcheck >/dev/null 2>&1; then
    echo "ERROR: 'staticcheck' is missing! Agents MUST run 'go install honnef.co/go/tools/cmd/staticcheck@latest' before proceeding."
    exit 1
fi

echo "Running go fmt..."
if [ -n "$(go fmt ./...)" ]; then
    echo "ERROR: Files need formatting. Please run go fmt."
    exit 1
fi

echo "Running go vet..."
go vet ./... || exit 1

echo "Running staticcheck..."
staticcheck ./... || exit 1

echo "Running go test..."
go test ./... || exit 1

echo "All checks passed successfully."
exit 0
