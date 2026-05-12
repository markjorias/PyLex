from flask import Flask, render_template, request, jsonify
import subprocess
import json
import os
import stat

app = Flask(__name__)
# Absolute path to the lexer binary
LEXER_PATH = os.path.join(os.path.dirname(__file__), 'bin', 'lexer')
# Absolute path to the generated C source
LEXER_SOURCE = os.path.join(os.path.dirname(__file__), 'bin', 'lex.yy.c')

def compile_lexer_if_needed():
    """Attempts to compile the lexer if binary is missing or not executable."""
    if not os.path.exists(LEXER_PATH) or not os.access(LEXER_PATH, os.X_OK):
        print(f"Lexer binary missing or not executable at {LEXER_PATH}. Attempting runtime compilation...")
        if os.path.exists(LEXER_SOURCE):
            try:
                # Use gcc to compile the pre-generated C source
                subprocess.run(['gcc', LEXER_SOURCE, '-o', LEXER_PATH], check=True, capture_output=True)
                # Ensure it's executable
                st = os.stat(LEXER_PATH)
                os.chmod(LEXER_PATH, st.st_mode | stat.S_IEXEC)
                return True, "Compiled successfully"
            except Exception as e:
                return False, f"Compilation failed: {str(e)}"
        return False, "Source C file not found"
    return True, "Binary ready"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/academy')
def academy():
    return render_template('academy.html')

@app.route('/lab')
def lab():
    return render_template('lab.html')

@app.route('/tokenize', methods=['POST'])
def tokenize():
    code = request.form.get('code', '')
    if not code:
        return jsonify([])

    success, msg = compile_lexer_if_needed()
    if not success:
        return jsonify({'error': 'Lexer engine unavailable', 'details': msg}), 500

    try:
        # Run the compiled lexer as a subprocess
        process = subprocess.Popen([LEXER_PATH], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate(input=code)

        if process.returncode != 0:
            return jsonify({'error': 'Lexer execution failed', 'details': stderr}), 500

        # Parse the JSON-per-line output from the lexer
        tokens = []
        for line in stdout.strip().split('\n'):
            if line:
                try:
                    tokens.append(json.loads(line))
                except json.JSONDecodeError:
                    continue
        
        return jsonify(tokens)

    except Exception as e:
        return jsonify({'error': 'Internal server error', 'details': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
