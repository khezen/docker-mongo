#!/bin/bash
if [ ! -f /config/.members_added ] && [ "$SLAVES" != "" ]; then
    
   mongoshell=$(/run/misc/mongoshell.sh)

    if [ "$SLAVES" != "" ]; then
    for slave in $SLAVES; do
        echo $mongoshell admin --quiet --eval "rs.add('$slave')"
        $mongoshell admin --quiet --eval "rs.add('$slave')"
    done
    fi

    if [ "$SLAVES" != "" ] && [ "$ARBITRERS" != "" ]; then
    for arbitrer in $ARBITRERS; do
        echo $mongoshell admin --quiet --eval "rs.addArb('$arbitrer')"
        $mongoshell admin --quiet --eval "rs.addArb('$arbitrer')"
    done
    fi

    if [ "$SLAVES" != "" ] && [ "$SLAVE_OK" == "y" ]; then
    echo $mongoshell admin --quiet --eval "rs.slaveOk()"
    $mongoshell admin --quiet --eval "rs.slaveOk()"  
    fi
    touch /config/.members_added
fi
