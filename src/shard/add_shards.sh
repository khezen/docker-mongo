#!/bin/bash
if [ ! -f "$dbpath"/.shards_added ]; then
    mongoshell="mongo";
    if [ "$auth" == "y" ];then
        mongoshell="$mongoshell -u $admin_user -p $admin_pwd --authenticationDatabase admin"
    fi


    if [ "$shards" != "" ]; then
        for shard in $shards; do
            echo $mongoshell --quiet --eval "sh.addShard('$shard')"
            $mongoshell --quiet --eval "sh.addShard('$shard')"
        done
    fi

    if [ "$database" != "" ]; then
        echo $mongoshell --quiet --eval "sh.addShard('$shard')"
        $mongoshell --quiet --eval "sh.enableSharding('$database')"
    fi

    touch "$dbpath"/.shards_added
fi