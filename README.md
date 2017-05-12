# Supported tags and respective `Dockerfile` links

* `3.2.9`, `3.2` [(3.2/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.2/Dockerfile) [![](https://images.microbadger.com/badges/image/khezen/mongo:3.2.svg)](https://microbadger.com/images/khezen/mongo:3.2 "Get your own image badge on microbadger.com")
* `3.4.4`, `3.4`, `3`, `latest` [(3.4/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.4/Dockerfile) [![](https://images.microbadger.com/badges/image/khezen/mongo:3.4.svg)](https://microbadger.com/images/khezen/mongo:3.4 "Get your own image badge on microbadger.com")
* `3.4.4-slim`, `3.4-slim`, `3-slim`, `slim` [(3.4-slim/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.4-slim/Dockerfile) [![](https://images.microbadger.com/badges/image/khezen/mongo:3.4-slim.svg)](https://microbadger.com/images/khezen/mongo:3.4-slim "Get your own image badge on microbadger.com")

# What is MongoDB?
MongoDB (from "humongous") is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster. Released under a combination of the GNU Affero General Public License and the Apache License, MongoDB is free and open-source software.

[wikipedia.org/wiki/MongoDB](https://en.wikipedia.org/wiki/MongoDB)

# Comming soon

* TLS support
* alpine based image

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
  * [config ref](https://docs.mongodb.com/manual/core/wiredtiger)
* [rocksdb](http://RocksDB.org/)
  * [config ref](https://github.com/mongodb-partners/mongo-rocks/wiki)

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

See docker stack below:

```
version: '3'

services:

  replica1:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-1
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/replica1:/data/db
    networks:
      - mongo_cluster

  replica2:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-2
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/replica2:/data/db
    networks:
      - mongo_cluster

  replica3:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-3
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      MASTER: replica3
      SLAVES: replica1 replica2
      AUTH: 'y'
    volumes:
      - /data/mongo/replica3:/data/db
    networks:
      - mongo_cluster

networks:
  mongo_cluster:
    driver: overlay

```

##### ARBITRERS | `(empty by default)`
Define the `host:port` arbitrers you want to add to a replica set from its master. (**RS_NAME** has to be specified, **MASTER** has to be specified, **SLAVES** has to be specified).

See docker stack below:

```
version: '3'

services:

  replica1:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-1
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/replica1:/data/db
    networks:
      - mongo_cluster

  replica2:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-2
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/replica2:/data/db
    networks:
      - mongo_cluster

  replica3:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-3
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      MASTER: replica3
      SLAVES: replica1
      ARBITRERS: replica2
      AUTH: 'y'
    volumes:
      - /data/mongo/replica3:/data/db
    networks:
      - mongo_cluster

networks:
  mongo_cluster:
    driver: overlay
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

See docker stack below:

```
version: '3'

services:

    # SHARD 1

  shard1_replica1:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-1
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/shard1/replica1:/data/db
    networks:
      - mongo_cluster

  shard1_replica2:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-2
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/shard1/replica2:/data/db
    networks:
      - mongo_cluster

  shard1_replica3:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-3
    environment:
      RS_NAME: shard1
      SHARD_SVR: 'y'
      MASTER: shard1_replica3
      SLAVES: shard1_replica1 shard1_replica2
      AUTH: 'y'
    volumes:
      - /data/mongo/shard1/replica3:/data/db
    networks:
      - mongo_cluster

  # SHARD 2

  shard2_replica1:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-4
    environment:
      RS_NAME: shard2
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
     - /data/mongo/shard2/replica1:/data/db
    networks:
      - mongo_cluster

  shard2_replica2:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-5
    environment:
      RS_NAME: shard2
      SHARD_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/shard2/replica2:/data/db
    networks:
      - mongo_cluster

  shard2_replica3:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-6
    environment:
      RS_NAME: shard2
      SHARD_SVR: 'y'
      MASTER: shard2_replica3
      SLAVES: shard2_replica1 shard2_replica2
      AUTH: 'y'
    volumes:
      - /data/mongo/shard2/replica3:/data/db
    networks:
      - mongo_cluster

  # CONFIG SVRS

  configsvr1:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-1
    environment:
      RS_NAME: configsvr
      CONFIG_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/configsvr/replica1:/data/db
    networks:
      - mongo_cluster

  configsvr2:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-3
    environment:
      RS_NAME: configsvr
      CONFIG_SVR: 'y'
      AUTH: 'y'
    volumes:
      - /data/mongo/configsvr/replica2:/data/db
    networks:
      - mongo_cluster

  configsvr3:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 1
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
      palcement:
        node.hostname: node-5
    environment:
      RS_NAME: configsvr
      CONFIG_SVR: 'y'
      MASTER: configsvr3
      SLAVES: configsvr1 configsvr2
      AUTH: 'y'
    volumes:
      - /data/mongo/configsvr/replica3:/data/db
    networks:
      - mongo_cluster

  # MONGOS

  mongos:
    image: khezen/mongo:slim
    deploy:
      mode: replicated
      replicas: 3
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
    environment:
      CONFIG_SERVERS:  configsvr/configsvr3:27017
      SHARDS: shard1/shard1_replica3 shard2/shard2_replica3
      AUTH: 'y'
      SERVICE_PORTS: 27017
      TCP_PORTS: 27017
    networks:
      - mongo_cluster

  load_balancer:
    image: dockercloud/haproxy:1.6.2
    depends_on:
      - mongos
    deploy:
      mode: global
      restart_policy:
        condition: any
      placement:
        constraints:
          - node.role == manager
    environment:
      STATS_PORT: 9000
      STATS_AUTH: stats:changeme
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - mongo_cluster
    ports:
      - "9090:9000"
      - "27017:27017"

networks:
  mongo_cluster:
    driver: overlay
```

# User Feedback
## Issues
If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/Khezen/docker-mongo/issues).

---

Inspired by [mongo-rocks](https://github.com/jadsonlourenco/docker-mongo-rocks) from [jadsonlourenco](https://twitter.com/jadsonlourenco)
and  [mongo-rocks](https://github.com/structuresound/docker-mongo-rocks) from [Chroma](https://github.com/structuresound)
