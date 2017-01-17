#!/bin/bash
mongoshell="mongo"
if [ "$AUTH" == "y" ] && [ -f /config/key ];then
  mongoshell="$mongoshell -u $ADMIN_USER -p $ADMIN_PWD --authenticationDatabase"
fi
echo $mongoshell