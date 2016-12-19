#!/bin/bash
mongoshell=$(/run/cmd/mongoshell.sh)
if [ ! -f /config/.db_created ] && [ "$DB_NAME" != "" ] && [ "$CONFIG_SERVERS" == "" ]; then
    echo  $mongoshell $DB_NAME --eval "db"
    $mongoshell $DB_NAME --eval "db"
    touch /config/.db_created
fi