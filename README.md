# Supported tags and respective `Dockerfile` links

* `3.6.2`, `3.6`, `3`, `latest` [(3.6/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.6/Dockerfile)

# What is MongoDB?
MongoDB (from "humongous") is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster. Released under a combination of the GNU Affero General Public License and the Apache License, MongoDB is free and open-source software.

[wikipedia.org/wiki/MongoDB](https://en.wikipedia.org/wiki/MongoDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/mongo/logo.png)

# rocksdb
This image embed [`rocksdb`](http://rocksdb.org/) next to [`wiredTiger`](http://www.wiredtiger.com/) and `mmapv1` storage engines.

---
# How To Use

## run examples

using config file 

```bash
docker run -d -p 27017:27017 khezen/mongo:latest
```   

```bash
docker run -d -p 27017:27017 -v /data/mongo:/data/db -v /etc/mongo:/etc/mongo khezen/mongo:latest
```

```bash
docker run -d -it -p 27017:27017 khezen/mongo:latest "mongod --config etc/mongo/config.yml"
```

using command and options
```bash
docker run -d -it -p 27017:27017 -v /data/mongo/shard1:/data/db khezen/mongo:latest "mongod --port 27017 --shardsvr --replSet shard1 --dbpath /data/db"
```


## config
start with this [config file](./config.yml) by default. For more configuration options have a look at the [documentation](http://docs.mongodb.org/manual/reference/configuration-options/)

## cmd
The image embed the following binaries:
* mongo
* mongod
* mongos
* mongoperf
* bsondump
* mongoimport
* mongoexport
* mongodump
* mongorestore
* mongostat
* mongofiles
* mongotop
* mongoreplay

# User Feedback
## Issues
If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/Khezen/docker-mongo/issues).
