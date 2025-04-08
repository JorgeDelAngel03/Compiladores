%{
#include <stdio.h>
%}

%%
"int"       { printf("PALABRA CLAVE: %s\n", yytext); }
"return"    { printf("PALABRA CLAVE: %s\n", yytext); }
[a-zA-Z]+   { printf("IDENTIFICADOR: %s\n", yytext); }
[0-9]+      { printf("NUMERO: %s\n", yytext); }
\"[^"]*\"   { printf("CADENA: %s\n", yytext); } // Cadenas entre comillas dobles
"//".*      { printf("COMENTARIO (una línea): %s\n", yytext); } // Comentarios de una línea
"/*"([^*]|"*"+[^*/])*"*"+"/" { printf("COMENTARIO (multilínea): %s\n", yytext); } // Comentarios multilínea
[ \t\n]     ; // Ignorar espacios, tabulaciones y saltos de línea
.           { printf("CARACTER NO RECONOCIDO: %s\n", yytext); }
%%

int yywrap() {
    return 1; // Indica que no hay más archivos de entrada.
}

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