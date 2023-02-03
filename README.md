# zk-benchmark
Benchmark of multiple zk implementations.


### SHA256 benchmark
Define a single circuit that compute sha256 for N times
- one private input: _In_
- one public input: _Out_ = sha256(_In_)

```
func benchmark(_In_, _Out_, _N_):
    for i = 0; i < N; i++ {
        h = sha256(_In_);
        assert(h == _Out_);
    }
```