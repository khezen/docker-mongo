FROM chromapdx/mongo-rocks-dist

ENV auth="no" \
    admin_user="admin" \
    admin_pwd="admin" \
    dbpath="/data/db" \
    db_user="user" \
    db_pwd="password" \
    rs_name="rs" \
    storage_engine="rocksdb" \
    shard="no"

VOLUME /data/db
EXPOSE 27017

COPY ./set_auth.sh /
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh && chmod +x /set_auth.sh

ENTRYPOINT ["/entrypoint.sh"]
