#!/bin/bash
if [ ! -f /config/.admin_created ]; then
    echo mongo admin --eval "db.createUser({user: '$admin_user', pwd: '$admin_pwd', roles:[{role: 'root', db: 'admin'}]});"
    mongo admin --eval "db.createUser({user: '$admin_user', pwd: '$admin_pwd', roles:[{role: 'root', db: 'admin'}]});"
    touch /config/.admin_created
fi
