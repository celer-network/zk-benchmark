#!/bin/sh
echo "Benchmark for 1 chunk:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/1$ 2>/dev/null
echo "Benchmark for 2 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/2$ 2>/dev/null
echo "Benchmark for 4 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/4$ 2>/dev/null
echo "Benchmark for 8 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/8$ 2>/dev/null
echo "Benchmark for 16 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/16$ 2>/dev/null
echo "Benchmark for 32 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/32$ 2>/dev/null
echo "Benchmark for 64 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/64$ 2>/dev/null
echo "Benchmark for 128 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/128$ 2>/dev/null
echo "Benchmark for 256 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/256$ 2>/dev/null
echo "Benchmark for 512 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/512$ 2>/dev/null
echo "Benchmark for 1024 chunks:"
/usr/bin/time -o /dev/stdout -f "peak memory: %M, avg cpu: %P" ./bin/celer_bench --benchmark_filter=/1024$ 2>/dev/null
