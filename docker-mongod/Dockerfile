FROM chromapdx/mongo-rocks-dist

ENV AUTH="no" \
    ADMIN_USER="admin" \
    ADMIN_PASS="admin" \
    DBPATH="/data/db" \
    DB_USER="user" \
    DB_PASS="password" \
    REPLICA_SET_NAME="rs" \
    STORAGE_ENGINE="rocksdb" \
    SHARD="no"

VOLUME /data/db
EXPOSE 27017

COPY ./set_auth.sh /
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh && chmod +x /set_auth.sh

ENTRYPOINT ["/entrypoint.sh"]
