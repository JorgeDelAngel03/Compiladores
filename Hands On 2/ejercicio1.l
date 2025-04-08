%{
#include <stdio.h>
%}

%%
"int"       { printf("PALABRA CLAVE: %s\n", yytext); }
"return"    { printf("PALABRA CLAVE: %s\n", yytext); }
[a-zA-Z]+   { printf("IDENTIFICADOR: %s\n", yytext); }
[0-9]+      { printf("NUMERO: %s\n", yytext); }
[ \t\n]     ; // Ignorar espacios, tabulaciones y saltos de línea
.           { printf("CARACTER NO RECONOCIDO: %s\n", yytext); }
%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error al abrir el archivo");
            return 1;
        }
        yyin = file;
    }
    yylex();
    return 0;
}

