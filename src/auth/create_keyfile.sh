#!/bin/bash
if [ ! -f /config/key ]; then
    touch /config/key
    echo $ADMIN_PWD > /config/key
    chmod 600 /config/key
fi