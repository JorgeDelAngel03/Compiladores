%{
#include <stdio.h>

int palabras_clave = 0;
int identificadores = 0;
int numeros = 0;
int operadores = 0;
int delimitadores = 0;
%}

%%
"int"       { palabras_clave++; }
"return"    { palabras_clave++; }
[a-zA-Z]+   { identificadores++; }
[0-9]+      { numeros++; }
[+\-*/=]    { operadores++; }
[(){},;]    { delimitadores++; }
\"[^"]*\"   ; // Ignorar cadenas de texto
"//".*      ; // Ignorar comentarios de una línea
"/*"([^*]|"*"+[^*/])*"*"+"/" ; // Ignorar comentarios multilínea
[ \t\n]     ; // Ignorar espacios, tabulaciones y saltos de línea
.           ; // Ignorar otros caracteres
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

    printf("Estadísticas:\n");
    printf("Palabras clave: %d\n", palabras_clave);
    printf("Identificadores: %d\n", identificadores);
    printf("Números: %d\n", numeros);
    printf("Operadores: %d\n", operadores);
    printf("Delimitadores: %d\n", delimitadores);

    return 0;
}