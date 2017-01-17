#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
state=0
while [ "$state" != "1" ] && [ "$state" != "2" ]; do
    echo "=> Waiting replica set to be configured"
    sleep 5
    echo $mongoshell admin --eval "rs.status().myState;"
    result=$($mongoshell admin --eval "rs.status().myState;")
    state="${result: -1}"
done