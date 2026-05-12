import unittest
import json
from app import app

class LexerIntegrationTest(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def tokenize(self, code):
        return self.app.post('/tokenize', data={'code': code})

    def test_basic_function(self):
        code = "def hello_world():\n    print('Hello')"
        response = self.tokenize(code)
        data = json.loads(response.data)
        
        types = [t['type'] for t in data]
        self.assertIn('KEYWORD', types) # def
        self.assertIn('IDENTIFIER', types) # hello_world
        self.assertIn('STRING', types) # 'Hello'

    def test_complex_math(self):
        code = "result = (a + b) * 2.5 ** 3 // 4"
        response = self.tokenize(code)
        data = json.loads(response.data)
        
        values = [t['value'] for t in data]
        self.assertIn('**', values)
        self.assertIn('//', values)
        self.assertIn('2.5', values)

    def test_errors(self):
        # Python doesn't use '$' or '?' as operators/identifiers
        code = "x = 10 $ 5"
        response = self.tokenize(code)
        data = json.loads(response.data)
        
        types = [t['type'] for t in data]
        self.assertIn('ERROR', types)

    def test_large_code_block(self):
        code = """
import math

class Shape:
    def __init__(self, name):
        self.name = name

def calculate_area(radius):
    # This is a comment
    if radius < 0:
        return None
    return math.pi * (radius ** 2)

for i in range(10):
    print(f"Area {i}: {calculate_area(i)}")
"""
        response = self.tokenize(code)
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertTrue(len(data) > 20)

    def test_edge_cases(self):
        # Testing scientific notation and triple quotes
        code = 'val = 1.2e-10\ntext = """multi-line\nstring"""'
        response = self.tokenize(code)
        data = json.loads(response.data)
        
        values = [t['value'] for t in data]
        print("\nAll Tokens:", values)
        
        self.assertIn('1.2e-10', values)
        self.assertTrue(any('multi-line' in v for v in values), "Triple quoted string missing or fragmented")

    def test_advanced_literals(self):
        code = "hex = 0x123_ABC\nbin = 0b1010\ncomplex = 1.2j\nellipsis = ..."
        response = self.tokenize(code)
        data = json.loads(response.data)
        
        values = [t['value'] for t in data]
        types = [t['type'] for t in data]
        self.assertIn('0x123_ABC', values)
        self.assertIn('INTEGER', types)
        self.assertIn('0b1010', values)
        self.assertIn('1.2j', values)
        self.assertIn('COMPLEX', types)
        self.assertIn('...', values)

    def test_bool_and_none(self):
        code = "flag = True\nval = None"
        response = self.tokenize(code)
        data = json.loads(response.data)
        types = [t['type'] for t in data]
        self.assertIn('BOOLEAN', types)
        self.assertIn('NONE', types)

    def test_indentation(self):
        code = "if True:\n    pass\n"
        response = self.tokenize(code)
        data = json.loads(response.data)
        
        types = [t['type'] for t in data]
        self.assertIn('INDENT', types)
        self.assertIn('DEDENT', types)

if __name__ == '__main__':
    unittest.main()
