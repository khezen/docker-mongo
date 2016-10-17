#!/bin/bash
echo "Creating user in MongoDB..."
mongo admin --eval "db.createUser({user: '$admin_user', pwd: '$admin_pwd', roles:[{role: 'root', db: 'admin'}]});"
if [ "$database" != "" ]; then
mongo admin -u "$admin_user" -p "$admin_pwd" << EOF
use $database
db.createUser({user: '$db_user', pwd: '$db_pwd', roles:[{role: 'dbOwner', db: '$database'}]})
EOF
fi
mkdir -p /data/db/config
touch /data/db/config/key
echo $admin_pwd > /data/db/config/key
chmod 600 /data/db/config/key

echo "MongoDB configured."
touch "$dbpath"/.mongodb_password_set
