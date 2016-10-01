FROM debian:jessie

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>
LABEL Descritpion="mongodb roccksdb mongo mongod mongos mongotools bsondump mongodump mongorestore mongoimport mongoexport mongostat mongofiles mongooplog mongotop"

COPY install_mongoserver.sh /install_mongoserver.sh
RUN chmod +x /install_mongoserver.sh \
&&  sh /install_mongoserver.sh \
&&  rm /install_mongoserver.sh

COPY install_mongotools.sh /install_mongotools.sh
RUN chmod +x /install_mongotools.sh \
&&  sh /install_mongotools.sh \
&&  rm /install_mongotools.sh

# configuration and startup
ENV auth="no" \
    admin_user="admin" \
    admin_pwd="changeme" \
    dbpath="/data/db" \
    db_user="user" \
    db_pwd="changeme" \
    rs_name="" \
    storage_engine="rocksdb" \
    shard="no"

COPY ./set_auth.sh /
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh && chmod +x /set_auth.sh

ENTRYPOINT ["/entrypoint.sh"]
