#!/bin/bash
if [ ! -f "$dbpath"/.shards_added ]; then
    mongoshell=$(/run/cmd/mongoshell.sh)

    if [ "$shards" != "" ]; then
        for shard in $shards; do
            echo $mongoshell --quiet --eval "sh.addShard('$shard')"
            $mongoshell --quiet --eval "sh.addShard('$shard')"
        done
    fi

    if [ "$database" != "" ]; then
        echo $mongoshell --quiet --eval "sh.enableSharding('$database')"
        $mongoshell --quiet --eval "sh.enableSharding('$database')"
    fi

    touch "$dbpath"/.shards_added
fi