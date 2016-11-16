#!/bin/bash
if [ ! -f /config/.members_added ] && [ "$SLAVES" != "" ]; then
    
   mongoshell=$(/run/cmd/mongoshell.sh)

    if [ "$SLAVES" != "" ]; then
    for slave in $SLAVES; do
        echo $mongoshell --quiet --eval "rs.add('$slave')"
        $mongoshell --quiet --eval "rs.add('$slave')"
    done
    fi

    if [ "$SLAVES" != "" ] && [ "$ARBITRERS" != "" ]; then
    for arbitrer in $ARBITRERS; do
        echo $mongoshell --quiet --eval "rs.addArb('$arbitrer')"
        $mongoshell --quiet --eval "rs.addArb('$arbitrer')"
    done
    fi

    if [ "$SLAVES" != "" ] && [ "$SLAVE_OK" == "y" ]; then
    echo $mongoshell --quiet --eval "rs.slaveOk()"
    $mongoshell --quiet --eval "rs.slaveOk()"  
    fi
    touch /config/.members_added
fi
