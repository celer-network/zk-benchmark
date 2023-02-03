# zk-benchmark
Benchmark of multiple zk implementations.


### SHA256 benchmark
Define a single circuit that compute sha256 for N times
- one private input: _In_
- one public input: _Out_ = sha256(_In_)

```
func benchmark(In, Out, N):
    for i = 0; i < N; i++ {
        h = sha256(In);
        assert(h == Out);
    }
```