from flask import Flask, render_template, request, jsonify
import subprocess
import json

import os

app = Flask(__name__)
LEXER_PATH = os.path.join(os.path.dirname(__file__), 'bin', 'lexer')

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

    if not os.path.exists(LEXER_PATH):
        return jsonify({'error': 'Lexer binary not found', 'path': LEXER_PATH}), 500

    try:
        # Run the compiled lexer as a subprocess
        process = subprocess.Popen([LEXER_PATH], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate(input=code)

        if process.returncode != 0:
            return jsonify({'error': 'Lexer error', 'details': stderr}), 500

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
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
