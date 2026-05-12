# --- Stage 1: Build the Lexer ---
FROM alpine:3.18 AS builder

# Install build dependencies
RUN apk add --no-cache flex gcc libc-dev

# Set up working directory
WORKDIR /build

# Copy lexer source
COPY src/lexer/lexer.l .

# Create output directory and compile
RUN mkdir -p bin && \
    flex -o bin/lex.yy.c lexer.l && \
    gcc bin/lex.yy.c -o bin/lexer

# --- Stage 2: Final Runtime ---
FROM python:3.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py
ENV PORT=5000

WORKDIR /app

# Install system runtime dependencies if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Copy the compiled binary from the builder stage
COPY --from=builder /build/bin/lexer ./bin/lexer

# Ensure binary is executable
RUN chmod +x ./bin/lexer

# Expose port
EXPOSE 5000

# Start application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
