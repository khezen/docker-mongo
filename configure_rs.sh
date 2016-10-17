#!/bin/bash 

if [ "$slaves" != "" ]; then
  echo mongo --quiet --eval "rs.initiate(); var conf = rs.conf(); conf.members[0].host='$master'; rs.reconfig(conf)"
  mongo --quiet --eval "rs.initiate(); var conf = rs.conf(); conf.members[0].host='$master'; rs.reconfig(conf)"
  for slave in $slaves; do
    echo mongo --quiet --eval "rs.add('$slave')"
    mongo --quiet --eval "rs.add('$slave')"
  done
fi

if [ "$slaves" != "" ] && [ "$arbitrers" != "" ]; then
  for arbitrer in $arbitrers; do
    echo mongo --quiet --eval "rs.addArb('$arbitrer')"
    mongo --quiet --eval "rs.addArb('$arbitrer')"
  done
fi

if [ "$slaves" != "" ] && [ "$slaveOk" == "y" ]; then
  echo mongo --quiet --eval "rs.slaveOk()"
  mongo --quiet --eval "rs.slaveOk()"  
fi

touch "$dbpath"/.mongodb_replSet_set