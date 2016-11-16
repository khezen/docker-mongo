#!/bin/bash
if [ ! -f /config/.db_owner_created ] && [ "$DB_NAME" != "" ] && [ "$CONFIG_SERVERS" == "" ]; then
    echo mongo admin -u $ADMIN_USER -p $ADMIN_PWD --eval "db.createUser({user: '$DB_USER', pwd: '$DB_PWD', roles:[{role: 'dbOwner', db: '$DB_NAME'}]});"
    mongo admin -u $ADMIN_USER -p $ADMIN_PWD --eval "db.createUser({user: '$DB_USER', pwd: '$DB_PWD', roles:[{role: 'dbOwner', db: '$DB_NAME'}]});"
    touch /config/.db_owner_created
fi
