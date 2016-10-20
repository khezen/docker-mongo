#!bin/bash

set -m

# BUILD CMD FROM ENV VARIABLES
cmd=$(/run/cmd/generate_cmd.sh)
echo $cmd
$cmd &

/run/miscellaneous/wait_until_started.sh

# CONFIGURE REPLICA SET
if [ "$rs_name" != "" ]; then
  /run/replSet/set_master.sh
  if [ "$auth" != "y" ]; then
    slepp 5
    /run/replSet/add_members.sh
  fi
fi 

# PERF TWEAK
/run/miscellaneous/perf.sh

# CONFIGURE AUTHENTICATION
if [ "$auth" == "y" ] && [ ! -f "$dbpath"/.auth_set ]; then

  /run/auth/create_admin.sh
  /run/auth/create_keyfile.sh

  mongo -u $admin_user -p $admin_pwd admin --eval "db.shutdownServer()"
  sleep 5
  cmd="$cmd --keyFile /data/db/config/key"
  echo $cmd
  $cmd &

  if [ "$config_servers" == "" ]; then
    /run/miscellaneous/wait_until_started.sh
    /run/auth/create_db_owner.sh
    if [ "$rs_name" != "" ]; then
      /run/replSet/add_members.sh
    fi
  fi
fi

# CONFIGURE SHARDED CLUSTER
if [ "$config_servers" != "" ]; then
  /run/miscellaneous/wait_until_started.sh
  /run/shard/add_shards.sh
fi

/run/miscellaneous/status.sh

fg   