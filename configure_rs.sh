if [ "$rs_name" != "" ] && [ "$slaves" != "" ]; then
  mongo --quiet --eval "rs.initiate()"
  mongo --quiet --eval "rs.conf()"
  for slave in $slaves; do
    mongo --quiet --eval "rs.add(\"$slave\")"
  done
fi

if [ "$rs_name" != "" ] && [ "$slaves" != "" ] && [ "$arbitrers" != "" ]; then
  for arbitrer in $arbitrers; do
    mongo --quiet --eval "rs.addArb(\"$arbitrer\")"
  done
  
fi

if [ "$rs_name" != "" ] && [ "$slaves" != "" ] && [ "$slaveOk" == "yes" ]; then
  mongo --quiet --eval "rs.slaveOk()"  
fi

if [ "$rs_name" != "" ]; then
  mongo --quiet --eval "rs.conf()"
fi