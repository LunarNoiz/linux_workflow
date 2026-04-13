#!/bin/bash
# run-checks.sh (C/C++)

echo "Running C/C++ checks..."

# Strict Binary Enforcement
if ! command -v make >/dev/null 2>&1 && ! command -v cmake >/dev/null 2>&1; then
    echo "ERROR: Neither 'make' nor 'cmake' found. Agents MUST establish a build system."
    exit 1
fi

if ! command -v clang-tidy >/dev/null 2>&1; then
    echo "ERROR: 'clang-tidy' is missing! Code MUST be linted. Agents MUST install or instruct user to install."
    exit 1
fi

if [ -f "Makefile" ]; then
    echo "Running make test..."
    make test || { echo "ERROR: make test failed! Make sure there is a 'test' target in the Makefile."; exit 1; }
elif [ -f "CMakeLists.txt" ]; then
    echo "CMake project detected. Checking build and running CTest..."
    mkdir -p build && cd build && cmake .. && make && ctest --output-on-failure || { echo "ERROR: CMake build or tests failed."; exit 1; }
    cd ..
else
    echo "ERROR: No Makefile or CMakeLists.txt found. Agents MUST set up a build system."
    exit 1
fi

echo "Running clang-tidy..."
# We run clang-tidy on all .c, .cpp, .h, and .hpp files
find . -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.hpp" | xargs clang-tidy --quiet || { echo "ERROR: clang-tidy found linting issues."; exit 1; }

echo "All checks passed successfully."
exit 0
