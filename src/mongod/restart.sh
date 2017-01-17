#!/bin/bash

/run/mongod/stop.sh
/run/misc/wait_until_stopped.sh
/run/mongod/start.sh