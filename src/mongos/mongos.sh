#!/bin/bash

if [ "$AUTH" == "y" ]; then
  /run/auth/create_keyfile.sh
  /run/auth/ssl/sel_signed.sh
  touch /config/.admin_created
fi

cmd="mongos --port 27017 --configdb"
concat_servers=""
for config_server in $CONFIG_SERVERS; do
    if [ "$concat_servers" == "" ]; then
        concat_servers="$config_server"
    else
        concat_servers="$concat_servers,$config_server"
    fi
done
cmd="$cmd $concat_servers"

if [ "$AUTH" == "y" ] && [ -f /config/key ]; then
  cmd="$cmd --keyFile /config/key"
  if [ "$REQUIRE_SSL" == "y" ]; then
    cmd="$cmd --sslMode requireSSL --sslPEMKeyFile $KEY_FILE --sslCAFile $CA_FILE"
  fi
fi

echo $cmd
