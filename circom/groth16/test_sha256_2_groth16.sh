#!/bin/bash

set -x
set -e
TEST=sha256_2_test

function main() {
    pushd ../circuits/${TEST}

    echo "========== Step1: compile circom  =========="
    time circom ${TEST}.circom --r1cs --sym --c

    echo "========== Step2: generate witness =========="
    cd ${TEST}_cpp
    time make
    cd ..
    time ${TEST}_cpp/${TEST} input.json witness.wtns

    echo "========== Step3: setup =========="
    time snarkjs groth16 setup ${TEST}.r1cs ../../setup/tau/powersOfTau28_hez_final_19.ptau ${TEST}_0000.zkey

    echo "========== Step4: contribute to the phase 2 of the ceremony =========="
    time echo 1 | snarkjs zkey contribute ${TEST}_0000.zkey ${TEST}_0001.zkey --name="1st Contributor Name" -v

    echo "========== Step5: export the verification key =========="
    time snarkjs zkey export verificationkey ${TEST}_0001.zkey verification_key.json

    echo "========== Step6: groth16 prove =========="
    time snarkjs groth16 prove ${TEST}_0001.zkey witness.wtns proof.json public.json

    echo "========== Step7: groth16 verify =========="
    time snarkjs groth16 verify verification_key.json public.json proof.json

    echo "========== Step8: groth16 rapidsnark prove =========="
    time ../../groth16/rapidsnark/build/prover ${TEST}_0001.zkey witness.wtns proof.json public.json

    echo "========== Step9: groth16 verify =========="
    time snarkjs groth16 verify verification_key.json public.json proof.json

    popd
}

main
