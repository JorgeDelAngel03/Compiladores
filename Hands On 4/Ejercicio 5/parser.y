%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ID 100
char *tabla[MAX_ID];
int ntabla = 0;

void agregar(char *id) {
  for (int i = 0; i < ntabla; i++)
    if (strcmp(tabla[i], id) == 0) return;
  tabla[ntabla++] = strdup(id);
}

int buscar(char *id) {
  for (int i = 0; i < ntabla; i++)
    if (strcmp(tabla[i], id) == 0) return 1;
  return 0;
}

#define MAX_FUNC 100
typedef struct {
  char *nombre;
  int num_args;
} Funcion;

Funcion funciones[MAX_FUNC];
int nfunciones = 0;

void agregar_funcion(char *id, int nargs) {
  for (int i = 0; i < nfunciones; i++)
    if (strcmp(funciones[i].nombre, id) == 0)
      return;
  funciones[nfunciones].nombre = strdup(id);
  funciones[nfunciones].num_args = nargs;
  nfunciones++;
}

int buscar_funcion(char *id, int args) {
  for (int i = 0; i < nfunciones; i++) {
    if (strcmp(funciones[i].nombre, id) == 0)
      return funciones[i].num_args == args ? 1 : funciones[i].num_args;
  }
  return -1;
}

int yylex(void);
int yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
  return 0;
}
%}

%union {
  char *str;
  int num;
}

%token <str> ID
%token INT PUNTOYCOMA FUNC RETURN COMMA
%token ASSIGN LPAREN RPAREN LBRACE RBRACE

%type <num> listaParam argumentos

%%

programa
  : declaraciones elementos
  ;

declaraciones
  : /* vacío */
  | declaraciones INT ID PUNTOYCOMA
      {
        if (buscar($3)) {
          printf("Error: redeclaraci\242n de '%s'\n", $3);
        } else {
          agregar($3);
        }
      }
  ;

elementos
  : /* vacío */
  | elementos elemento
  ;

elemento
  : sentencia
  | funcion_def
  ;

sentencia
  : ID PUNTOYCOMA
      {
        if (!buscar($1)) printf("Error sem\240ntico: '%s' no est\240 declarado\n", $1);
      }
  | ID ASSIGN ID PUNTOYCOMA
      {
        if (!buscar($1)) printf("Error sem\240ntico: '%s' no est\240 declarado\n", $1);
        if (!buscar($3)) printf("Error sem\240ntico: '%s' no est\240 declarado\n", $3);
      }
  | ID LPAREN argumentos RPAREN PUNTOYCOMA
      {
        int esperados = buscar_funcion($1, $3);
        if (esperados == -1)
          printf("Error sem\240ntico: funci\242n '%s' no est\240 declarada\n", $1);
        else if (esperados != 1)
          printf("Error: funci\242n '%s' espera %d argumentos\n", $1, esperados);
      }
  ;

argumentos
  : /* vacío */                     { $$ = 0; }
  | ID                              { if (!buscar($1)) printf("Error sem\240ntico: '%s' no est\240 declarado\n", $1); $$ = 1; }
  | argumentos COMMA ID             { if (!buscar($3)) printf("Error sem\240ntico: '%s' no est\240 declarado\n", $3); $$ = $1 + 1; }
  ;

funcion_def
  : FUNC ID LPAREN listaParam RPAREN LBRACE declaraciones elementos RETURN ID PUNTOYCOMA RBRACE
      {
        agregar($2);                         // $2 es ID (str)
        agregar_funcion($2, $4);             // $4 es listaParam (int)
        if (!buscar($10))                    // $10 es ID (str)
          printf("Error: identificador no declarado\n");
      }
  ;


listaParam
  : /* vacío */               { $$ = 0; }
  | ID                        { agregar($1); $$ = 1; }
  | listaParam COMMA ID       { agregar($3); $$ = $1 + 1; }
  ;

%%

int main() {
  return yyparse();
}
