# PyLex: Precision Python Lexical Analysis

PyLex is a high-performance lexical analyzer for Python, powered by Flex and Flask. It provides a real-time, interactive environment to visualize and dissect Python syntax into its foundational tokens.

![Version](https://img.shields.io/badge/version-2.0.0-ff00ff)
![Tech](https://img.shields.io/badge/tech-Flex%20%7C%20Flask%20%7C%20GSAP-00ffff)
![Deployment](https://img.shields.io/badge/deploy-Vercel%20%7C%20Docker-white)

## Features

- **Industrial Recognition**: Utilizes a compiled Flex engine for sub-millisecond pattern matching and precise token identification.
- **Lexical Lab**: An interactive environment for real-time token decomposition and visual reconstruction.
- **Academy**: A technical reference dictionary detailing Python's lexical grammar and regular expression patterns.

## Technical Stack

- **Lexical Engine**: Flex (Lexer Generator) and GCC (C Compiler)
- **Backend**: Python 3.13 and Flask
- **Frontend**: Tailwind CSS and GSAP (GreenSock Animation Platform)
- **Infrastructure**: Docker (Multi-stage builds) and GitHub Actions (CI/CD)

## Installation and Setup

### 1. Prerequisites
Ensure Flex and GCC are installed on the host system:
```bash
sudo apt-get install flex gcc # Ubuntu/Debian
```

### 2. Environment Configuration
```bash
# Clone the repository
git clone <your-repo-url>
cd flex_fproject

# Initialize virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Compilation and Execution
```bash
# Compile the Flex specification
mkdir -p bin
flex -o bin/lex.yy.c src/lexer/lexer.l
gcc bin/lex.yy.c -o bin/lexer -lfl

# Start the application
python app.py
```
The application will be available at `http://127.0.0.1:5000`.

## Deployment

### Docker
The project includes a multi-stage Dockerfile optimized for production runtime environments:
```bash
docker build -t pylex .
docker run -p 5000:5000 pylex
```

### Vercel
The repository is pre-configured for Vercel Serverless Functions. Deploy using the Vercel CLI or by connecting the repository to the Vercel dashboard:
```bash
vercel deploy
```

## Quality Assurance
Execute the integration test suite to verify lexer accuracy and system stability:
```bash
python -m unittest discover tests
```

## Documentation
For a detailed history of updates and architectural changes, please refer to the [CHANGELOG.md](CHANGELOG.md).

---
Copyright 2026 Lexical Lab. Experimental Python Grammar Engine.
