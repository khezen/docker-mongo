#!/bin/bash

mongoshell=$(/run/misc/mongoshell.sh)
if [ "$STORAGE_ENGINE" == "rocksdb" ] && [ "$CONFIG_SERVERS" == "" ]; then
  echo $mongoshell admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
  $mongoshell admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
  echo $mongoshell admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
  $mongoshell admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
fi