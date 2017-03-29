#!/bin/bash
if [ ! -f /data/db/.metadata/.admin_created ]; then
    echo mongo admin --eval "db.createUser({user: '$ADMIN_USER', pwd: '$ADMIN_PWD', roles:[{role: 'root', db: 'admin'}]});"
    mongo admin --eval "db.createUser({user: '$ADMIN_USER', pwd: '$ADMIN_PWD', roles:[{role: 'root', db: 'admin'}]});"
    touch /data/db/.metadata/.admin_created
fi
