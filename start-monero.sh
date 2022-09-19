#!/bin/sh
#DATA_LOC="/media/SEAGATE/CRYPTO/monero/BLOCKCHAIN/"
#DATA_LOC="$HOME/.local/share/monero/BLOCKCHAIN/"
DATA_LOC="/media/SEAGATE/CRYPTO/monero/BLOCKCHAIN2/"
WALLET_LOC="$HOME"/.local/wallets/monero/myWallet/myWallet

#add this in /etc/security/limits.conf
# $USER hard memlock 2048
# $USER soft memlock 2048

#ulimit -l 2048

#monerod --data-dir "$DATA_LOC" --mining-threads 3 --detach 
#sleep 60

if [ "$1" = "-w" ]; then
    monero-wallet-cli --wallet-file "$WALLET_LOC" 
elif [ "$1" = "-i" ]; then 
    mkdir -p "$DATA_LOC"
    ulimit -l 2048
    monerod --data-dir "$DATA_LOC" --prune-blockchain --max-concurrency=4 --detach
    #monerod --data-dir "$DATA_LOC" --db-salvage
    echo "sleeping..."
    sleep 1200 
    echo "Wallet started."
else 
    echo "-i  -> initialize, set ulimits and start monerod"
    echo "-w  -> open wallet in cli"
fi

