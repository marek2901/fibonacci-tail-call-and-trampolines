#include <stdio.h>

typedef unsigned long long int ulli;

typedef enum {
  FUNCTION,
  VALUE
} val_type;

struct result_type;
typedef struct result_type (trampolined_fun_pointer)(int, ulli, ulli);
typedef struct result_type {
  val_type type;
  trampolined_fun_pointer *fun;
  int counter;
  ulli a;
  ulli b;
} result_type;

result_type fibo(int counter, ulli a, ulli b){
  if(counter == 0){
    result_type result = { VALUE, NULL, counter, a, b };
    return result;
  }
  result_type result = { FUNCTION, &fibo, counter-1, b, a+b };
  return result;
}


ulli trampoline(trampolined_fun_pointer fun, int counter, ulli a, ulli b){
  result_type result = fun(counter, a, b);
  while(result.type == FUNCTION){
    result = result.fun(result.counter, result.a, result.b);
  }
  return result.a;
}


int main(int argc, char *argv[]){
  if(argc < 2){
    fprintf(stderr, "Give a number to get the result!\n%s <n>\n", argv[0]);
    return 1;
  }
  int counter;
  sscanf(argv[1], "%d", &counter);
  printf("%lld\n", trampoline(fibo, counter, 0L, 1L));
  return 0;
}
