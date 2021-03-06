%{
    #include <iostream>
    #include <cstdlib>
    #include "AST.h"
    #include "Visitor.h"
    #include "dcc.tab.h"
    #define YY_DECL extern "C" int yylex()
%}

%option noyywrap
%option yylineno
%option nounput

DIGIT [0-9]
ALPHA [a-zA-Z]
UNDERSCOREDALPHA [a-zA-Z_]
HEXADECIMAL [0-9a-fA-F]
CHAR ([\40-\176]{-}['"\\])|\\n|\\t|\\\\|\\\"|\\\'

%%

\/\/.*\n {
}

\, {
    return COMMA;
}

\; {
    return SEMICOLON;
}

\( {
    return OPEN_PARANTHESIS;
}

\) {
    return CLOSE_PARANTHESIS;
}

\[ {
    return OPEN_SQUAREBRACKET;
}

\] {
    return CLOSE_SQUAREBRACKET;
}

\{  {
    return OPEN_CURLYBRACE;
}

\}  {
    return CLOSE_CURLYBRACE;
}

\+\= {
    return PLUSEQUAL;
}

\+ {
    return PLUS;
}

\-\= {
    return MINUSEQUAL;
}

\- {
    return MINUS;
}

\* {
    return MULTIPLY;
}

\/ {
    return DIVIDE;
}

\% {
    return MODULO;
}

\!\= {
    return NOTEQUAL;
}

\! {
    return NOT;
}

\<\= {
    return LESSEQUAL;
}

\< {
    return LESSTHAN;
}

\>\= {
    return GREATEREQUAL;
}

\> {
    return GREATERTHAN;
}

\=\= {
    return EQUALEQUAL;
}

\= {
    return EQUAL;
}

\|\| {
    return OR;
}

\&\& {
    return AND;
}

boolean {
    return BOOLEAN;
}

break {
    return BREAK;
}

callout {
    return CALLOUT;
}

class {
    return CLASS;
}

continue {
    return CONTINUE;
}

else {
    return ELSE;
}

false {
    return FALSE;
}

for {
    return FOR;
}

if {
    return IF;
}

int {
    return INT;
}

return {
    return RETURN;
}

true {
    return TRUE;
}

void {
    return VOID;
}
Program {
    return PROGRAMME;
}
{UNDERSCOREDALPHA}({UNDERSCOREDALPHA}|{DIGIT})* {
    yylval.sval = strdup(yytext);
    return IDENTIFIER;
}

{DIGIT}+ {
    yylval.ival = atoi(yytext);
    return INT_VALUE;
}

0x{HEXADECIMAL}+ {
    yylval.ival = atoi(yytext);
    return INT_VALUE;
}

\"{CHAR}*\" {
    yylval.sval = strndup(yytext + 1, strlen(yytext) - 2);
    return STRING_VALUE;
}

\'{CHAR}\' {
    yylval.cval = yytext[1];
    return CHAR_VALUE;
}

[\t\ \n] {
}

. {
    std::cerr << "UNKNOWN SOMETHING HAS HAPPENED" << yytext;
}

%%
