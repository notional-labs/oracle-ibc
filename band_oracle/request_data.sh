#!/bin/bash

ORACLE_ID=1

bandd tx oracle request $ORACLE_ID 1 1 \
-c 000000090000000345544800000004555344430000000344414900000004555344540000000442555344000000044c494e4b00000003554e49000000045742544300000004434f4d50000000003b9aca00 \
-m client-id --from fundingAccount -y --chain-id band-testing --fee-limit=250000uband --gas 1000000
