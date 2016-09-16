# mongod server
supported storage engines:
[mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [wiredTiger](http://www.wiredtiger.com/) and [rocksdb](http://rocksdb.org/)

## How To Use
```
docker run -d -p 27017:27017 -e DB_USER=test -e DB_PASS=test -e DATABASE=mongo Khezen/mongo-rocks:latest
```

## Environment Variables

#### AUTH - (default: yes)
To disable authentication, set to **no**.

#### ADMIN_USER - (default: admin)
You need have a user with **root** permissions, manager of the **admin** database ever present.

#### ADMIN_PASS - (default: admin)
The password of the **ADMIN_USER** above.

#### DATABASE
Create a new database with this name, the **DB_USER** and **DB_PASS** will be the owner of this database.

#### DB_USER - (default: user)
The user that manage the **DATABASE** above - don't have admin permissions.

#### DB_PASS - (default: password)
The password of the **DB_USER** above.

#### DBPATH - (default: /data/db)
The path that store all data, this setting is useful for *Docker volumes*

#### OPLOG_SIZE
Define the size of [Oplog](https://docs.mongodb.org/manual/tutorial/change-oplog-size/), in megabytes, for example, set **50** to be *50MB*.

#### REPLICA_SET_NAME
Define the name of the replica set on which you want this server to be attached

#### STORAGE_ENGINE
Define the storage engine you want to plug to your mongod server. [mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [wiredTiger](http://www.wiredtiger.com/) and [rocksdb](http://rocksdb.org/) are currently available.

---

Inspired by [mongo-rocks](https://github.com/jadsonlourenco/docker-mongo-rocks) from [jadsonlourenco](https://twitter.com/jadsonlourenco)
and  [mongo-rocks](https://github.com/structuresound/docker-mongo-rocks) from [Chroma](https://github.com/structuresound)
