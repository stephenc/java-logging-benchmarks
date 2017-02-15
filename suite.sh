#!/bin/sh

mkdir -p threads
for n in 1 2 4 8 ;
do 
  echo "Starting tests with t=$n"
  echo "=========================="
  echo ""
  mkdir -p threads/$n
  ( cd threads/$n; ../../run.rb -f 1 -t $n )
done

tar -czf threads.tar.gz threads/*/results/*
