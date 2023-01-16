pragma circom 2.0.3;

include "simple_serialize.circom";

template SSZTest() {
    signal input pubkeys[512][48];
    signal input aggPubkey[48];
    signal input start;
    signal output out[32];

    component ssz = SSZPhase0SyncCommittee();

    ssz.pubkeys <== pubkeys;
    ssz.aggregate_pubkey <== aggPubkey;
    out <== ssz.out;

    for (var i = 0; i < 32; i++) {
        log(out[i]);
    }

    out[0] === start;
}

component main = SSZTest();
