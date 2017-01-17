#!/bin/bash
if [ ! -f /config/.db_created ] && [ "$DB_NAME" != "" ] && [ "$CONFIG_SERVERS" == "" ]; then
    mongoshell=$(/run/misc/mongoshell.sh)
    echo  $mongoshell $DB_NAME --eval "db"
    $mongoshell $DB_NAME --eval "db"
    touch /config/.db_created
fi