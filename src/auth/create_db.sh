#!/bin/bash
if [ ! -f /data/db/.metadata/.db_created ] && [ "$DB_NAME" != "" ] && [ "$CONFIG_SERVERS" == "" ]; then
    mongoshell=$(/run/misc/mongoshell.sh)
    echo  $mongoshell admin --eval "db" $DB_NAME
    $mongoshell admin --eval "db" $DB_NAME
    touch /data/db/.metadata/.db_created
fi
