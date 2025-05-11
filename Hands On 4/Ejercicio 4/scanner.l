%{
#include "parser.tab.h" // Inclusión del encabezado generado por
#include <string.h> // Para manejo de cadenas
#include <stdlib.h> // Para asignación dinámica
%}
%%
"int" { return INT; } // Pa
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; } // Ide
";" { return PUNTOYCOMA; } // Pu
"{" { return LLAVEIZQ; } // Ll
"}" { return LLAVEDER; } // Ll
[ \t\n]+        ;  // Ignora espacios, tabs y retornos de carro
. { return yytext[0]; } // Re
%%