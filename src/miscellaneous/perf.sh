#!/bin/bash

if [ ! -f "$dbpath"/.perf_tricks_set ] && [ "$config_servers" == "" ]; then
  echo mongo --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
  mongo --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
  echo mongo --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
  mongo --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
  touch "$dbpath"/.perf_tricks_set
fi