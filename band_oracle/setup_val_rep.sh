#!/bin/bash

WALLET_NAME=fundingAccount
CHAIN_ID=band-testing

bandd tx multi-send 1000uband $(yoda keys list -a) --from $WALLET_NAME --chain-id $CHAIN_ID

sleep 5s

bandd tx oracle add-reporters $(yoda keys list -a) --from $WALLET_NAME --chain-id $CHAIN_ID

sleep 5s

bandd tx oracle activate --from $WALLET_NAME --chain-id $CHAIN_ID

sleep 5s

# check state of oracle validator
bandd query oracle validator $(bandd keys show -a $WALLET_NAME --bech val)
