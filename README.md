[![](https://images.microbadger.com/badges/image/khezen/mongo.svg)](https://hub.docker.com/r/khezen/mongo/)
# Supported tags and respective `Dockerfile` links

* `3.2.9`, `3.2` [(3.2/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.2/Dockerfile)
* `3.4.1`, `3.4`, `3`, `latest` [(3.4/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.4/Dockerfile)

# What is MongoDB?
MongoDB (from "humongous") is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster. Released under a combination of the GNU Affero General Public License and the Apache License, MongoDB is free and open-source software.

[wikipedia.org/wiki/MongoDB](https://en.wikipedia.org/wiki/MongoDB)


![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/mongo/logo.png)

---
# How To Use
## docker engine
```
docker run -d -p 27017:27017 -e DB_NAME=mongo khezen/mongo:latest   
```   

## docker-compose
```
version: '2'
services:
    mongod1:
        image: khezen/mongo:3.4
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
        volumes:
             - /data/mongo/mongod1:/data/db
        ports:
             - "27017:27017"
        network_mode: bridge
        restart: always

```
---
# Environment Variables

## General

##### STORAGE_ENGINE | `wiredTiger`
Define the storage engine you want to plug to your mongod server.
* [mmapv1](https://docs.mongodb.com/manual/core/mmapv1/)
* [wiredTiger](http://www.WiredTiger.com/)
  * In case you choose wiredTiger, make you have read [this reference](https://docs.mongodb.com/manual/core/wiredtiger/).
* [rocksdb](http://RocksDB.org/)
  * In case you choose rocksdb, make sure you have read [this reference](https://github.com/mongodb-partners/mongo-rocks/wiki).

##### AUTH | `n`
To enable AUTHentication, set to `y`.

##### ADMIN_USER | `admin`
User with *root* permissions on the *admin* DB_NAME. (**AUTH** has to be set to `y`).

##### ADMIN_PWD | `changeme`
The password of the **ADMIN_USER** above. (**AUTH** has to be set to `y`).

##### DB_NAME | `(empty by default)`
Create a new DB_NAME with this name.

##### DB_USER | `user`
User with *owner* permissions on the **DB_NAME** above. (**AUTH** has to be set to `y`, **DB_NAME** has to be specified).

##### DB_PWD | `changeme`
The password of the **DB_USER** above. (**AUTH** has to be set to `y`, **DB_NAME** has to be specified).

##### DATA_PATH | `/data/db`
The path to data storing floder.

##### OPLOG_SIZE | `50`
Define the size of [Oplog](https://docs.mongodb.org/manual/tutorial/change-oplog-size/), in megabytes.

## Replica Set
##### RS_NAME | `(empty by default)`
Define the name of the replica set on which you want this server to be attached.

##### MASTER | `$HOSTNAME`
Define the `host:port` of the master during replica set init. (**RS_NAME** has to be specified).

##### SLAVES | `(empty by default)`
Define the `host:port` members you want to add to a replica set from its master. (**RS_NAME** has to be specified, **MASTER** has to be specified).

See example below:

*(I am using ip adresses in this example but usually you want to use logical names instead)*
```
version: '2'
services:

    mongod1:
        image: khezen/mongo:3
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
        volumes:
             - /data/mongo/mongod1:/data/db
        ports:
             - "27017:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.11
        restart: always

    mongod2:
        image: khezen/mongo:3
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
        volumes:
             - /data/mongo/mongod2:/data/db
        ports:
             - "27018:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.12
        restart: always

    mongod3:
        image: khezen/mongo:3
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
            MASTER: 172.16.238.13
            SLAVES: 172.16.238.11 172.16.238.12    
        volumes:
             - /data/mongo/mongod3:/data/db
        ports:
             - "27019:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.13
        restart: always

networks:
  rs_net:
    driver: bridge
    ipam:
        driver: default
        config:
        - subnet: 172.16.238.0/24
          gateway: 172.16.238.1
```

##### ARBITRERS | `(empty by default)`
Define the `host:port` arbitrers you want to add to a replica set from its master. (**RS_NAME** has to be specified, **MASTER** has to be specified, **SLAVES** has to be specified).

See example below:

*(I am using ip adresses in this example but usually you want to use logical names instead)*
```
version: '2'
services:

    mongod1:
        image: khezen/mongo:3
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
        volumes:
             - /data/mongo/mongod1:/data/db
        ports:
             - "27017:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.11
        restart: always

    mongod2:
        image: khezen/mongo:3
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
        volumes:
             - /data/mongo/mongod2:/data/db
        ports:
             - "27018:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.12
        restart: always

    mongod3:
        image: khezen/mongo:3
        environment:
            RS_NAME: rs
            STORAGE_ENGINE: rocksdb
            MASTER: 172.16.238.13
            SLAVES: 172.16.238.11
            ARBITRERS: 172.16.238.12
        volumes:
             - /data/mongo/mongod3:/data/db
        ports:
             - "27019:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.13
        restart: always

networks:
  rs_net:
    driver: bridge
    ipam:
        driver: default
        config:
        - subnet: 172.16.238.0/24
          gateway: 172.16.238.1
```

##### SLAVE_OK | `y`
`y` means you can read from slaves.

## Sharded Cluster

##### SHARD_SVR | `n`
`y` means mongod is a shard by adding --shardsvr option.

##### CONFIG_SVR | `n`
`y` means mongod is launched as a config server by adding --configsvr option.

##### CONFIG_SERVERS | `(empty by default)`
Start a mongos instance instead of a mongod and define the `rsname/host:port` config servers attached to it.

##### SHARDS | `(empty by default)`
Define the `rsname/host:port` shards you want to add to a cluster.(**CONFIG_SERVERS** has to be specified).

*NOTE*: if **DB_NAME** is specified, then sharding is automatically enabled for the database named after it.

See example below:

*(I am using ip adresses in this example but usually you want to use logical names instead)*
```
version: '2'
services:

    # SHARD 1

    shard1_replica1:
        image: khezen/mongo:3
        environment:
            RS_NAME: shard1
            SHARD_SVR: y
        volumes:
             - /data/mongo/shard1/replica1:/data/db
        ports:
             - "27011:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.11
        restart: always

    shard1_replica2:
        image: khezen/mongo:3
        environment:
            RS_NAME: shard1
            SHARD_SVR: y
        volumes:
             - /data/mongo/shard1/replica2:/data/db
        ports:
             - "27012:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.12
        restart: always

    shard1_replica3:
        image: khezen/mongo:3
        environment:
            RS_NAME: shard1
            SHARD_SVR: y
            MASTER: 172.16.239.13
            SLAVES: 172.16.239.11 172.16.239.12    
        volumes:
             - /data/mongo/shard1/replica3:/data/db
        ports:
             - "27013:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.13
        restart: always

    # SHARD 2

    shard2_replica1:
        image: khezen/mongo:3
        environment:
            RS_NAME: shard2
            SHARD_SVR: y
        volumes:
             - /data/mongo/shard2/replica1:/data/db
        ports:
             - "27021:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.21
        restart: always

    shard2_replica2:
        image: khezen/mongo:3
        environment:
            RS_NAME: shard2
            SHARD_SVR: y
        volumes:
             - /data/mongo/shard2/replica2:/data/db
        ports:
             - "27022:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.22
        restart: always

    shard2_replica3:
        image: khezen/mongo:3
        environment:
            RS_NAME: shard2
            SHARD_SVR: y
            MASTER: 172.16.239.23
            SLAVES: 172.16.239.21 172.16.239.22    
        volumes:
             - /data/mongo/shard2/replica3:/data/db
        ports:
             - "27023:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.23
        restart: always

    # CONFIG SVRS

    configsvr1:
        image: khezen/mongo:3
        environment:
            RS_NAME: configsvr
            CONFIG_SVR: y
        volumes:
             - /data/mongo/configsvr/replica1:/data/db
        ports:
             - "27101:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.101
        restart: always

    configsvr2:
        image: khezen/mongo:3
        environment:
            RS_NAME: configsvr
            CONFIG_SVR: y   
        volumes:
             - /data/mongo/configsvr/replica2:/data/db
        ports:
             - "27102:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.102
        restart: always

    configsvr3:
        image: khezen/mongo:3
        environment:
            RS_NAME: configsvr
            CONFIG_SVR: y
            MASTER: 172.16.239.103
            SLAVES: 172.16.239.101 172.16.239.102
        volumes:
             - /data/mongo/configsvr/replica3:/data/db
        ports:
             - "27103:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.103
        restart: always

    # MONGOS

    mongos1:
        image: khezen/mongo:3
        environment:
            CONFIG_SERVERS: configsvr/172.16.239.103:27017
            SHARDS: shard1/172.16.239.13 shard2/172.16.239.23
        ports:
             - "27201:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.201
        restart: always

networks:
  mongo_cluster_net:
    driver: bridge
    ipam:
        driver: default
        config:
        - subnet: 172.16.239.0/24
          gateway: 172.16.239.1
```

# User Feedback
## Issues
If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/Khezen/docker-mongo/issues).

---

Inspired by [mongo-rocks](https://github.com/jadsonlourenco/docker-mongo-rocks) from [jadsonlourenco](https://twitter.com/jadsonlourenco)
and  [mongo-rocks](https://github.com/structuresound/docker-mongo-rocks) from [Chroma](https://github.com/structuresound)
