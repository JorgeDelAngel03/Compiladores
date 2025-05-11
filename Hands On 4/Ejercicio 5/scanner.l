%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
/* scanner.l: reconoce palabras reservadas, identificadores y símbolos */
%}

%%

"int"                   { return INT; }
"func"                  { return FUNC; }
"return"                { return RETURN; }

[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return ID; }

";"                     { return PUNTOYCOMA; }
","                     { return COMMA; }


"="                     { return ASSIGN; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"{"                     { return LBRACE; }
"}"                     { return RBRACE; }

[ \t\r\n]+              { /* ignora espacios */ }
.                       { return yytext[0]; }

%%

int yywrap(void) { return 1; }