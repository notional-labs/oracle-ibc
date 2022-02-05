#!/bin/bash

TXHASH=$(bandd tx oracle create-oracle-script \
    --schema "{symbols:[string],multiplier:u64}/{rates:[u64]}" \
    --name "Band Standard Dataset" \
    --description "Band Standard Dataset" \
    --script "./Band_Standard_Dataset/target/wasm32-unknown-unknown/release/band_standard_dataset.wasm" \
    --from relayerAccount \
    --owner $(bandd keys show relayerAccount -a) \
    --node http://localhost:26657 \
    --chain-id band-testing \
    --gas auto \
    --keyring-backend test \
    -y \
    -o json | jq -r .txhash)
    
echo $TXHASH

sleep 5s

ORACLE_ID=$(bandd query tx "$TXHASH" -o json | jq -r .raw_log | jq -r .[0].events[0].attributes[0].value)

echo "ORACLE ID = $ORACLE_ID"
