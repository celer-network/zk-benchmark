#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO_DIR=$DIR/".."
CIRCUIT_DIR=$REPO_DIR"/circuits/sha256_test"
SETUP_DIR=$REPO_DIR"/setup/key"
KEY_RANK=22
SETUP_MK=${SETUP_DIR}/setup_2^${KEY_RANK}.key
SETUP_LK=${SETUP_DIR}/setup_2^${KEY_RANK}_lagrange.key
DOWNLOAD_SETUP_FROM_REMOTE=false
PLONKIT_BIN=$DIR"/plonkit/target/release/plonkit"
DUMP_LAGRANGE_KEY=false

echo "Step0: check for necessary dependencies: node,npm,axel"
PKG_PATH=""
PKG_PATH=$(command -v npm)
echo Checking for npm
if [ -z "$PKG_PATH" ]; then
  echo "npm not found. Installing nvm & npm & node."
  source <(curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh)
else
  echo npm exists at $PKG_PATH
fi
PKG_PATH=""
PKG_PATH=$(command -v axel)
if ($DOWNLOAD_SETUP_FROM_REMOTE & [ -z "$PKG_PATH" ]) ; then
  echo Checking for axel
  echo "axel not found. Installing axel."
  sudo apt-get --yes install axel
elif [ ! -z "$PKG_PATH" ] ; then
  echo axel exists at $PKG_PATH
fi

echo "Step1: build plonkit binary"
#cargo build --release
#cargo install --git https://github.com/fluidex/plonkit
#$PLONKIT_BIN --help

echo "Step2: universal setup"
pushd $SETUP_DIR
if ([ ! -f $SETUP_MK ] & $DOWNLOAD_SETUP_FROM_REMOTE); then
  # It is the aztec ignition trusted setup key file. Thanks to matter-labs/zksync/infrastructure/zk/src/run/run.ts
  axel -ac https://universal-setup.ams3.digitaloceanspaces.com/setup_2^$KEY_RANK.key -o $SETUP_MK || true
elif [ ! -f $SETUP_MK ] ; then
    $PLONKIT_BIN setup --power $KEY_RANK --srs_monomial_form $SETUP_MK --overwrite
fi
popd

echo "Step3: compile circuit and calculate witness"
#snarkit2 check $CIRCUIT_DIR --witness_type bin --backend wasm
circom $CIRCUIT_DIR/sha256_test.circom --r1cs --sym -c
pushd $CIRCUIT_DIR/sha256_test_cpp
make
./sha256_test ../input.json ../witness.wtns
popd

echo "Step4: export verification key"
$PLONKIT_BIN export-verification-key -m $SETUP_MK -c $CIRCUIT_DIR/sha256_test.r1cs -v $CIRCUIT_DIR/vk.bin --overwrite

echo "Step5: generate verifier smart contract"
$PLONKIT_BIN generate-verifier -v $CIRCUIT_DIR/vk.bin -s $CIRCUIT_DIR/verifier.sol --overwrite #-t contrib/template.sol

if [ "$DUMP_LAGRANGE_KEY" = false ]; then
  echo "Step6: prove with key_monomial_form"
  $PLONKIT_BIN prove -m $SETUP_MK -c $CIRCUIT_DIR/sha256_test.r1cs -w $CIRCUIT_DIR/witness.wtns -p $CIRCUIT_DIR/proof.bin -j $CIRCUIT_DIR/proof.json -i $CIRCUIT_DIR/public.json --overwrite
else
  echo "Step6.1: dump key_lagrange_form from key_monomial_form"
  $PLONKIT_BIN dump-lagrange -m $SETUP_MK -l $SETUP_LK -c $CIRCUIT_DIR/sha256_test.r1cs --overwrite
  echo "Step6.2: prove with key_monomial_form & key_lagrange_form"
  $PLONKIT_BIN prove -m $SETUP_MK -l $SETUP_LK -c $CIRCUIT_DIR/sha256_test.r1cs -w $CIRCUIT_DIR/witness.wtns -p $CIRCUIT_DIR/proof.bin -j $CIRCUIT_DIR/proof.json -i $CIRCUIT_DIR/public.json --overwrite
fi

echo "Step7: verify"
$PLONKIT_BIN verify -p $CIRCUIT_DIR/proof.bin -v $CIRCUIT_DIR/vk.bin
