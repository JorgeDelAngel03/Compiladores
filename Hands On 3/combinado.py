import ply.lex as lex
import ply.yacc as yacc

tokens = (
    'NUMBER', 'BOOLEAN', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE',
    'AND', 'OR', 'NOT', 'LPAREN', 'RPAREN'
)

t_PLUS = r'\+'
t_MINUS = r'-'
t_TIMES = r'\*'
t_DIVIDE = r'/'
t_AND = r'AND'
t_OR = r'OR'
t_NOT = r'NOT'
t_LPAREN = r'\('
t_RPAREN = r'\)'

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_BOOLEAN(t):
    r'[01]'
    t.value = int(t.value)
    return t

t_ignore = ' \t'

def t_error(t):
    raise SyntaxError(f"Carácter ilegal '{t.value[0]}'")

def p_expr(p):
    '''
    expr : expr PLUS expr
         | expr MINUS expr
         | expr TIMES expr
         | expr DIVIDE expr
         | expr AND expr
         | expr OR expr
         | NOT expr
         | MINUS expr %prec UMINUS
         | LPAREN expr RPAREN
         | NUMBER
         | BOOLEAN
    '''
    pass

def p_error(p):
    if p:
        raise SyntaxError(f"Error de sintaxis cerca de '{p.value}'")
    else:
        raise SyntaxError("Expresión incompleta")

precedence = (
    ('left', 'OR'),
    ('left', 'AND'),
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIVIDE'),
    ('right', 'NOT', 'UMINUS'),
)

def build_parser():
    lexer = lex.lex()
    parser = yacc.yacc()
    return lexer, parser

def validate(expression):
    lexer, parser = build_parser()
    try:
        parser.parse(expression, lexer=lexer)
        print(f"✅ '{expression}' es válida")
        return True
    except SyntaxError as e:
        print(f"❌ '{expression}' es inválida - {str(e)}")
        return False

def main():
    print("\nValidador Combinado")
    print("Ejemplos válidos: (4+5)*2 AND 1, NOT (3-1) OR 0")
    print("Ejemplos inválidos: (2 AND 3) / ), 5 + (1 OR )")
    
    while True:
        expr = input("\nIngresa expresión (o 'salir'): ").strip()
        if expr.lower() == 'salir':
            break
        if expr:
            validate(expr)
        else:
            print("Por favor ingresa una expresión")

if __name__ == "__main__":
    main()