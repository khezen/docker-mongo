#!/bin/bash

/run/mongos/stop.sh
/run/misc/wait_until_stopped.sh
/run/mongos/start.sh