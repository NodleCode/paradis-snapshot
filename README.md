# Snapshots
Snapshots from paradis is kept as releases in this repo. Releases are created ad Hoc when needed.

## How to run.
1. Change dit to chain source repo and build the `nodle/chain` docker image
2. Run a local node for testnet: 
        `docker run -v ~/.local/path_to_parachain_data_dir:/data -p 9944:9944 -p 9933:9933 -p30333:30333 -it nodle/chain --chain=eden-testing --base-path=/data --rpc-methods=safe --rpc-cors all --rpc-external -- --rpc-external`.
3. Check your chain at https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer
4. Create an automatic release with `./sync_and_snap.sh`
