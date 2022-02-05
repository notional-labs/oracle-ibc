#!/bin/bash

TXHASH_1=$(bandd tx oracle create-data-source \
	--name "CoinMarketCap" \
    --fee 250000uband \
    --description "CoinMarketCap" \
    --script CoinMarketCap.py \
    --from relayerAccount \
    --owner $(bandd keys show relayerAccount -a) \
    --treasury $(bandd keys show relayerAccount -a) \
    --node http://localhost:26657 \
    --chain-id band-testing \
    --gas auto \
    -y \
    -o json | jq -r .txhash)

echo $TXHASH_1

sleep 5s
    
TXHASH_2=$(bandd tx oracle create-data-source \
	--name "CoinGecko" \
    --fee 250000uband \
    --description "CoinGecko" \
    --script CoinGecko.py \
    --from relayerAccount \
    --owner $(bandd keys show relayerAccount -a) \
    --treasury $(bandd keys show relayerAccount -a) \
    --node http://localhost:26657 \
    --chain-id band-testing \
    --gas auto \
    -y \
    -o json | jq -r .txhash)
    
echo $TXHASH_2

sleep 5s

DATA_ID_1=$(bandd query tx "$TXHASH_1" -o json | jq -r .raw_log | jq -r .[0].events[0].attributes[0].value)

echo "CoinMarketCap_DATA_ID = $DATA_ID_1"

sleep 5s

DATA_ID_2=$(bandd query tx "$TXHASH_2" -o json | jq -r .raw_log | jq -r .[0].events[0].attributes[0].value)

echo "CoinGecko_DATA_ID = $DATA_ID_2"
