#!/bin/bash

if [ $# -ne 2 ]; then
  echo "input_size and tau_rank required"
  exit 1
fi
set -x
set -e
SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
CIRCUIT_DIR=${SCRIPT_DIR}"/../circuits/sha256_test"
TIME=(/usr/bin/time -f "mem %M\ntime %e\ncpu %P")
RAPID_SNARK_PROVER=${SCRIPT_DIR}"/rapidsnark/build/prover"
INPUT_SIZE=$1
TAU_RANK=$2
TAU_DIR=${SCRIPT_DIR}"/../setup/tau"
TAU_FILE="${TAU_DIR}/powersOfTau28_hez_final_${TAU_RANK}.ptau"

function renderCircom() {
  pushd "$CIRCUIT_DIR"
  sed -i "s/Main([0-9]*)/Main($INPUT_SIZE)/" sha256_test.circom
  popd
}

function compile() {
  pushd "$CIRCUIT_DIR"
  circom sha256_test.circom --r1cs --sym --c
  cd sha256_test_cpp
  make
  popd
}

function setup() {
  if [ ! -f "$TAU_FILE" ]; then
    wget -P "$TAU_DIR" https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_${TAU_RANK}.ptau
  fi
  "${TIME[@]}" "$SCRIPT_DIR"/trusted_setup.sh "$TAU_RANK"
# snarkjs groth16 setup sha256_test.r1cs ${TAU_FILE} sha256_test_0000.zkey
# echo 1 | snarkjs zkey contribute sha256_test_0000.zkey sha256_test_0001.zkey --name='Celer' -v
# snarkjs zkey export verificationkey sha256_test_0001.zkey verification_key.json
  prove_key_size=$(du -h "$CIRCUIT_DIR"/sha256_test_0001.zkey | cut -f1)
  verify_key_size=$(du -h "$CIRCUIT_DIR"/verification_key.json | cut -f1)
  echo "Prove key size: $prove_key_size"
  echo "Verify key size: $verify_key_size"
}

function generateWtns() {
  pushd "$CIRCUIT_DIR"
  "${TIME[@]}" sha256_test_cpp/sha256_test input_${INPUT_SIZE}.json witness.wtns
  #"${TIME[@]}" node sha256_test_js/generate_witness.js sha256_test_js/sha256_test.wasm input_${INPUT_SIZE}.json witness.wtns
  popd
}

avg_time() {
    #
    # usage: avg_time n command ...
    #
    n=10; shift
    (($# > 0)) || return                   # bail if no command given
    for ((i = 0; i < n; i++)); do
        { "${TIME[@]}" "$@" &>/dev/null; } 2>&1 # ignore the output of the command
                                           # but collect time's output in stdout
    done | awk '
        /mem/ { mem = mem + $2; nm++ }
        /time/ { time = time + $2; nt++ }
        /cpu/  { cpu  = cpu  + $2; nc++}
        END    {
                 if (nm>0) printf("mem %f\n", mem/nm);
                 if (nt>0) printf("time %f\n", time/nt);
                 if (nc>0) printf("cpu %f\n",  cpu/nc)
               }'
}

function normalProve() {
  pushd "$CIRCUIT_DIR"
  avg_time 10 snarkjs groth16 prove sha256_test_0001.zkey witness.wtns proof.json public.json
#  "${TIME[@]}" snarkjs groth16 prove sha256_test_0001.zkey witness.wtns proof.json public.json
  proof_size=$(du -h proof.json | cut -f1)
  echo "Proof size: $proof_size"
  popd
}

function rapidProve() {
  pushd "$CIRCUIT_DIR"
  "${TIME[@]}" "$RAPID_SNARK_PROVER" sha256_test_0001.zkey witness.wtns proof.json public.json
  proof_size=$(du -h proof.json | cut -f1)
  echo "Proof size: $proof_size"
  popd
}

function verify() {
  pushd "$CIRCUIT_DIR"
  "${TIME[@]}" snarkjs groth16 verify verification_key.json public.json proof.json
  popd
}

echo "========== Step0: render circom  =========="
renderCircom

echo "========== Step1: compile circom  =========="
compile

echo "========== Step2: setup =========="
setup

echo "========== Step3: generate witness  =========="
generateWtns

echo "========== Step4: prove  =========="
normalProve

echo "========== Step5: verify  =========="
verify

echo "========== Step6: rapid prove  =========="
rapidProve

echo "========== Step5: verify  =========="
verify
