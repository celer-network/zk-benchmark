#!/bin/bash

set -e
set -x

export NODE_OPTIONS=--max_old_space_size=327680
sysctl -w vm.max_map_count=655300

function main() {
    pushd ../circuits/ssz_test

    echo "========== Step1: compile circom  =========="
    time circom ssz_test.circom --r1cs --sym --c

    echo "========== Step2: generate witness =========="
    cd ssz_test_cpp
    make
    cd ..
    time ssz_test_cpp/ssz_test ./input.json ./witness_ssz_test.wtns

    echo "========== Step3: setup =========="
    time snarkjs groth16 setup ssz_test.r1cs ../../setup/tau/powersOfTau28_hez_final_27.ptau ssz_test_0000.zkey

    echo "========== Step4: contribute to the phase 2 of the ceremony =========="
    time echo 1 | snarkjs zkey contribute ssz_test_0000.zkey ssz_test_0001.zkey --name="1st Contributor Name" -v

    echo "========== Step5: export the verification key =========="
    time snarkjs zkey export verificationkey ssz_test_0001.zkey verification_ssz_test_key.json

    echo "========== Step6: groth16 prove =========="
    time snarkjs groth16 prove ssz_test_0001.zkey witness_ssz_test.wtns proof_ssz_test.json public_ssz_test.json

    echo "========== Step7: groth16 verify =========="
    time snarkjs groth16 verify verification_ssz_test_key.json public_ssz_test.json proof_ssz_test.json

    echo "========== Step8: groth16 rapidsnark prove =========="
    time ../../groth16/rapidsnark/build/prover ssz_test_0001.zkey witness_ssz_test.wtns proof_ssz_test.json public_ssz_test.json

    echo "========== Step9: groth16 verify =========="
    time snarkjs groth16 verify verification_ssz_test_key.json public_ssz_test.json proof_ssz_test.json

    popd
}

main
