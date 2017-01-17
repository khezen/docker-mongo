#!/bin/bash

mongoshell=$(/run/misc/mongoshell.sh)
sleep 5
if [ "$RS_NAME" != "" ]; then
  echo $mongoshell admin --eval "rs.status()"
  $mongoshell admin --eval "rs.status()"
fi
