#!/bin/bash 
if [ "$master" != "" ] && [ ! -f "$dbpath"/.master_set ]; then
  echo mongo --quiet --eval "rs.initiate();"
  mongo --quiet --eval "rs.initiate();"
  /run/replSet/wait_until_rs_configured.sh
  echo mongo --quiet --eval "var conf = rs.conf(); conf.members[0].host='$master'; rs.reconfig(conf)"
  mongo --quiet --eval "var conf = rs.conf(); conf.members[0].host='$master'; rs.reconfig(conf)"
  touch "$dbpath"/.master_set
fi