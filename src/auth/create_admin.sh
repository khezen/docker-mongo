#!/bin/bash
if [ ! -f "$dbpath"/.admin_created ]; then
    echo mongo admin --eval "db.createUser({user: '$admin_user', pwd: '$admin_pwd', roles:[{role: 'root', db: 'admin'}]});"
    mongo admin --eval "db.createUser({user: '$admin_user', pwd: '$admin_pwd', roles:[{role: 'root', db: 'admin'}]});"
    touch "$dbpath"/.admin_created
fi
