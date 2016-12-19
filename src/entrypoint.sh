#!bin/bash

set -m

cmd=""

# BUILD CMD FROM ENV VARIABLES
cmd=$(/run/cmd/generate_cmd.sh)
echo $cmd
$cmd &

/run/miscellaneous/wait_until_started.sh

# CONFIGURE REPLICA SET
if [ "$RS_NAME" != "" ]; then
  /run/replSet/set_master.sh
  if [ "$AUTH" != "y" ]; then
    /run/replSet/wait_until_rs_configured.sh
    /run/replSet/add_members.sh
  fi
fi 

# PERF TWEAK
/run/miscellaneous/perf.sh

# CREATE DB IF SPECIFIED
/run/auth/create_db.sh

# CONFIGURE AUTHENTICATION
if [ "$AUTH" == "y" ] && [ ! -f /config/.admin_created ]; then

  /run/auth/create_admin.sh
  /run/auth/create_keyfile.sh

  if [ "$CONFIG_SERVERS" == "" ]; then
    /run/auth/create_db_owner.sh
    mongod --shutdown
    /run/miscellaneous/wait_until_stopped.sh
    cmd="$cmd --keyFile /config/key"
    echo $cmd
    $cmd &
    /run/miscellaneous/wait_until_started.sh
    if [ "$RS_NAME" != "" ]; then
      /run/replSet/wait_until_rs_configured.sh
      /run/replSet/add_members.sh
    fi
  else
    mongo -u $ADMIN_USER -p $ADMIN_PWD admin --eval "db.shutdownServer()"
    /run/miscellaneous/wait_until_stopped.sh
    cmd="$cmd --keyFile /config/key"
    echo $cmd
    $cmd &
  fi
fi

# CONFIGURE SHARDED CLUSTER
if [ "$CONFIG_SERVERS" != "" ]; then
  /run/miscellaneous/wait_until_started.sh
  /run/shard/add_shards.sh
fi

/run/miscellaneous/status.sh

fg