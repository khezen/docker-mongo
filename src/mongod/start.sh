#!/bin/bash
cmd=$(/run/mongod/mongod.sh)
echo $cmd
$cmd
