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
    /run/miscellaneous/restart.sh "$cmd" &
    if [ "$RS_NAME" != "" ]; then
      /run/miscellaneous/wait_until_started.sh
      /run/replSet/wait_until_rs_configured.sh
      /run/replSet/add_members.sh
    fi
  else
   /run/miscellaneous/restart.sh "$cmd" &
  fi
fi

/run/miscellaneous/wait_until_started.sh

# CONFIGURE SHARDED CLUSTER
if [ "$CONFIG_SERVERS" != "" ]; then
  /run/shard/add_shards.sh
fi
/run/miscellaneous/status.sh

fg