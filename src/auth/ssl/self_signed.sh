#!/bin/bash

if [ ! -f $KEY_FILE ]; then
  openssl req -newkey rsa:2048 -new -x509 -days 365 -nodes -out /etc/ssl/mongodb-cert.crt -keyout /etc/ssl/mongodb-cert.key
  cat /etc/ssl/mongodb-cert.key /etc/ssl/mongodb-cert.crt > $KEY_FILE
fi

if [ ! -f $CA_FILE ]; then
  ca_pwd=$(openssl rand -base64 32)
  openssl req -new -config /run/auth/ssl/ca.conf -out /etc/ssl/ca/mongodb-ca.key -keyout /etc/ssl/ca/mongodb-ca.key -batch -passout pass:$ca_pwd
  openssl ca -selfsign -config /run/auth/ssl/ca.conf -in /etc/ssl/ca/mongodb-ca.key -out /etc/ssl/ca/mongodb-ca.crt -extensions root_ca_ext -batch -passin pass:$ca_pwd
  cat /etc/ssl/ca/mongodb-ca.crt /etc/ssl/ca/mongodb-ca.key > $CA_FILE
fi
