---
name: reinforcement-learning-devenv
description: Best practices for a Python RL development environment utilizing PyTorch, Pydantic, UV, and strict PEP8 guidelines.
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

## What I do
Enforce strict coding standards, modern Python tooling, and performance best practices for developing Reinforcement Learning projects.

## Development Environment & Standards

### 1. Tooling & Backend
- **Package Manager:** Use `uv` for high-speed dependency resolution and virtual environment management. Default to `uv add`, `uv run`, or `uv pip install` when providing shell commands.
- **Deep Learning Backend:** Strictly use `pytorch` (`torch`). Ensure code is device-agnostic natively (e.g., mapping operations cleanly to `cpu`, `cuda`, or `mps` depending on hardware availability).
- **Configuration Management:** Use `pydantic` models for typing and validating RL hyperparameters, environment configurations, and state definitions. Avoid plain dictionaries for complex configurations.

### 2. Code Quality & Formatting
- **PEP8 Compliance:** Adhere strictly to PEP8 standards. Assume the use of modern, fast formatters/linters like `ruff`.
- **Type Hinting:** Use strict Python type hints (`typing` module) for all function signatures, class attributes, and data structures.
- **Documentation:** Write clear docstrings for all classes and functions. **Crucially**, document the expected shapes of all PyTorch Tensors in docstrings and inline comments (e.g., `Tensor shape: (batch_size, state_dim)`).

### 3. Performance & Optimization
- **Tensor Operations:** Vectorize mathematical operations using PyTorch natively. Avoid native Python `for` loops inside the training loop or when manipulating tensor batches.
- **Memory Management:** Ensure gradients are zeroed efficiently (use `optimizer.zero_grad(set_to_none=True)`). Always use `with torch.no_grad():` during environment rollout, evaluation, or action-selection phases to save memory.
- **Compilation:** Consider making the models compatible with `torch.compile` to leverage PyTorch 2.0+ graph optimization capabilities where applicable.

## When to use me
Use this skill when writing boilerplate Python code, refactoring models, setting up new repositories, or optimizing the performance of Python training loops.
