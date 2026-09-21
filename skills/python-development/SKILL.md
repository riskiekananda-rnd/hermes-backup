---
name: python-development
version: 1.0.0
description: "Python dev: virtualenv, testing, packaging."
tags: [python, development, testing, packaging]
platforms: [linux, macos, windows]
author: Hermes Agent
license: MIT
---

# Python Development

Python development best practices: virtualenv, testing, packaging.

## When to Use
- Starting new Python projects
- Setting up virtual environments
- Writing tests
- Packaging Python applications

## Quick Reference
```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
pip install -e .  # editable install

# Run tests
pytest
pytest -v  # verbose
pytest -x  # stop on first failure
```

## Project Structure
```
my_project/
├── src/
│   └── my_project/
│       ├── __init__.py
│       └── main.py
├── tests/
│   ├── __init__.py
│   └── test_main.py
├── requirements.txt
├── setup.py
├── pyproject.toml
└── README.md
```

## Requirements
```bash
# Generate requirements
pip freeze > requirements.txt

# Install from requirements
pip install -r requirements.txt

# Use pip-tools for pinned deps
pip install pip-tools
pip-compile requirements.in
pip-sync
```

## Testing with pytest
```python
# test_main.py
def test_addition():
    assert 1 + 1 == 2

def test_string():
    assert "hello".upper() == "HELLO"
```

## Code Quality
```bash
# Linting
flake8 src/
pylint src/

# Formatting
black src/
isort src/

# Type checking
mypy src/
```

## Packaging
```python
# setup.py
from setuptools import setup, find_packages

setup(
    name="my_project",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "requests>=2.28.0",
    ],
)
```

## Common Patterns
1. Use virtual environments for isolation
2. Pin dependencies in requirements.txt
3. Write tests before code (TDD)
4. Use type hints for clarity
5. Document with docstrings

## Pitfalls
- Don't install packages globally
- Don't commit venv/ directory
- Use .gitignore for __pycache__
- Don't use mutable default arguments

## Verification
```bash
python -m pytest --tb=short
python -m mypy src/
```