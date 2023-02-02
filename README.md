# zk-benchmark
Benchmark of multiple zk implementations.


### SHA256 benchmark
Define a single circuit that compute sha256 merkle root of _n_ inputs
- circuit private input: [_X1_, _X2_, ..., _Xn_], _n = 2^k_
- circuit public input: Merkle root of the private input array

Test inputs: _Xi_ = int(_i_).bytes() pad to 64 bytes.

#### Compute merkle root
```
func merkleRoot(array in) -> hash h:
    // require len(in) = 2^k
    arr = []
    for i = 0; i < len(in); i++ {
        arr.append(hash(in[i]))
    }
    while len(arr) != 1 {
        arr = arrayHash(arr)
    }
    return arr[0]

// hash one layer, len(out) = len(in) / 2
func arrayHash(array in) -> array out:
     out = []
     for i = 0; i < len(in)/2; i++ {
     	 h = hash(in[2*i], in[2*i+1])
     	 out.append(h)
     }
     return out
```