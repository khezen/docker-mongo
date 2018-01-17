#!/bin/bash
set -m

mkdir -p /etc/mongo
if [ ! -f /etc/mongo/config.yml ]; then
    cp -r /.backup/mongo/config.yml /etc/mongo/
fi

$@ &

fg