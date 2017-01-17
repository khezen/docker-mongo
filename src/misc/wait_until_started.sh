#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    echo $mongoshell admin --eval "help" >/dev/null 2>&1
    $mongoshell admin --eval "help" >/dev/null 2>&1
    RET=$?
done