#!/bin/bash
mongoshell=$(/run/misc/mongoshell.sh)
if [ ! -f /config/.db_owner_created ] && [ "$DB_NAME" != "" ] && [ "$CONFIG_SERVERS" == "" ]; then
    echo $mongoshell --eval "db.createUser({user: '$DB_USER', pwd: '$DB_PWD', roles:[{role: 'dbOwner', db: '$DB_NAME'}]});" $DB_NAME
    $mongoshell admin --eval "db.createUser({user: '$DB_USER', pwd: '$DB_PWD', roles:[{role: 'dbOwner', db: '$DB_NAME'}]});" $DB_NAME
    touch /config/.db_owner_created
fi
