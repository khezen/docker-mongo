#!/bin/bash
mongoshell="mongo"
if [ "$auth" == "y" ] && [ -f /config/.admin_created ];then
  mongoshell="$mongoshell -u $admin_user -p $admin_pwd --authenticationDatabase admin"
fi
echo $mongoshell