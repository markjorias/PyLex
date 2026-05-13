# PyLex Technical Documentation

## Overview
PyLex is a specialized lexical analyzer designed for the Python 3.13 grammar. It utilizes a high-performance C-based lexer generated via **Flex** to decompose source code into a structured stream of tokens. The system provides an interactive web interface for real-time visualization and educational analysis of Python's lexical structure.

## System Architecture
- **Lexer Core**: A Flex specification (`lexer.l`) compiled into a standalone C binary.
- **Backend**: A Flask application that manages subprocess execution of the lexer and provides a RESTful API.
- **Frontend**: A responsive web interface leveraging GSAP for visualization and Tailwind CSS for styling.

## Recognized Lexical Elements
The following table outlines the lexical elements recognized by the PyLex engine:

| Category | Description | Technical Details |
| :--- | :--- | :--- |
| **Keywords** | Reserved control flow words | `def`, `if`, `else`, `try`, `async`, `lambda`, etc. |
| **Identifiers** | User-defined labels | `[a-zA-Z_][a-zA-Z0-9_]*` |
| **Integers** | Whole number literals | Supports Hex, Binary, Octal, and Underscores. |
| **Floating Point** | Decimal literals | Standard and Scientific notation (e.g., `3.14e-10`). |
| **Complex** | Imaginary literals | Numeric values suffixed with `j` or `J`. |
| **Strings** | Textual literals | Single, double, and triple-quoted; supports prefixes. |
| **Booleans & None** | Logic constants | Recognition of `True`, `False`, and `None`. |
| **Comments** | Source annotations | Single-line `#` style annotations. |
| **Operators** | Functional symbols | Arithmetic, Assignment, Comparison, and Bitwise. |
| **Indentation** | Structural whitespace | Generates `INDENT` and `DEDENT` tokens. |
| **Punctuation** | Syntax delimiters | Delimiters such as `:`, `( )`, `[ ]`, `{ }`, `->`. |
| **Errors** | Lexical exceptions | Catch-all for invalid characters or malformed tokens. |

## Operational Workflow
1. **Input**: Source code is transmitted to the `/tokenize` endpoint.
2. **Lexing**: The backend pipes code to `bin/lexer` via `stdin`.
3. **Parsing**: The lexer emits JSON-formatted tokens via `stdout`.
4. **Output**: The frontend renders the token stream into a visual decomposition and an analytical table.

---
© 2026 Lexical Lab. Experimental Python Grammar Engine.
