#!/bin/bash

WALLET_NAME=relayerAccount
CHAIN_ID=band-testing

rm -rf $HOME/.band

cd $HOME

bandd init --chain-id=$CHAIN_ID testing --home=$HOME/.band
bandd keys add $WALLET_NAME --keyring-backend=test --home=$HOME/.band --recover
bandd add-genesis-account $(bandd keys show $WALLET_NAME -a --keyring-backend=test --home=$HOME/.band) 1000000000uband --home=$HOME/.band
bandd gentx $WALLET_NAME 500000000uband --keyring-backend=test --home=$HOME/.band --chain-id=$CHAIN_ID
bandd collect-gentxs --home=$HOME/.band

bandd start --home=$HOME/.band
