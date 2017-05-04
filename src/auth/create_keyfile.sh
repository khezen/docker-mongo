#!/bin/bash
if [ ! -f /.key ]; then
    touch /.key
    echo $ADMIN_PWD > /.key
    chmod 600 /.key
fi
