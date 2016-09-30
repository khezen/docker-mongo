[![](https://images.microbadger.com/badges/image/khezen/mongo-rocks.svg)](https://microbadger.com/images/khezen/mongo-rocks "Get your own image badge on microbadger.com")
# Supported tags and respective `Dockerfile` links

* `3.2.9`, `3.2`, `3`, `latest` [(3.2/Dockerfile)](https://github.com/Khezen/docker-mongo-rocks/blob/v3.2/Dockerfile)

# How To Use
## docker engine
```
docker run -d -p 27017:27017 -e db_user=test -e db_pwd=test -e database=mongo khezen/mongo-rocks:latest   
```   

## docker-compose
```
version: '2'
services:
    mongod1:
        image: khezen/mongo-rocks:3.2
        environment:
            rs_name: rs
            storage_engine: rocksdb
        volumes:
             - /srv/mongo-rocks/rs1:/data/db
        ports:
             - "27017:27017"
        network_mode: bridge
        restart: always

```

# Environment Variables

##### auth | *yes*
To disable authentication, set to **no**.

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
*mongod is not launched in replSet mode by default. Set this variable if you want to toggle it.*


##### shard | *no*
*yes* means --shardsvr option added to mongod. 

##### storage_engine | *rocksdb*
Define the storage engine you want to plug to your mongod server. [mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [WiredTiger](http://www.WiredTiger.com/) or [RocksDB](http://RocksDB.org/).

---

Inspired by [mongo-rocks](https://github.com/jadsonlourenco/docker-mongo-rocks) from [jadsonlourenco](https://twitter.com/jadsonlourenco)
and  [mongo-rocks](https://github.com/structuresound/docker-mongo-rocks) from [Chroma](https://github.com/structuresound)
