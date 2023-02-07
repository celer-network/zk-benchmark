#!/bin/bash  

for i in $(seq 0 10)
do
n=$[2 ** $i]
cd zok/$n
echo "benchmark size: "$[$n*64]
#/usr/bin/time -f "%M %e" bash ../../scripts/init.sh > log
#/usr/bin/time -f "%M %e"  bash ../../scripts/run.sh $n >> log
#/usr/bin/time -f "%M %e"  bash ../../scripts/verify.sh >> log
gtime -f "%M %e" sh ../../scripts/init.sh > log
gtime -f "%M %e"  sh ../../scripts/run.sh $n >> log
gtime -f "%M %e"  sh ../../scripts/verify.sh >> log
rm out
rm out.r1cs
echo ""
cd ../..
done
