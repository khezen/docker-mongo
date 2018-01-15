#!/bin/sh

MONGO_VERSION=3.6.2
ROCKSDB_VERSION=5.9.2

# misc
echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list
apt-get update
apt-get install -y build-essential git binutils python scons libssl-dev gcc-5

# RocksDB
apt-get update
apt-get install -y libbz2-dev libsnappy-dev zlib1g-dev
git clone https://github.com/facebook/rocksdb.git
cd rocksdb
git checkout tags/v$ROCKSDB_VERSION
USE_RTTI=1 CFLAGS="-fPIC" CXXFLAGS="-flto -Os -s" make -j$(nproc) static_lib
make install

# MongoDB
git clone https://github.com/mongodb-partners/mongo-rocks.git /mongo-rocks
cd /mongo-rocks
git checkout tags/r$MONGO_VERSION
git clone https://github.com/mongodb/mongo.git /mongo
cd /mongo
git checkout tags/r$MONGO_VERSION
mkdir -p src/mongo/db/modules/
ln -sf /mongo-rocks src/mongo/db/modules/rocks
CXXFLAGS="-flto -Os -s" scons CPPPATH=/usr/local/include LIBPATH=/usr/local/lib -j$(nproc) --disable-warnings-as-errors --release --prefix=/usr --opt core  install

# purge
strip /usr/bin/mongoperf
strip /usr/bin/mongo
strip /usr/bin/mongod
strip /usr/bin/mongos
apt-get -y --purge autoremove build-essential git binutils python scons libssl-dev gcc-5
rm -rf /rocksdb
rm -rf /mongo-rocks
rm -rf /mongo
rm -f /usr/local/lib/librocksdb.a
rm -f /usr/bin/gcc
