#!/bin/bash
cmd=$(/run/mongos/mongos.sh)
echo $cmd
$cmd
