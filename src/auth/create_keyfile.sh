#!/bin/bash
if [ ! -f /config/key ]; then
    touch /config/key
    echo $admin_pwd > /config/key
    chmod 600 /config/key
fi