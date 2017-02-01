#!/bin/bash

set -m

# BUILD CMD FROM ENV VARIABLES
/run/mongos/start.sh &
run/misc/wait_until_started.sh

# ADD SHARDS
/run/mongos/shard/add_shards.sh

# PERF TWEAK
/run/misc/perf.sh

# STATUS
/run/mongos/status.sh

fg
