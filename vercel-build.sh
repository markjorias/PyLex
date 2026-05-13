#!/bin/bash
# Vercel Build Script
# This compiles the C lexer using the pre-generated lex.yy.c

echo "Building Lexer Engine..."
mkdir -p bin
gcc -static bin/lex.yy.c -o bin/lexer
chmod +x bin/lexer
echo "Build Complete."
