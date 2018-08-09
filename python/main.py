#!/usr/bin/env python

# normal useless way
def fib(num):
    if num < 2:
        return n
    return fib(num - 1) + fib(num - 2)

# pseudo-tail-recursive optimization
def fib_tail(num, a=0, b=1):
    if num == 0:
        return a
    return fib_tail(num-1, b, a+b)

# TRAMPOLINES
def fib_tramp(num, a=0, b=1):
    if num == 0:
        return a
    return lambda: fib_tramp(num-1, b, a+b)

def trampoline_it(func):
    while callable(func):
        func = func()
    return func

def main():
    import sys
    try:
        num = int(sys.argv[1])
    except (ValueError, IndexError):
        num = 1000000
    print(
        'fib {argument} eq {result}'.format(
            argument=num,
            result=trampoline_it(fib_tramp(num)),
            #result=fib(num), # -> would result with
            #RuntimeError: maximum recursion depth exceeded
        )
    )

if __name__ == '__main__':
    main()
