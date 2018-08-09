#!/usr/bin/env ruby

# normal useless way

def fib(num)
  return 0 if num.zero?
  return 1 if num == 1

  fib(num - 1) + fib(num - 2)
end

# tail call optimization

def inner_fib(num, a, b)
  return a if num.zero?
  return b if num == 1

  inner_fib(num - 1, b, a + b)
end

def fib_tail(num)
  inner_fib(num, 0, 1)
end

# TRAMPOLINES

DONE_PROC = proc do |num|
  { done: true,
    value: num }
end

CONTINUE_PROC = proc do |func|
  { func: func,
    done: false }
end

def inner_fib_tramp(num, a, b)
  return DONE_PROC.call(a) if num.zero?
  return DONE_PROC.call(b) if num == 1

  CONTINUE_PROC.call(proc { inner_fib_tramp(num - 1, b, a + b) })
end

def trampoline_it(func)
  result = func.call
  result = result[:func].call until result[:done]
  result[:value]
end

def fib_tramp(num)
  trampoline_it(proc { inner_fib_tramp(num, 0, 1) })
end

num = begin
        Integer(ARGV.shift)
      rescue StandardError
        1_000_000
      end

puts "fib #{num} eq #{fib_tramp(num)}"
