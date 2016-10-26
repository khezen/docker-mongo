[![](https://images.microbadger.com/badges/image/khezen/mongo.svg)](https://hub.docker.com/r/khezen/mongo/)
# Supported tags and respective `Dockerfile` links

* `3.2.9`, `3.2`, `3`, `latest` [(3.2/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.2/Dockerfile)

# What is MongoDB?
MongoDB (from "humongous") is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster. Released under a combination of the GNU Affero General Public License and the Apache License, MongoDB is free and open-source software.

[wikipedia.org/wiki/MongoDB](https://en.wikipedia.org/wiki/MongoDB)


![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/mongo/logo.png)
---
# How To Use
## docker engine
```
docker run -d -p 27017:27017 -e db_user=test -e db_pwd=test -e database=mongo khezen/mongo:latest   
```   

## docker-compose
```
version: '2'
services:
    mongod1:
        image: khezen/mongo:3.2
        environment:
            rs_name: rs
            storage_engine: rocksdb
        volumes:
             - /srv/mongo/mongod1:/data/db
        ports:
             - "27017:27017"
        network_mode: bridge
        restart: always

```
---
# Environment Variables

## General

##### storage_engine | `wiredTiger`
Define the storage engine you want to plug to your mongod server. [mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [WiredTiger](http://www.WiredTiger.com/) or [RocksDB](http://RocksDB.org/).

##### auth | `n`
To enable authentication, set to `y`.

##### admin_user | `admin`
User with *root* permissions on the *admin* database. (**auth** has to be set to `y`).

##### admin_pwd | `changeme`
The password of the **admin_user** above. (**auth** has to be set to `y`).

##### database | `(empty by default)`
Create a new database with this name.

##### db_user | `user`
User with *owner* permissions on the **database** above. (**auth** has to be set to `y`, **database** has to be specified).

##### db_pwd | `changeme`
The password of the **db_user** above. (**auth** has to be set to `y`, **database** has to be specified).

##### dbpath | `/data/db`
The path to data storing floder.

##### oplog_size | `50`
Define the size of [Oplog](https://docs.mongodb.org/manual/tutorial/change-oplog-size/), in megabytes.

## Replica Set
##### rs_name | `(empty by default)`
Define the name of the replica set on which you want this server to be attached.

##### master | `$HOSTNAME`
Define the `host:port` of the master during replica set init. (**rs_name** has to be specified).

##### slaves | `(empty by default)`
Define the `host:port` members you want to add to a replica set from its master. (**rs_name** has to be specified, **master** has to be specified).

See example below:

*(I am using ip adresses in this example but usually you want to use logical names instead)*
```
version: '2'
services:

    mongod1:
        image: khezen/mongo:3
        environment:
            rs_name: rs
            storage_engine: rocksdb
        volumes:
             - /srv/mongo/mongod1:/data/db
        ports:
             - "27017:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.11
        restart: always

    mongod2:
        image: khezen/mongo:3
        environment:
            rs_name: rs
            storage_engine: rocksdb
        volumes:
             - /srv/mongo/mongod2:/data/db
        ports:
             - "27018:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.12
        restart: always

    mongod3:
        image: khezen/mongo:3
        environment:
            rs_name: rs
            storage_engine: rocksdb
            master: 172.16.238.13
            slaves: 172.16.238.11 172.16.238.12    
        volumes:
             - /srv/mongo/mongod3:/data/db
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

##### arbitrers | `(empty by default)`
Define the `host:port` arbitrers you want to add to a replica set from its master. (**rs_name** has to be specified, **master** has to be specified, **slaves** has to be specified).

See example below:

*(I am using ip adresses in this example but usually you want to use logical names instead)*
```
version: '2'
services:

    mongod1:
        image: khezen/mongo:3
        environment:
            rs_name: rs
            storage_engine: rocksdb
        volumes:
             - /srv/mongo/mongod1:/data/db
        ports:
             - "27017:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.11
        restart: always

    mongod2:
        image: khezen/mongo:3
        environment:
            rs_name: rs
            storage_engine: rocksdb
        volumes:
             - /srv/mongo/mongod2:/data/db
        ports:
             - "27018:27017"
        networks:
            rs_net:
                ipv4_address: 172.16.238.12
        restart: always

    mongod3:
        image: khezen/mongo:3
        environment:
            rs_name: rs
            storage_engine: rocksdb
            master: 172.16.238.13
            slaves: 172.16.238.11
            arbitrers: 172.16.238.12
        volumes:
             - /srv/mongo/mongod3:/data/db
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

##### slaveOk | `y`
`y` means you can read from slaves.

## Sharded Cluster

##### shardsvr | `n`
`y` means mongod is a shard by adding `--shardsvr` option. 

##### configsvr | `n`
`y` means mongod is launched as a config server by adding `--configsvr` option.

##### config_servers | `(empty by default)`
Start a mongos instance instead of a mongod and define the `rsname/host:port` configsrv attached to it.

##### shards | `(empty by default)`
Define the `rsname/host:port` shards you want to add to a cluster. if **database** env variable is specified then sharding is automatically enabled for it. (**config_servers** has to be specified).

See example below:

*(I am using ip adresses in this example but usually you want to use logical names instead)*
```
version: '2'
services:

    # SHARD 1

    shard1_replica1:
        image: khezen/mongo:3
        environment:
            rs_name: shard1
            shardsvr: y
        volumes:
             - /srv/mongo/shard1/replica1:/data/db
        ports:
             - "27011:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.11
        restart: always

    shard1_replica2:
        image: khezen/mongo:3
        environment:
            rs_name: shard1
            shardsvr: y
        volumes:
             - /srv/mongo/shard1/replica2:/data/db
        ports:
             - "27012:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.12
        restart: always

    shard1_replica3:
        image: khezen/mongo:3
        environment:
            rs_name: shard1
            shardsvr: y
            master: 172.16.239.13
            slaves: 172.16.239.11 172.16.239.12    
        volumes:
             - /srv/mongo/shard1/replica3:/data/db
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
            rs_name: shard2
            shardsvr: y
        volumes:
             - /srv/mongo/shard2/replica1:/data/db
        ports:
             - "27021:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.21
        restart: always

    shard2_replica2:
        image: khezen/mongo:3
        environment:
            rs_name: shard2
            shardsvr: y
        volumes:
             - /srv/mongo/shard2/replica2:/data/db
        ports:
             - "27022:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.22
        restart: always

    shard2_replica3:
        image: khezen/mongo:3
        environment:
            rs_name: shard2
            shardsvr: y
            master: 172.16.239.23
            slaves: 172.16.239.21 172.16.239.22    
        volumes:
             - /srv/mongo/shard2/replica3:/data/db
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
            rs_name: configsvr
            configsvr: y 
        volumes:
             - /srv/mongo/configsvr/replica1:/data/db
        ports:
             - "27101:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.101
        restart: always

    configsvr2:
        image: khezen/mongo:3
        environment:
            rs_name: configsvr
            configsvr: y   
        volumes:
             - /srv/mongo/configsvr/replica2:/data/db
        ports:
             - "27102:27017"
        networks:
            mongo_cluster_net:
                ipv4_address: 172.16.239.102
        restart: always

    configsvr3:
        image: khezen/mongo:3
        environment:
            rs_name: configsvr
            configsvr: y
            master: 172.16.239.103
            slaves: 172.16.239.101 172.16.239.102
        volumes:
             - /srv/mongo/configsvr/replica3:/data/db
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
            config_servers: configsvr/172.16.239.103:27017
            shards: shard1/172.16.239.13 shard2/172.16.239.23
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
