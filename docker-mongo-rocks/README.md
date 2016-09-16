# mongod server
supported storage engines:
[mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [wiredTiger](http://www.wiredtiger.com/) and [rocksdb](http://rocksdb.org/)

## How To Use
```
docker run -d -p 27017:27017 -e db_user=test -e db_pwd=test -e DATABASE=mongo Khezen/mongo-rocks:latest
```

## Environment Variables

#### auth |default: yes
To disable authentication, set to **no**.

#### admin_user |default: admin
You need have a user with **root** permissions, manager of the **admin** database ever present.

#### admin_pwd |default: changeme
The password of the **admin_user** above.

#### database
Create a new database with this name, the **db_user** and **db_pwd** will be the owner of this database.

#### db_user |default: user
The user that manage the **database** above - don't have admin permissions.

#### db_pwd |default: changeme
The password of the **db_user** above.

#### dbpath |default: /data/db
The path that store all data, this setting is useful for *Docker volumes*

#### oplog_size
Define the size of [Oplog](https://docs.mongodb.org/manual/tutorial/change-oplog-size/), in megabytes, for example, set **50** to be *50MB*.

#### rs_name |default: rs
Define the name of the replica set on which you want this server to be attached

#### storage_engine |default: rocksdb
Define the storage engine you want to plug to your mongod server. [mmapv1](https://docs.mongodb.com/manual/core/mmapv1/), [wiredTiger](http://www.wiredtiger.com/) and [rocksdb](http://rocksdb.org/) are currently available.

---

Inspired by [mongo-rocks](https://github.com/jadsonlourenco/docker-mongo-rocks) from [jadsonlourenco](https://twitter.com/jadsonlourenco)
and  [mongo-rocks](https://github.com/structuresound/docker-mongo-rocks) from [Chroma](https://github.com/structuresound)
