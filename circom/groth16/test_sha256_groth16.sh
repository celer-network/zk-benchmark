#!/bin/bash

set -x
set -e

TIME="/usr/bin/time -f \"mem: %M time: %E\" "
INPUT_SIZE=64
TAU_RANK=21
TAU_DIR="../../setup/tau"
TAU_FILE="${TAU_DIR}/powersOfTau28_hez_final_${TAU_RANK}.ptau"

function main() {
    pushd ../circuits/sha256_test

    echo "========== Step1: compile circom  =========="
    $TIME circom sha256_test.circom --r1cs --sym --c

    echo "========== Step2: generate witness =========="
    cd sha256_test_cpp
    $TIME make
    cd ..
    $TIME sha256_test_cpp/sha256_test input_${INPUT_SIZE}.json witness.wtns
    #$TIME node sha256_test_js/generate_witness.js sha256_test_js/sha256_test.wasm input_${INPUT_SIZE}.json witness.wtns

    echo "========== Step3: setup =========="
    if [ ! -f $TAU_FILE ]; then
        wget -P $TAU_DIR https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_${TAU_RANK}.ptau
    fi
    $TIME snarkjs groth16 setup sha256_test.r1cs ${TAU_FILE} sha256_test_0000.zkey

    echo "========== Step4: contribute to the phase 2 of the ceremony =========="
    $TIME echo 1 | snarkjs zkey contribute sha256_test_0000.zkey sha256_test_0001.zkey --name="1st Contributor Name" -v

    echo "========== Step5: export the verification key =========="
    $TIME snarkjs zkey export verificationkey sha256_test_0001.zkey verification_key.json

    echo "========== Step6: groth16 prove =========="
    $TIME snarkjs groth16 prove sha256_test_0001.zkey witness.wtns proof.json public.json

    echo "========== Step7: groth16 verify =========="
    $TIME snarkjs groth16 verify verification_key.json public.json proof.json

    echo "========== Step8: groth16 rapidsnark prove =========="
    $TIME ../../groth16/rapidsnark/build/prover sha256_test_0001.zkey witness.wtns proof.json public.json

    echo "========== Step9: groth16 verify =========="
    $TIME snarkjs groth16 verify verification_key.json public.json proof.json

    popd
}

main
