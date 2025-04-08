import ply.lex as lex
import ply.yacc as yacc

# Analizador léxico
tokens = ('NUMBER', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE', 'LPAREN', 'RPAREN')

t_PLUS = r'\+'
t_MINUS = r'-'
t_TIMES = r'\*'
t_DIVIDE = r'/'
t_LPAREN = r'\('
t_RPAREN = r'\)'

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_error(t):
    print(f"Carácter ilegal '{t.value[0]}'")
    t.lexer.skip(1)

t_ignore = ' \t'

lexer = lex.lex()

# Analizador sintáctico
def p_expr(p):
    '''
    expr : expr PLUS expr
         | expr MINUS expr
         | expr TIMES expr
         | expr DIVIDE expr
         | MINUS expr %prec UMINUS
         | LPAREN expr RPAREN
         | NUMBER
    '''
    pass

def p_error(p):
    if p:
        print(f"❌ Error de sintaxis: expresión incompleta o inválida cerca de '{p.value}'")
    else:
        print("❌ Error de sintaxis: expresión incompleta")
    # Forzar el fallo de validación
    raise SyntaxError("Invalid expression")

precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIVIDE'),
    ('right', 'UMINUS'),
)

parser = yacc.yacc()

def validate_expression(expression):
    try:
        # Necesitamos crear un nuevo lexer para cada validación
        lexer = lex.lex()
        parser.parse(expression, lexer=lexer)
        print(f"✅ '{expression}' es una expresión válida")
        return True
    except SyntaxError:
        print(f"❌ '{expression}' es inválida")
        return False
    except Exception as e:
        print(f"❌ Error inesperado validando '{expression}': {str(e)}")
        return False

# Interfaz de usuario
def main():
    print("\nValidador de Expresiones Aritméticas")
    print("Operadores permitidos: + - * / ( )")
    print("Ejemplos válidos: (3+5)*2, 4*5-6/2")
    print("Ejemplos inválidos: 3 - (2 + ), 5 + * 3")
    print("Escribe 'salir' para terminar\n")
    
    while True:
        expression = input("Ingresa una expresión aritmética: ")
        if expression.lower() == 'salir':
            break
        if expression.strip():
            validate_expression(expression)
        else:
            print("Por favor ingresa una expresión")

if __name__ == "__main__":
    main()