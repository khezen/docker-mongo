#!/bin/bash

mongoshell="mongo"
if [ "$auth" == "y" ];then
  mongoshell="$mongoshell -u $admin_user -p $admin_pwd --authenticationDatabase admin"
fi

if [ "$rs_name" != "" ]; then
  sleep 5
  echo $mongoshell --eval "rs.status()"
  $mongoshell --eval "rs.status()"
fi

if [ "$config_servers" != "" ]; then
  sleep 5
  echo $mongoshell --eval "sh.status()"
  $mongoshell --eval "sh.status()"
fi