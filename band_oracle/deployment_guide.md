# STEP 1: run node
1. run "bash startnode.sh"

# STEP 2: deploy data source
1. run "bash setup_data_script.sh" to deploy data source to band

# STEP 3: deploy oracle script
1. go into folder Band_Standard_Dataset/src/logic.rs
2. search for this line of code:
[change_data_source](change_data_source.png)

3. change data_source_id according to the output of STEP 1
4. run "RUSTFLAGS='-C link-arg=-s' cargo build --release --target wasm32-unknown-unknown"
5. run "cd .."
6. run "bash setup_oracle_script.sh" and get ORACLE_ID

# STEP 4: set up yoda, reporters and oracle validator
1. run "bash yoda_setup.sh"
2. run "bash setup_val_rep.sh"

# STEP 5: get data
1. modify request_data.sh ORACLE_ID and "-c" flags
2. run "bash request_data.sh"
