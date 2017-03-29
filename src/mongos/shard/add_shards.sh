#!/bin/bash
if [ ! -f /data/db/.metadata/.shards_added ]; then
    mongoshell=$(/run/misc/mongoshell.sh)

    if [ "$SHARDS" != "" ]; then
        for shard in $SHARDS; do
            echo $mongoshell admin --quiet --eval "sh.addShard('$shard')"
            $mongoshell admin --quiet --eval "sh.addShard('$shard')"
        done
    fi

    if [ "$DB_NAME" != "" ]; then
        echo $mongoshell admin --quiet --eval "sh.enableSharding('$DB_NAME')"
        $mongoshell admin --quiet --eval "sh.enableSharding('$DB_NAME')"
    fi

    touch /data/db/.metadata/.shards_added
fi
