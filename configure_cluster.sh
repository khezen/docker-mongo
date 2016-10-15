#!/bin/bash
if [ "$shards" != "" ]; then
    for shard in $shards; do
        mongo --quiet --eval "sh.addShard(\"$shard\")"
    done
fi

if [ "$database" != "" ]; then
    mongo --quiet --eval "sh.enableSharding(\"$database\")"
fi

sleep 20
mongo --quiet --eval "sh.status()"


touch /.mongodb_cluster_set