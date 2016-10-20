FROM debian:jessie

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>
LABEL Descritpion="mongodb roccksdb mongo mongod mongos mongotools bsondump mongodump mongorestore mongoimport mongoexport mongostat mongofiles mongooplog mongotop"

COPY ./src/setup/install_mongoserver.sh /run/setup/install_mongoserver.sh
RUN chmod +x -R /run
RUN sh /run/setup/install_mongoserver.sh 

COPY ./src/setup/install_mongotools.sh /run/setup/install_mongotools.sh
RUN chmod +x -R /run
RUN sh /run/setup/install_mongotools.sh

COPY ./src /run
RUN chmod +x -R /run

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
    
ENTRYPOINT ["/run/entrypoint.sh"]
