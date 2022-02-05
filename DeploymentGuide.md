# oracle-ibc this is solution for band ibc challenge

## Resources
- [ts-relayer](https://github.com/confio/ts-relayer)
- [Juno](https://github.com/CosmosContracts/juno)
- [cw-plus](https://github.com/CosmWasm/cw-plus)
- [Cosmwasm](https://docs.cosmwasm.com/docs/0.14/getting-started/installation/)
- [Juno Discord](https://discord.gg/V9nEY4Ca)
- [Band chain](https://github.com/bandprotocol/chain)


### Setup localtestnet bandchain 
- First Setup a localtestnet of bandchain: Guide here
### Instance the contract
- I've stored my contract in Juno mainnet, you instance it by command
```
junod tx wasm instantiate 52 '{"default_timeout": 50}' --amount 5000ujuno --fees 20000ujuno  --gas 20000000 --label "JUNO BOUNTY FROM VUONG" --from {your-key} --chain-id juno-1 -y --node {mainnet-node}
```
The output should be something like this:
```
gas estimate: 176757
code: 0
codespace: ""
data: ""
events: []
gas_used: "0"
gas_wanted: "0"
height: "0"
info: ""
logs: []
raw_log: '[]'
timestamp: ""
tx: null
txhash: 50685F29A0B753D78B73CE118447E7587B8D63BF6822A2B9174DEF23F944E1F2
```
We can now query the transaction and return the address of the instantiated contract using the following command:
```
ADDRESS=$(junod query tx {YOUR_TX_HASH_HERE}  --output json --node {YOUR_NODE} | jq -r '.logs[0].events[-1].attributes[0].value')
```
Remember your address, we need it in next step.

### Setup a relayer from juno mainnet to band local testnet  
- Use ts-relayer to relay packet
- Follow this [tutorial](https://github.com/confio/ts-relayer)  to install the ts-relayer. 
```
ibc-setup init --src oysternet --dest nyancat
```
- This command will most likely produce an error but not to worry as it doesn't matter. Go to the $HOME/.ibc-setup folder and change `oysternet` to `juno` and `nyancat` to `band`. 
- Next step add your relayer accounts, use memonic in app.toml
```
junod keys add relayerAccount --recover
```
Similar to band 
```
bandd keys add relayerAccount --recover --hd-path "m/44'/118'/0'/0/0" 
```
Don't forget fund your relayer to relay

- We create a connection between two chain (juno-1 & band-tesing)
```
ibc-setup connect
```
- Create your channel
```
ibc-setup channel --src-port wasm.{YOUR_CONTRACT_ADDRESS}  --dest-port oracle --version bandchain-1
```
- Now open registry.yaml and delete the contents of the file and paste this data:
NOTE remember the contract we deployed and instantiated get it's address and paste it in the ics20_port value so it should look something like this: wasm.juno18dtz528nsjls4xlsf2p5t37udgzv7sgz4yumjyds743sd4f3tr5sg2nju4

```
version: 1

chains:
  band-testing:
    chain_id: band-testing
    prefix: band
    gas_price: 0.2uband
    hd_path: m/44'/118'/0'/0/0
    ics20_port: 'oracle'
    rpc:
      - {YOUR_LOCALTESTNET_RPC_HERE}
  juno:
    chain_id: juno-1
    prefix: juno
    gas_price: 0.01ujuno
    hd_path: m/44'/118'/0'/0/0
    ics20_port: 'wasm.YOUR_CONTRACT_HERE'
    rpc:
      - https://rpc.juno.giansalex.dev:443
```
- Start relaying
```
ibc-relayer start --poll 5
```

#### Execute contract
- Query your channel by command
```
junod query wasm contract-state smart YOUR_CONTRACT_ADDRESS_HERE '{"list_channels": {}}' --chain-id juno-1 --node  https://rpc.juno.giansalex.dev:443
```
Got result like that :
```
data:
  channels:
  - connection_id: connection-72
    counterparty_endpoint:
      channel_id: channel-5
      port_id: oracle
    id: channel-51
```
In that case, YOUR_CHANNEL is `channel-51`

Now you can execute by command :
```
export EXECUTE='{"oracle_request": {"contract": "YOUR_CONTRACT_ADDRESS", "client_id": "client_id", "oracle_script_id":1, "channel":"YOUR_CHANNEL", "call_data":"000000090000000345544800000004555344430000000344414900000004555344540000000442555344000000044c494e4b00000003554e49000000045742544300000004434f4d50000000003b9aca00","ask_count":1, "min_count":1, "denom":"uband"}}'

junod tx wasm execute "YOUR_CONTRACT_ADDRESS "$EXECUTE" --gas 10000000 --fees 100000ujuno --chain-id juno-1 --node https://rpc.juno.giansalex.dev:443 --from {your_key} --amount 900ujuno -y  
```

###Proof of query oracle data over ibc
- Packet receive in tx : [mintscan](https://www.mintscan.io/juno/txs/0419C27A42844342E56EA82C70D44611E3A2D299808BD523220CD61BDE619778)
- Execute contract : [mintscan](https://www.mintscan.io/juno/txs/E9F4F8C7AA3F8D287D8C199540CF90E25E6A459A8A49E5ACF78FEF93CD7DAB1F)



