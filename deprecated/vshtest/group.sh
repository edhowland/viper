#!/usr/bin/env bash
for i in $@
do
  ../bin/vish one_test.vsh $i
  echo the return code from $i was $?
done
