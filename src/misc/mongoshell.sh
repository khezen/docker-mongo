#!/bin/bash
mongoshell="mongo"
if [ "$AUTH" == "y" ] && [ -f /data/db/.metadata/.admin_created ];then
  mongoshell="$mongoshell -u $ADMIN_USER -p $ADMIN_PWD --authenticationDatabase"
fi
echo $mongoshell
