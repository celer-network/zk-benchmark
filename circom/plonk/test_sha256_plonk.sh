#!/bin/bash

set -x
set -e

function main() {
    export NODE_OPTIONS=--max_old_space_size=8198
    pushd ../circuits/sha256_test

    echo "========== Step1: compile circom  =========="
    time circom sha256_test.circom --r1cs --wasm --sym --c

    echo "========== Step2: generate witness =========="
    cd sha256_test_cpp
    time make
    cd ..
    time sha256_test_cpp/sha256_test input.json witness.wtns
    #time node sha256_test_js/generate_witness.js sha256_test_js/sha256_test.wasm input.json witness.wtns

    echo "========== Step3: setup =========="
    time snarkjs plonk setup sha256_test.r1cs ../../setup/tau/powersOfTau28_hez_final_22.ptau sha256_test_plonk_0000.zkey

    echo "========== Step4: export the verification key =========="
    time snarkjs zkey export verificationkey sha256_test_plonk_0000.zkey verification_key_plonk.json

    echo "========== Step5: plonk prove =========="
    time snarkjs plonk prove sha256_test_plonk_0000.zkey witness.wtns proof_plonk.json public_plonk.json

    echo "========== Step6: plonk verify =========="
    time snarkjs plonk verify verification_key_plonk.json public_plonk.json proof_plonk.json

    popd
}

main
