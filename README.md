# Supported tags and respective `Dockerfile` links

* `3.6.0`, `3.6`, `3`, `latest` [(3.4/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.4/Dockerfile) [![](https://images.microbadger.com/badges/image/khezen/mongo:3.6.svg)](https://microbadger.com/images/khezen/mongo:3.4 "Get your own image badge on microbadger.com")
* `3.6.0-slim`, `3.6-slim`, `3-slim`, `slim` [(3.6-slim/Dockerfile)](https://github.com/Khezen/docker-mongo/blob/v3.4-slim/Dockerfile) [![](https://images.microbadger.com/badges/image/khezen/mongo:3.4-slim.svg)](https://microbadger.com/images/khezen/mongo:3.4-slim "Get your own image badge on microbadger.com")

# What is MongoDB?
MongoDB (from "humongous") is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster. Released under a combination of the GNU Affero General Public License and the Apache License, MongoDB is free and open-source software.

[wikipedia.org/wiki/MongoDB](https://en.wikipedia.org/wiki/MongoDB)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/mongo/logo.png)

---
# How To Use
```
docker run -d -p 27017:27017 khezen/mongo:latest
```   
```
docker run -d -p 27017:27017 -v /data/mongo:/data/mongo -v /etc/mongo:/etc/mongo khezen/mongo:latest
```

# User Feedback
## Issues
If you have any problems with or questions about this image, please ask for help through a [GitHub issue](https://github.com/Khezen/docker-mongo/issues).
