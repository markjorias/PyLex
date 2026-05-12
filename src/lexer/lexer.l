%{
/**
 * Python Lexical Analyzer - Enterprise Edition (Final Polish)
 * 
 * Includes:
 * - High-Precision Literals
 * - Semantic Indentation
 * - Syntax-level error reporting (Indentation Errors)
 * - Error handling for invalid characters
 */

#include <stdio.h>
#include <string.h>

int line_num = 1;
int indent_stack[100] = {0};
int stack_ptr = 0;

/**
 * Escapes characters for JSON compatibility and prints the token.
 */
void print_json_token(const char* type, const char* value) {
    printf("{\"type\": \"%s\", \"value\": \"", type);
    for (int i = 0; value[i]; i++) {
        switch (value[i]) {
            case '\"': printf("\\\""); break;
            case '\\': printf("\\\\"); break;
            case '\n': printf("\\n");   break;
            case '\r': printf("\\r");   break;
            case '\t': printf("\\t");   break;
            default:   printf("%c", value[i]);
        }
    }
    printf("\", \"line\": %d}\n", line_num);
}

/**
 * Manages the indentation stack and emits INDENT/DEDENT tokens.
 */
void handle_indent(int current_level) {
    if (current_level > indent_stack[stack_ptr]) {
        indent_stack[++stack_ptr] = current_level;
        print_json_token("INDENT", " ");
    } else if (current_level < indent_stack[stack_ptr]) {
        while (stack_ptr > 0 && current_level < indent_stack[stack_ptr]) {
            stack_ptr--;
            print_json_token("DEDENT", " ");
        }
        if (current_level != indent_stack[stack_ptr]) {
            // Reporting a syntax-level error via the lexer
            print_json_token("ERROR", "IndentationError: unindent does not match any outer indentation level");
        }
    }
}
%}

%option noyywrap
%x BOL

/* --- Definitions --- */

DIGIT       [0-9]
HEXDIGIT    [0-9a-fA-F]
BINDIGIT    [01]
OCTDIGIT    [0-7]
LETTER      [a-zA-Z_]
ALNUM       [a-zA-Z0-9_]
PREFIX      (?i:f|r|b|u|fr|rf|rb|br|fb|bf|fur|fub)?

/* Regex components for numbers */
EXPONENT    ([eE][+-]?{DIGIT}(_?{DIGIT})*)
FLOAT_PT1   ({DIGIT}(_?{DIGIT})*)?\.({DIGIT}(_?{DIGIT})*)+{EXPONENT}?
FLOAT_PT2   ({DIGIT}(_?{DIGIT})*)\.{EXPONENT}?
FLOAT_PT3   ({DIGIT}(_?{DIGIT})*){EXPONENT}

%%

    /* --- Whitespace and Indentation --- */

[ \t\r]+        ; 

\r?\n           { line_num++; BEGIN(BOL); }

<BOL>[ \t\r]*\n { line_num++; }
<BOL>[ \t\r]*#  { yyless(yyleng-1); BEGIN(INITIAL); }
<BOL>[ \t\r]+   {
                    int level = 0;
                    for (int i = 0; yytext[i]; i++) {
                        if (yytext[i] == ' ') level++;
                        else if (yytext[i] == '\t') level += 8;
                    }
                    handle_indent(level);
                    BEGIN(INITIAL);
                }
<BOL>.          { yyless(0); handle_indent(0); BEGIN(INITIAL); }

    /* --- Python Literals --- */

"True"|"False"  { print_json_token("BOOLEAN", yytext); }
"None"          { print_json_token("NONE", yytext); }

    /* Complex/Imaginary Numbers */
({FLOAT_PT1}|{FLOAT_PT2}|{FLOAT_PT3}|({DIGIT}(_?{DIGIT})*)+)[jJ] {
    print_json_token("COMPLEX", yytext);
}

    /* Floating Point Numbers */
{FLOAT_PT1}|{FLOAT_PT2}|{FLOAT_PT3} {
    print_json_token("FLOAT", yytext);
}

    /* Integers (Hex, Bin, Oct, Dec) */
0[xX]{HEXDIGIT}(_?{HEXDIGIT})*  |
0[bB]{BINDIGIT}(_?{BINDIGIT})*  |
0[oO]{OCTDIGIT}(_?{OCTDIGIT})*  |
{DIGIT}(_?{DIGIT})*             { print_json_token("INTEGER", yytext); }

    /* --- Python Keywords --- */

"def"|"if"|"else"|"elif"|"while"|"for"|"return"|"import"|"from"|"as"|"class" |
"try"|"except"|"finally"|"with"|"yield"|"lambda"|"pass"|"break"|"continue"   |
"in"|"is"|"and"|"or"|"not"|"async"|"await"|"nonlocal"|"global"|"del"|"assert" {
    print_json_token("KEYWORD", yytext);
}

    /* --- Identifiers --- */

{LETTER}{ALNUM}* {
    print_json_token("IDENTIFIER", yytext);
}

    /* --- Strings --- */

{PREFIX}(\"\"\"([^\"]|(\"[^\"])|(\"\"[^\"]))*\"\"\") |
{PREFIX}(\'\'\'([^\']|(\'[^\'])|(\'\'[^\']))*\'\'\') {
    for (int i = 0; yytext[i]; i++) if (yytext[i] == '\n') line_num++;
    print_json_token("STRING", yytext);
}

{PREFIX}(\"([^\\\"]|\\.)*\"|{PREFIX}\'([^\\\']|\\.)*\') {
    print_json_token("STRING", yytext);
}

    /* --- Operators --- */

"**="|"//="|"<<="|">>="|"**"|"//"|"=="|"!="|"<="|">="|"+="|"-="|"*="|"/="|"%="|"@="|"&="|"|="|"^=" |
"+"|"-"|"*"|"/"|"%"|"="|"<"|">"|"&"|"|"|"^"|"~"|"<<"|">>"|":=" {
    print_json_token("OPERATOR", yytext);
}

    /* --- Punctuation --- */

"..." { print_json_token("PUNCTUATION", yytext); }

":"|"("|")"|"["|"]"|"{"|"}"|","|"."|";"|"@"|"->" {
    print_json_token("PUNCTUATION", yytext);
}

    /* --- Comments and EOF --- */

#.*             ; 

<<EOF>>         {
                    while (stack_ptr > 0) {
                        stack_ptr--;
                        print_json_token("DEDENT", " ");
                    }
                    yyterminate();
                }

    /* --- Error Handling --- */

. {
    fprintf(stderr, "Error: Invalid token '%s' at line %d\n", yytext, line_num);
    print_json_token("ERROR", yytext);
}

%%

int main() {
    BEGIN(BOL);
    yylex();
    return 0;
}
