#!/bin/bash

set -x
set -e

function main() {
    pushd ../circuits/sha256_test

    echo "========== Step1: compile circom  =========="
    time circom sha256_test.circom --r1cs --sym --c

    echo "========== Step2: generate witness =========="
    cd sha256_test_cpp
    time make
    cd ..
    time sha256_test_cpp/sha256_test input_8.json witness.wtns
    #time node sha256_test_js/generate_witness.js sha256_test_js/sha256_test.wasm input.json witness.wtns

    echo "========== Step3: setup =========="
    time snarkjs groth16 setup sha256_test.r1cs ../../setup/tau/powersOfTau28_hez_final_21.ptau sha256_test_0000.zkey

    echo "========== Step4: contribute to the phase 2 of the ceremony =========="
    time echo 1 | snarkjs zkey contribute sha256_test_0000.zkey sha256_test_0001.zkey --name="1st Contributor Name" -v

    echo "========== Step5: export the verification key =========="
    time snarkjs zkey export verificationkey sha256_test_0001.zkey verification_key.json

    echo "========== Step6: groth16 prove =========="
    time snarkjs groth16 prove sha256_test_0001.zkey witness.wtns proof.json public.json

    echo "========== Step7: groth16 verify =========="
    time snarkjs groth16 verify verification_key.json public.json proof.json

    echo "========== Step8: groth16 rapidsnark prove =========="
    time ../../groth16/rapidsnark/build/prover sha256_test_0001.zkey witness.wtns proof.json public.json

    echo "========== Step9: groth16 verify =========="
    time snarkjs groth16 verify verification_key.json public.json proof.json

    popd
}

main
