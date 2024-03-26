# Snapshots

Snapshots from paradis is kept as releases in this repo.

## How to run.
1. Change dit to chain source repo and build the `nodle/chain` docker image
2. Run it: 
        `docker run -v ~/.local/path_to_parachain_data_dir:/data -p 9944:9944 -p 9933:9933 -p30333:30333 -it nodle/chain --chain=eden-testing --base-path=/data --rpc-methods=safe --rpc-cors all --rpc-external -- --rpc-external`.

