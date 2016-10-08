#!/bin/sh 

if [ "$slaves" != "" ]; then
  mongo --quiet --eval "rs.initiate(); var conf = rs.conf(); conf.members[0].host=\"$master\"; rs.reconfig(conf)"
  for slave in $slaves; do
    mongo --quiet --eval "rs.add(\"$slave\")"
  done
fi

if [ "$slaves" != "" ] && [ "$arbitrers" != "" ]; then
  for arbitrer in $arbitrers; do
    mongo --quiet --eval "rs.addArb(\"$arbitrer\")"
  done
fi

if [ "$slaves" != "" ] && [ "$slaveOk" == "y" ]; then
  mongo --quiet --eval "rs.slaveOk()"  
fi

mongo --quiet --eval "rs.status()"
touch "$dbpath"/.mongodb_replSet_set