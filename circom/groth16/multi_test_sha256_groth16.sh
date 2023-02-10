#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

"$SCRIPT_DIR"/test_sha256_groth16.sh 65536 25

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 32768 24

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 16384 23

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 8192 22

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 4096 21

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 2048 20

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 1024 19

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 512 19

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 256 18

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 128 17

sleep 1

"$SCRIPT_DIR"/test_sha256_groth16.sh 64 16
