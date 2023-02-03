# zk-benchmark
Benchmark of multiple zk implementations.


### SHA256 benchmark

Define a single circuit that compute sha256 for N bytes data
- one private input: _In_, len(_In_) = N = 2^k
- one public input: _Out_ = sha256(_In_)

func benchmark(In, Out):
    assert(sha256(In) == Out)

#### Deprecated Option
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