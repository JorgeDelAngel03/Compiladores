%{
#include "parser.tab.h" // Se incluye el encabezado generado por
#include <string.h> // Para manejo de cadenas (strdup)
#include <stdlib.h> // Para funciones estándar
%}
%%
"int" { return INT; } 
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; } 
";" { return PUNTOYCOMA; }
[ \t\n]+ ; // I
. { return yytext[0]; } 
%%