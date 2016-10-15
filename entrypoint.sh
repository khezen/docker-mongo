#!bin/bash

set -m

cmd=""

if [ "$config_servers" != "" ]; then 
  cmd="mongos --port 27017 --configdb"

  concat_servers=""
for config_server in $config_servers; do
      if [ "$concat_servers" == "" ]; then
          concat_servers="$config_server"
      else
          concat_servers="$concat_servers,$config_server"
      fi
  done

  cmd="$cmd $concat_servers"

else
  cmd="mongod --storageEngine $storage_engine --port 27017"

  if [ "$shardsvr" == "y" ]; then
    cmd="$cmd --shardsvr"
  fi

  if [ "$rs_name" != "" ]; then
    cmd="$cmd --replSet $rs_name"
  fi

  if [ "$dbpath" != "" ]; then
    mkdir -p "$dbpath"
    cmd="$cmd --dbpath $dbpath"
  fi

  if [ "$oplog_size" != "" ]; then
    cmd="$cmd --oplogSize $oplog_size"
  fi

  if [ "$configsvr" == "y" ]; then
    cmd="$cmd --configsvr"
  fi
fi

$cmd &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

if [ ! -f "$dbpath"/.mongodb_replSet_set ] && [ "$rs_name" != "" ]; then
  /configure_rs.sh
fi 

if [ ! -f /.mongodb_cluster_set ] && [ "$config_servers" != "" ]; then
  /configure_cluster.sh
fi

mongo --eval "db.getSibling)bnDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
mongo --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"

if [ "$auth" == "y" ]; then
  if [ ! -f "$dbpath"/.mongodb_password_set ]; then
    /set_auth.sh
  fi
  cmd="$cmd --auth"
  #Smongod --shutdown
  #mongo --eval "db.getSiblingDB('admin').shutdownServer()"
  #cmd &
fi

fg   