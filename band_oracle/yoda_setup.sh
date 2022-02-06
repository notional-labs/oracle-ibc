#!/bin/bash

WALLET_NAME=fundingAccount
CHAIN_ID=band-testing

rm -rf ~/.yoda # clear old config if exist
yoda config chain-id $CHAIN_ID
yoda config node http://localhost:26657
yoda config broadcast-timeout "5m"
yoda config rpc-poll-interval "1s"
yoda config max-try 5
yoda config validator $(bandd keys show $WALLET_NAME -a --bech val)

yoda keys add reporter1
yoda keys add reporter2

export EXECUTOR_URL=https://jpm93jna7k.execute-api.ap-southeast-1.amazonaws.com/default/band_function
yoda config executor "rest:${EXECUTOR_URL}?timeout=10s"

yoda run
