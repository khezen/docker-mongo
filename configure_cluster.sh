#!/bin/bash

if [ "$shards" != "" ]; then
    for shard in $shards; do
        mongo --quiet --eval "sh.addShard(\"$shard\")"
    done
fi

touch /.mongodb_cluster_set