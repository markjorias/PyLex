# PyLex: Python Lexical Analyzer

PyLex is a high-performance lexical analyzer for Python, powered by Flex and Flask. It provides a real-time, interactive environment to visualize and dissect Python syntax into its foundational tokens.

![Version](https://img.shields.io/badge/version-2.1.0-ff00ff)
![Tech](https://img.shields.io/badge/tech-Flex%20%7C%20Flask%20%7C%20GSAP-00ffff)
![Deployment](https://img.shields.io/badge/deploy-Vercel%20%7C%20Docker-white)

**🌐 Live Demo:** [https://pylex-flex.vercel.app](https://pylex-flex.vercel.app)  
**📺 Video Demo:** [Watch on YouTube](https://youtu.be/sA_NWbcas8I)

---

## Quick Start

### 1. Prerequisites
Ensure you have Flex and GCC installed to compile the lexer engine:
```bash
sudo apt-get install flex gcc
```

### 2. Run Locally
```bash
# Setup environment
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt

# Compile & Run
mkdir -p bin
flex -o bin/lex.yy.c src/lexer/lexer.l
gcc bin/lex.yy.c -o bin/lexer -lfl
python app.py
```

---

## Features
- **Real-time Tokenization**: Instant feedback as you type in the Lexical Lab.
- **Interactive Visualization**: Hover over tokens to see their specific classification.
- **Python 3.13 Support**: Handles keywords, complex literals, strings, and indentation.
- **Lexer Academy**: Built-in technical reference for lexical grammar patterns.

---

## Detailed Documentation
For architectural diagrams, full token specifications, implementation details, and sample test cases, please refer to the main documentation:

👉 **[DOCUMENTATION.md](docs/DOCUMENTATION.md)**

---
Copyright 2026 Lexical Lab. Experimental Python Grammar Engine.
