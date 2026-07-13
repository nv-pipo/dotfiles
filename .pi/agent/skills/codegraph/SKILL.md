---
name: codegraph
description: Query the repository dependency graph, symbol relationships, and code paths instead of recursively using grep.
triggers: ["code structure", "who calls", "dependency", "find symbol", "where is", "codegraph"]
---

# CodeGraph Skill

Use this skill when the user asks structural, architectural, or relational questions about the codebase (e.g., call chains, impact analysis, finding declarations). 

## Usage Instructions
Instead of running brute-force `grep` or reading multiple files to map dependencies, run CodeGraph CLI queries directly via the `bash` tool.

## Available Commands

### 1. Architectural Exploration
To understand code flow or how components interact:
```bash
codegraph explore "How does authentication flow to the request handler?"
```

### 2. Trace Symbol Callers & Callees
To find what triggers a function or what a function executes:
```bash
codegraph callers <symbol_name>
codegraph callees <symbol_name>
```

### 3. Change Impact Analysis (Blast Radius)
To see what would break if you modify a specific class or interface:
```bash
codegraph impact <symbol_name>
```

### 4. Locate Declarations
To find definitions, symbols, and files without reading entire modules:
```bash
codegraph search <symbol_name>
```

## Rules
- NEVER default to recursive file reads (`cat`, `less`) or text searches (`grep`, `find`) for tracking code dependencies.
- Use this skill's CLI commands to instantly get precise context in one single turn.

