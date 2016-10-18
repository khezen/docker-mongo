#!/bin/bash
if [ ! -f /data/db/config/key ]; then
    mkdir -p /data/db/config
    touch /data/db/config/key
    echo $admin_pwd > /data/db/config/key
    chmod 600 /data/db/config/key
fi