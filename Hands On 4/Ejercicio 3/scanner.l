%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>

extern int yylineno;
%}

%option noyywrap

%%

"func"          { return FUNC; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
[0-9]+          { yylval.str = strdup(yytext); return NUM; }
\"[^"\n]*\"     { yylval.str = strdup(yytext); return STRING; }
"("             { return PARIZQ; }
")"             { return PARDER; }
";"             { return PUNTOYCOMA; }
","             { return COMA; }
[ \t\r]+        ;  // Ignora espacios, tabs y retornos de carro
\n              { yylineno++; }
.               { fprintf(stderr, "Error léxico en línea %d: Carácter no válido '0x%x'\n", yylineno, yytext[0]); }

%%