%{
#include <stdio.h> // Para impresión en consola
#include <stdlib.h> // Para memoria dinámica
#include <string.h> // Para manejo de cadenas
int yylex(void); // Función léxica
int yyerror(char *s) { printf("Error: %s", s); return 0; } // Errores sintácticos
#define MAX_SCOPE 10
#define MAX_ID 100
char *ambitos[MAX_SCOPE][MAX_ID]; // Tabla para múltiples niveles de ámbito
int niveles[MAX_SCOPE]; // Conteo de variables por nivel
int tope = 0; // Índice del ámbito actual

void entrar_ambito() {
tope++; // Entra a un nuevo bloque
niveles[tope] = 0; // Inicializa nivel
}

void salir_ambito() {
tope--; // Sale del ámbito actual
}

void agregar_local(char *id) {
ambitos[tope][niveles[tope]++] = strdup(id); // Agrega variable al ámbito a
}

int buscar_local(char *id) {
for (int i = tope; i >= 0; i--) {
for (int j = 0; j < niveles[i]; j++) {
if (strcmp(ambitos[i][j], id) == 0) return 1; // Encuentra en ámbito act
}
}
return 0; // No encontrado
}
%}
%union { char *str; } // Asociación de tipo
%token <str> ID
%token INT LLAVEIZQ LLAVEDER PUNTOYCOMA
%%
programa:
bloque // Un programa es un bloque
;
bloque:
LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); }
;
instrucciones:
instruccion
| instrucciones instruccion
;
instruccion:
INT ID PUNTOYCOMA { agregar_local($2); } // Declaración de variabl
| ID PUNTOYCOMA {
if (!buscar_local($1)) // Verificación de uso
printf("Error sem\240ntico: '%s' no est\240 declarado\n", $1);
}
| bloque // Bloque anidado
;
%%
int main() { return yyparse(); }