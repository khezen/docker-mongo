#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
RET=0
while [[ RET -eq 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service shutdown"
    sleep 5
    $mongoshell admin --eval "help" >/dev/null 2>&1
    RET=$?
done