#!/bin/bash
mongod --shutdown
/run/miscellaneous/wait_until_stopped.sh
cmd="$1 --keyFile /config/key"
echo $cmd
$cmd