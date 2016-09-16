#!/bin/bash

echo "Creating user in MongoDB..."
mongo admin --eval "db.createUser({user: '$ADMIN_USER', pwd: '$ADMIN_PASS', roles:[{role: 'root', db: 'admin'}]});"
if [ "$DATABASE" != "" ]; then
mongo admin -u "$ADMIN_USER" -p "$ADMIN_PASS" << EOF
use $DATABASE
db.createUser({user: '$DB_USER', pwd: '$DB_PASS', roles:[{role: 'dbOwner', db: '$DATABASE'}]})
EOF
fi

echo "MongoDB configured."
touch "$DBPATH"/.mongodb_password_set
