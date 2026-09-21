#!/usr/bin/env bash
# Create and set up a Python virtual environment
# Usage: setup_venv.sh [directory] [python_version]
set -euo pipefail

PROJECT_DIR="${1:-.}"
PYTHON="${2:-python3}"
VENV_NAME="${VENV_NAME:-venv}"

# Validate
if ! command -v "$PYTHON" &>/dev/null; then
    echo "ERROR: Python not found: $PYTHON"
    exit 1
fi

PYTHON_VERSION=$("$PYTHON" --version 2>&1)
echo "=== Python Virtual Environment Setup ==="
echo "Project:  $PROJECT_DIR"
echo "Python:   $PYTHON_VERSION"
echo ""

# Create project dir if needed
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "Creating project directory: $PROJECT_DIR"
    mkdir -p "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

# Create venv if it doesn't exist
if [[ ! -d "$VENV_NAME" ]]; then
    echo "Creating virtual environment in $VENV_NAME/..."
    "$PYTHON" -m venv "$VENV_NAME"
    echo "Created."
else
    echo "Virtual environment already exists: $VENV_NAME/"
fi
echo ""

# Activate
source "$VENV_NAME/bin/activate"
echo "Activated: $(python3 --version)"
echo "Path: $(which python3)"
echo ""

# Upgrade pip
echo "Upgrading pip..."
python3 -m pip install --upgrade pip --quiet 2>/dev/null && echo "Pip upgraded." || echo "Warning: pip upgrade failed."
echo ""

# Check for requirements
if [[ -f "requirements.txt" ]]; then
    echo "Found requirements.txt, installing dependencies..."
    pip install -r requirements.txt 2>&1 | tail -5
    echo "Dependencies installed."
else
    echo "No requirements.txt found."
    echo "  Create one with: pip freeze > requirements.txt"
fi
echo ""

# Summary
echo "=== Setup Complete ==="
echo ""
echo "Activate:   source $VENV_NAME/bin/activate"
echo "Deactivate: deactivate"
echo "Freeze:     pip freeze > requirements.txt"
echo ""

# Show installed packages
PKG_COUNT=$(pip list 2>/dev/null | tail -n +3 | wc -l)
echo "Installed packages: $PKG_COUNT"
