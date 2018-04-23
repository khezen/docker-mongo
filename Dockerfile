FROM debian:stretch-slim as build
ENV MONGO_VERSION=3.6.2
ENV ROCKSDB_VERSION=5.9.2
# misc
RUN echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list \
&&  apt-get update \
&&  apt-get install -y \
    build-essential \
    git \
    binutils \
    python \
    scons \
    libssl-dev \
    gcc-5 \
    libbz2-dev \
    libsnappy-dev \
    zlib1g-dev \
    wget \
    git \
    binutils
# RocksDB
RUN git clone https://github.com/facebook/rocksdb.git
RUN cd rocksdb &&  git checkout tags/v$ROCKSDB_VERSION \
&&  USE_RTTI=1 CFLAGS="-fPIC" CXXFLAGS="-flto -Os -s" make -j$(nproc) static_lib \
&&  make install
# MongoDB
RUN git clone https://github.com/mongodb-partners/mongo-rocks.git /mongo-rocks \
&&  cd /mongo-rocks && git checkout tags/r$MONGO_VERSION
RUN git clone https://github.com/mongodb/mongo.git /mongo
RUN apt-get install -y python-dev
RUN wget https://bootstrap.pypa.io/get-pip.py \
&&  python get-pip.py
RUN  cd /mongo && git checkout tags/r$MONGO_VERSION \
&&  mkdir -p src/mongo/db/modules/ \
&&  ln -sf /mongo-rocks src/mongo/db/modules/rocks \
&&  pip install -r buildscripts/requirements.txt \
&&  CXXFLAGS="-flto -Os -s" scons CPPPATH=/usr/local/include LIBPATH=/usr/local/lib -j$(nproc) --disable-warnings-as-errors --release --prefix=/usr --opt core --ssl install
RUN strip /usr/bin/mongoperf \
&&  strip /usr/bin/mongo \
&&  strip /usr/bin/mongod \
&&  strip /usr/bin/mongos
# mongotools
ENV GO_VERSION=1.9.1
RUN wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz -P /usr/local \
&&  tar -C /usr/local -xzf /usr/local/go$GO_VERSION.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"
ENV TOOLS_PKG='github.com/mongodb/mongo-tools'
RUN git clone https://github.com/mongodb/mongo-tools /usr/local/go/src/${TOOLS_PKG} \
&&  cd /usr/local/go/src/${TOOLS_PKG} && git checkout tags/r$MONGO_VERSION
RUN cp -avr /usr/local/go/src/${TOOLS_PKG}/vendor/src/* /usr/local/go/src
RUN apt-get install -y libpcap-dev
RUN cd /usr/local/go/src/${TOOLS_PKG} \
&&  go build -o /usr/bin/bsondump bsondump/main/bsondump.go \
&&  go build -o /usr/bin/mongoimport mongoimport/main/mongoimport.go \
&&  go build -o /usr/bin/mongoexport mongoexport/main/mongoexport.go \
&&  go build -o /usr/bin/mongodump mongodump/main/mongodump.go \
&&  go build -o /usr/bin/mongorestore mongorestore/main/mongorestore.go \
&&  go build -o /usr/bin/mongostat mongostat/main/mongostat.go \
&&  go build -o /usr/bin/mongofiles mongofiles/main/mongofiles.go \
&&  go build -o /usr/bin/mongotop mongotop/main/mongotop.go \
&&  go build -o /usr/bin/mongoreplay mongoreplay/main/mongoreplay.go
RUN strip /usr/bin/bsondump \
&&  strip /usr/bin/mongoimport \
&&  strip /usr/bin/mongoexport \
&&  strip /usr/bin/mongodump \
&&  strip /usr/bin/mongorestore \
&&  strip /usr/bin/mongostat \
&&  strip /usr/bin/mongofiles \
&&  strip /usr/bin/mongotop \
&&  strip /usr/bin/mongoreplay

FROM debian:stretch-slim
LABEL Description="mongodb roccksdb mongo mongod mongos mongotools bsondump mongodump mongorestore mongoimport mongoexport mongostat mongofiles mongooplog mongotop mongoreplay"
RUN apt-get update && apt-get install -y libssl-dev
RUN mkdir -p /data/db
COPY --from=build /usr/bin/mongoperf /bin/mongoperf
COPY --from=build /usr/bin/mongo /bin/mongo
COPY --from=build /usr/bin/mongod /bin/mongod
COPY --from=build /usr/bin/mongos /bin/mongos
COPY --from=build /usr/bin/bsondump /bin/bsondump
COPY --from=build /usr/bin/mongoimport /bin/mongoimport
COPY --from=build /usr/bin/mongoexport /bin/mongoexport
COPY --from=build /usr/bin/mongodump /bin/mongodump
COPY --from=build /usr/bin/mongorestore /bin/mongorestore
COPY --from=build /usr/bin/mongostat /bin/mongostat
COPY --from=build /usr/bin/mongofiles /bin/mongofiles
COPY --from=build /usr/bin/mongotop /bin/mongotop
COPY --from=build /usr/bin/mongotop /bin/mongoreplay
COPY ./config.yml /.backup/mongo/config.yml
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT  ["/entrypoint.sh"]
CMD ["mongod --config etc/mongo/config.yml"]
