#!/bin/bash
mongoshell="mongo"
if [ "$auth" == "y" ];then
  mongoshell="$mongoshell -u $admin_user -p $admin_pwd --authenticationDatabase admin"
fi
echo $mongoshell