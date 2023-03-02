# zk-benchmark
Benchmark of multiple zk implementations.

The benchmark results can be found in [this blog](https://blog.celer.network/2023/03/01/the-patheon-of-zero-knowledge-proof-development-frameworks/).

### SHA256 benchmark

Define a single circuit that compute sha256 for N bytes data
- one private input: _x_, len(_x_) = _N_ = 2^k
- one public input: _h_ = sha256(_x_)

```
func benchmark(x, h):
    assert(sha256(x) == h)
```

Testing Data

```
data: 00 repeated 64 times
hash: f5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b
data: 00 repeated 128 times
hash: 38723a2e5e8a17aa7950dc008209944e898f69a7bd10a23c839d341e935fd5ca
data: 00 repeated 256 times
hash: 5341e6b2646979a70e57653007a1f310169421ec9bdd9f1a5648f75ade005af1
data: 00 repeated 512 times
hash: 076a27c79e5ace2a3d47f9dd2e83e4ff6ea8872b3c2218f66c92b89b55f36560
data: 00 repeated 1024 times
hash: 5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef
data: 00 repeated 2048 times
hash: e5a00aa9991ac8a5ee3109844d84a55583bd20572ad3ffcd42792f3c36b183ad
data: 00 repeated 4096 times
hash: ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7
data: 00 repeated 8192 times
hash: 9f1dcbc35c350d6027f98be0f5c8b43b42ca52b7604459c0c42be3aa88913d47
data: 00 repeated 16384 times
hash: 4fe7b59af6de3b665b67788cc2f99892ab827efae3a467342b3bb4e3bc8e5bfe
data: 00 repeated 32768 times
hash: c35020473aed1b4642cd726cad727b63fff2824ad68cedd7ffb73c7cbd890479
data: 00 repeated 65536 times
hash: de2f256064a0af797747c2b97505dc0b9f3df0de4f489eac731c23ae9ca9cc31
```
