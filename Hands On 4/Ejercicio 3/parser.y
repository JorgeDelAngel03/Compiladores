%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
extern int yylineno;
extern char* yytext;
extern FILE *yyin;

#define MAX_FUNC 100
char *funciones[MAX_FUNC];
int aridades[MAX_FUNC];
int nfuncs = 0;

void registrar_funcion(char *id, int n) {
    if (nfuncs >= MAX_FUNC) {
        fprintf(stderr, "Error: Demasiadas funciones declaradas\n");
        exit(1);
    }
    funciones[nfuncs] = strdup(id);
    aridades[nfuncs++] = n;
}

int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++) {
        if (strcmp(funciones[i], id) == 0) {
            return aridades[i];
        }
    }
    return -1;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d: %s\n", yylineno, s);
}
%}

%union {
    char *str;
    int num;
}

%token <str> ID STRING NUM
%token FUNC PARIZQ PARDER PUNTOYCOMA COMA

%type <num> lista_args args

%%

programa:
    declaraciones llamadas
;

declaraciones:
    /* vacío */
    | declaraciones declaracion
;

declaracion:
    FUNC ID PARIZQ lista_args PARDER PUNTOYCOMA {
        registrar_funcion($2, $4);
        free($2);
    }
;

lista_args:
    ID { $$ = 1; free($1); }
    | lista_args COMA ID { $$ = $1 + 1; free($3); }
;

llamadas:
    /* vacío */
    | llamadas llamada
;

llamada:
    ID PARIZQ args PARDER PUNTOYCOMA {
        int esperados = obtener_aridad($1);
        if (esperados == -1) {
            fprintf(stderr, "Error en l\241nea %d: Función '%s' no declarada\n", yylineno, $1);
        } else if (esperados != $3) {
            fprintf(stderr, "Error en l\241nea %d: '%s' esperaba %d argumentos\n",
                  yylineno, $1, esperados, $3);
        }
        free($1);
    }
;

args:
    /* vacío */ { $$ = 0; }
    | ID { $$ = 1; free($1); }
    | STRING { $$ = 1; free($1); }
    | NUM { $$ = 1; free($1); }
    | args COMA ID { $$ = $1 + 1; free($3); }
    | args COMA STRING { $$ = $1 + 1; free($3); }
    | args COMA NUM { $$ = $1 + 1; free($3); }
;

%%

int main(int argc, char *argv[]) {
    yyin = stdin;
    
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("Error al abrir archivo");
            return 1;
        }
        yyin = archivo;
    }
    
    int resultado = yyparse();
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    // Liberar memoria
    for (int i = 0; i < nfuncs; i++) {
        free(funciones[i]);
    }
    
    return resultado;
}