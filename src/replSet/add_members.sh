#!/bin/bash
if [ ! -f "$dbpath"/.members_added ] && [ "$slaves" != "" ]; then
    
   mongoshell=$(/run/cmd/mongoshell.sh)

    if [ "$slaves" != "" ]; then
    for slave in $slaves; do
        echo $mongoshell --quiet --eval "rs.add('$slave')"
        $mongoshell --quiet --eval "rs.add('$slave')"
    done
    fi

    if [ "$slaves" != "" ] && [ "$arbitrers" != "" ]; then
    for arbitrer in $arbitrers; do
        echo $mongoshell --quiet --eval "rs.addArb('$arbitrer')"
        $mongoshell --quiet --eval "rs.addArb('$arbitrer')"
    done
    fi

    if [ "$slaves" != "" ] && [ "$slaveOk" == "y" ]; then
    echo $mongoshell --quiet --eval "rs.slaveOk()"
    $mongoshell --quiet --eval "rs.slaveOk()"  
    fi
    touch "$dbpath"/.members_added
fi
