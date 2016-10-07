[![](https://images.microbadger.com/badges/image/khezen/mongo.svg)](https://microbadger.com/images/khezen/mongo "Get your own image badge on microbadger.com")
# Supported tags and respective `Dockerfile` links

* `3.2.9`, `3.2`, `3`, `latest` [(3.2/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.2/Dockerfile)

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

##### storage_engine | *wiredTiger*
Define the storage engine you want to plug to your mongod server. [mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [WiredTiger](http://www.WiredTiger.com/) or [RocksDB](http://RocksDB.org/).

##### auth | *no*
To enable authentication, set to **yes**.

##### admin_user | *admin*
You need have a user with **root** permissions, manager of the **admin** database ever present.

##### admin_pwd | *changeme*
The password of the **admin_user** above.

##### database
Create a new database with this name, the **db_user** and **db_pwd** will be the owner of this database.

##### db_user | *user*
The user that manage the **database** above - don't have admin permissions.

##### db_pwd | *changeme*
The password of the **db_user** above.

##### dbpath | */data/db*
The path that store all data, this setting is useful for *Docker volumes*

##### oplog_size
Define the size of [Oplog](https://docs.mongodb.org/manual/tutorial/change-oplog-size/), in megabytes, for example, set **50** to be *50MB*.

##### rs_name
Define the name of the replica set on which you want this server to be attached.

##### slaves
Define the host:port members you want to add to a replica set from its master. See example below:
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
            ip: 172.16.238.13
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

##### arbitrers
Define the host:port arbitrers you want to add to a replica set from its master. See example below:
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
            ip: 172.16.238.13
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

##### slaveOk | *yes*
*yes* means you can read from slaves.

##### shard | *no*
*yes* means --shardsvr option added to mongod. 

---

Inspired by [mongo-rocks](https://github.com/jadsonlourenco/docker-mongo-rocks) from [jadsonlourenco](https://twitter.com/jadsonlourenco)
and  [mongo-rocks](https://github.com/structuresound/docker-mongo-rocks) from [Chroma](https://github.com/structuresound)
