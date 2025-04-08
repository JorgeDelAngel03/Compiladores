#include <stdio.h>
#include <string.h>
int validate_if_else(const char *str) {
    return strstr(str, "if") != NULL && strstr(str, "else") != NULL;
}
int main() {
    const char *input = "while (x > 0) { }";
    if (validate_if_else(input)) {
        printf("La sentencia '%s' es v%clida.\n", input, 160);
    } else {
        printf("La sentencia '%s' es inv%clida.\n", input, 160);
    }
    return 0;
}

