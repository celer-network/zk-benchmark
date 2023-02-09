#!/bin/bash

if [ $# -ne 1 ]; then
  echo "tau_rank required"
  exit 1
fi

SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
CIRCUIT_DIR=${SCRIPT_DIR}"/../circuits/sha256_test"
TAU_RANK=$1
TAU_DIR=${SCRIPT_DIR}"/../setup/tau"
TAU_FILE="${TAU_DIR}/powersOfTau28_hez_final_${TAU_RANK}.ptau"

if [ ! -f "$TAU_FILE" ]; then
  wget -P "$TAU_DIR" https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_${TAU_RANK}.ptau
fi

pushd "$CIRCUIT_DIR" || exit
snarkjs groth16 setup sha256_test.r1cs ${TAU_FILE} sha256_test_0000.zkey
echo 1 | snarkjs zkey contribute sha256_test_0000.zkey sha256_test_0001.zkey --name='Celer' -v
snarkjs zkey export verificationkey sha256_test_0001.zkey verification_key.json
popd || exit