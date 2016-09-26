FROM chromapdx/mongo-rocks-dist

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>

ENV auth="no" \
    admin_user="admin" \
    admin_pwd="changeme" \
    dbpath="/data/db" \
    db_user="user" \
    db_pwd="changeme" \
    rs_name="rs" \
    storage_engine="rocksdb" \
    shard="no"

VOLUME /data/db
EXPOSE 27017

COPY ./set_auth.sh /
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh && chmod +x /set_auth.sh

ENTRYPOINT ["/entrypoint.sh"]
