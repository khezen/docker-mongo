#!/bin/bash
mongoshell=$(/run/cmd/mongoshell.sh)
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    $mongoshell admin --eval "help" >/dev/null 2>&1
    RET=$?
done