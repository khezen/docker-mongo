#!/bin/bash
if [ ! -f "$dbpath"/.db_owner_created ] && [ "$database" != "" ] && [ "$config_servers" == "" ]; then
    echo mongo admin -u $admin_user -p $admin_pwd --eval "db.createUser({user: '$db_user', pwd: '$db_pwd', roles:[{role: 'dbOwner', db: '$database'}]});"
    mongo admin -u $admin_user -p $admin_pwd --eval "db.createUser({user: '$db_user', pwd: '$db_pwd', roles:[{role: 'dbOwner', db: '$database'}]});"
    touch "$dbpath"/.db_owner_created
fi
