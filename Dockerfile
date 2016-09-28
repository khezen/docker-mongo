FROM debian:jessie

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>

# miscellaneous
RUN apt-get update \
&&  apt-get install -y build-essential git binutils \

# RocksDB
&&  apt-get update \
&&  apt-get install -y libbz2-dev libsnappy-dev zlib1g-dev libzlcore-dev \

&&  git clone https://github.com/facebook/rocksdb.git \
&&  cd rocksdb \
&&  git checkout tags/v4.9 \
&&  CXXFLAGS="-flto -Os -s" make -j$(nproc) shared_lib \
&&  make install \

# MongoDB
&&  apt-get update \
&&  apt-get install -y scons \
&&  git clone https://github.com/mongodb-partners/mongo-rocks.git /mongo-rocks \
&&  cd /mongo-rocks \
&&  git checkout tags/r3.2.9 \
&&  git clone https://github.com/mongodb/mongo.git /mongo \
&&  cd /mongo \
&&  git checkout tags/r3.2.9 \
&&  mkdir -p src/mongo/db/modules/ \
&&  ln -sf /mongo-rocks src/mongo/db/modules/rocks \
&&  CXXFLAGS="-flto -Os -s" scons CPPPATH=/usr/local/include LIBPATH=/usr/local/lib -j$(nproc) --release --prefix=/usr --opt core  install \

# purge
&&  strip /usr/bin/mongo \
&&  strip /usr/bin/mongod \
&&  strip /usr/bin/mongos \
&&  apt-get -y --purge autoremove build-essential git scons binutils \
&&  rm -rf /rocksdb \
&&  rm -rf /mongo-rocks \
&&  rm -rf /mongo \
&&  rm -f /usr/bin/mongoperf \
&&  rm -f /usr/local/lib/librocksdb.a

# configuration and startup
ENV auth="no" \
    admin_user="admin" \
    admin_pwd="changeme" \
    dbpath="/data/db" \
    db_user="user" \
    db_pwd="changeme" \
    rs_name="" \
    storage_engine="rocksdb" \
    shard="no"

COPY ./set_auth.sh /
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh && chmod +x /set_auth.sh

ENTRYPOINT ["/entrypoint.sh"]
