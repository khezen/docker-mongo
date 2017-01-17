#!/bin/bash
# if credentials have already been set on config servers, the first line will do the job. Otherwise the second will pass
mongo -u $ADMIN_USER -p $ADMIN_PWD admin --eval "db.shutdownServer()"
mongo admin --eval "db.shutdownServer()"
