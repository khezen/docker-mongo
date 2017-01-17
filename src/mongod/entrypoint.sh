#!/bin/bash

set -m

# BUILD CMD FROM ENV VARIABLES
/run/mongod/start.sh&
/run/misc/wait_until_started.sh

# CONFIGURE REPLICA SET
if [ "$RS_NAME" != "" ]; then
  /run/mongod/replSet/set_master.sh
  if [ "$AUTH" != "y" ]; then
    /run/mongod/replSet/wait_until_rs_configured.sh
    /run/mongod/replSet/add_members.sh
  fi
fi 

# PERF TWEAK
/run/misc/perf.sh

# CREATE DB IF SPECIFIED
/run/auth/create_db.sh

# CONFIGURE AUTHENTICATION
if [ "$AUTH" == "y" ] && [ ! -f /config/key ]; then
  
  /run/auth/create_keyfile.sh
  /run/auth/create_admin.sh
  /run/auth/create_db_owner.sh

  /run/mongod/stop.sh
  /run/misc/wait_until_stopped.sh
  /run/mongod/start.sh &
  /run/misc/wait_until_started.sh

  if [ "$RS_NAME" != "" ]; then
    /run/mongod/replSet/wait_until_rs_configured.sh
    /run/mongod/replSet/add_members.sh
  fi
fi

/run/mongod/status.sh

fg