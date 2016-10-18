FROM debian:jessie

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>
LABEL Descritpion="mongodb roccksdb mongo mongod mongos mongotools bsondump mongodump mongorestore mongoimport mongoexport mongostat mongofiles mongooplog mongotop"

COPY ./src/setup/install_mongoserver.sh /install_mongoserver.sh
RUN chmod +x /install_mongoserver.sh \
&&  sh /install_mongoserver.sh \
&&  rm /install_mongoserver.sh

COPY ./src/setup/install_mongotools.sh /install_mongotools.sh
RUN chmod +x /install_mongotools.sh \
&&  sh /install_mongotools.sh \
&&  rm /install_mongotools.sh

# configuration and startup
ENV auth="n" \
    admin_user="admin" \
    admin_pwd="changeme" \
    dbpath="/data/db" \
    db_user="user" \
    db_pwd="changeme" \
    rs_name="" \
    storage_engine="wiredTiger" \
    master=$HOSTNAME \
    slaves="" \
    arbitrers="" \
    slaveOk="y" \
    shardsvr="n" \
    configsvr="n" \
    config_servers="" \
    shards=""
    
RUN  mkdir -p /run
COPY ./src/entrypoint.sh /run/
COPY ./src/utils/wait_until_started.sh /run/
COPY ./src/utils/perf.sh /run/
COPY ./src/utils/status.sh /run/
COPY ./src/replSet/set_master.sh /run/
COPY ./src/replSet/add_members.sh /run/
COPY ./src/auth/set_auth.sh /run/
COPY ./src/auth/create_keyfile.sh /run/
COPY ./src/shard/add_shards.sh /run/
RUN chmod +x -R /run/

ENTRYPOINT ["/run/entrypoint.sh"]
