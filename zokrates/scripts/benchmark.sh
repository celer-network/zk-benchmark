#!/bin/bash  

for i in $(seq 0 1)
do
n=$[2 ** $i]
cd zok/$n
echo "benchmark size: "$[$n*64]
#/usr/bin/time -f "%M %e" sh ../init.sh > log
#/usr/bin/time -f "%M %e"  sh ../run.sh $n >> log
#/usr/bin/time -f "%M %e"  sh ../verify.sh >> log
gtime -f "%M %e" sh ../../scripts/init.sh > log
gtime -f "%M %e"  sh ../../scripts/run.sh $n >> log
gtime -f "%M %e"  sh ../../scripts/verify.sh >> log
echo ""
cd ../..
done
