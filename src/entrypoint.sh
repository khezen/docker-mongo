#!bin/bash

set -m

cmd=""

# MONGOS
if [ "$config_servers" != "" ]; then 
  mkdir -p $dbpath
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

# MONGOD
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

if [ "$auth" == "y" ] && [ -f "$dbpath"/.mongodb_password_set ]; then
  cmd="$cmd --keyFile /data/db/config/key"
fi

echo $cmd
$cmd &

/run/wait_until_started.sh

# CONFIGURE REPLICA SET
if [ "$rs_name" != "" ]; then
  /run/set_master.sh
  if [ "$auth" != "y" ]; then
    slepp 5
    /run/add_members.sh
  fi
fi 

/run/perf.sh

# CONFIGURE AUTHENTICATION
if [ "$auth" == "y" ] && [ ! -f "$dbpath"/.auth_set ]; then
  /run/set_auth.sh
  /run/create_keyfile.sh
  if [ "$config_servers" == "" ]; then
    mongod --shutdown
    sleep 5
    cmd="$cmd --keyFile /data/db/config/key"
    echo $cmd
    $cmd &
    /run/wait_until_started.sh
    if [ "$rs_name" != "" ]; then
      sleep 5
      /run/add_members.sh
    fi
  else
    mongo -u $admin_user -p $admin_pwd admin --eval "db.shutdownServer()"
    sleep 5
    cmd="$cmd --keyFile /data/db/config/key"
    echo $cmd
    $cmd &
  fi
fi

# CONFIGURE SHARDED CLUSTER
if [ "$config_servers" != "" ]; then
  sleep 20
  /run/add_shards.sh
fi

/run/status.sh

fg   