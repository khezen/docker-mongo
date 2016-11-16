#!/bin/bash
mongoshell="mongo"
if [ "$AUTH" == "y" ] && [ -f /config/.admin_created ];then
  mongoshell="$mongoshell -u $ADMIN_USER -p $ADMIN_PWD --authenticationDatabase admin"
fi
echo $mongoshell