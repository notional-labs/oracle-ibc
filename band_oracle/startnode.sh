#!/bin/bash

WALLET_NAME=relayerAccount
CHAIN_ID=band-testing

rm -rf $HOME/.band

cd $HOME

bandd init testing --chain-id=$CHAIN_ID --home=$HOME/.band
bandd keys add $WALLET_NAME --home=$HOME/.band --recover --hd-path "m/44'/118'/0'/0/0"
bandd add-genesis-account $(bandd keys show $WALLET_NAME -a --home=$HOME/.band) 1000000000uband --home=$HOME/.band
bandd gentx $WALLET_NAME 500000000uband --home=$HOME/.band --chain-id=$CHAIN_ID
bandd collect-gentxs --home=$HOME/.band
bandd start --home=$HOME/.band
