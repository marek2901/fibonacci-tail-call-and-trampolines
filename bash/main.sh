#!/usr/bin/env bash

fib_tramp() {
  [ $1 == 0 ] && echo $2 && exit 0
  COUNTER=$((${1}-1))
  A=$3
  B=$(echo ${2}+${3} | bc | tr -d '\\' | tr -d $'\n')
  echo "fib_tramp $COUNTER $A $B"
}

trampoline() {
  RESULT="$($@)"
  grep -Eq '^[0-9]+$' <(echo $RESULT) && echo $RESULT && exit 0
  while true
    do
      RESULT="$(eval $RESULT)"
      grep -Eq '^[0-9]+$' <(echo $RESULT) && echo $RESULT && exit 0
    done
}

trampoline fib_tramp $1 0 1
