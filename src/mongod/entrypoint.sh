#!/bin/bash

set -m

# BUILD CMD FROM ENV VARIABLES
/run/mongod/start.sh&
/run/misc/wait_until_started.sh

# CONFIGURE REPLICA SET
if [ "$RS_NAME" != "" ]; then
  /run/mongod/replSet/init_rs.sh
fi

# CONFIGURE AUTHENTICATION
if [ "$AUTH" == "y" ] && [ ! -f /confif/.admin_created ]; then
  /run/auth/create_admin.sh
fi

# CONFIGURE REPLICA SET
if [ "$RS_NAME" != "" ]; then
  /run/mongod/replSet/set_master.sh
  /run/mongod/replSet/wait_until_rs_configured.sh
  /run/mongod/replSet/add_members.sh
fi

# CREATE DB IF SPECIFIED
/run/auth/create_db.sh
if [ "$AUTH" == "y" ] && [ ! -f /.db_owner_created ]; then
  /run/auth/create_db_owner.sh
  touch /.db_owner_created
fi

# PERF TWEAK
/run/misc/perf.sh

# STATUS
/run/mongod/status.sh

fg
