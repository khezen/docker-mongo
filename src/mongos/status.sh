#!/bin/bash

mongoshell=$(/run/misc/mongoshell.sh)
sleep 5
echo $mongoshell admin --eval "sh.status()"
$mongoshell admin --eval "sh.status()"

