#!/usr/bin/env bash

fib_tramp() {
  [ $1 == 0 ] && echo $2 && return 0
  COUNTER=$((${1}-1))
  A=$3
  B=$(echo ${2}+${3} | bc | tr -d $'\n\\')
  echo "fib_tramp $COUNTER $A $B"
}

trampoline() {
  RESULT="$($@)"
  grep -Eq '^[0-9]+$' <(echo $RESULT) && echo $RESULT && return 0
  while true
    do
      RESULT="$(eval $RESULT)"
      grep -Eq '^[0-9]+$' <(echo $RESULT) && echo $RESULT && return 0
    done
}

trampoline fib_tramp $1 0 1
