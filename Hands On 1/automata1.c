#include <stdio.h>
#include <ctype.h>
int validate_alpha(const char *str) {
while (*str) {
if (!isalpha(*str)) return 0;
str++;
}
return 1;
}
int main() {
const char *input = "HolaSoyJorge";
if (validate_alpha(input)) {
printf("La cadena '%s' es v%clida.\n", input, 160);
} else {
printf("La cadena '%s' es inv%clida.\n", input, 160);
}
return 0;
}
