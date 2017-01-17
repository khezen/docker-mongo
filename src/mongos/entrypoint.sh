#!/bin/bash

set -m

# BUILD CMD FROM ENV VARIABLES
/run/mongos/start.sh &
run/misc/wait_until_started.sh
# PERF TWEAK
/run/misc/perf.sh

# CONFIGURE AUTHENTICATION
if [ "$AUTH" == "y" ] && [ ! -f /config/key ]; then
  /run/auth/create_keyfile.sh
  /run/mongos/stop.sh
  /run/misc/wait_until_stopped.sh
  /run/mongos/start.sh &
fi

/run/misc/wait_until_started.sh
/run/mongos/shard/add_shards.sh

/run/mongos/status.sh

fg