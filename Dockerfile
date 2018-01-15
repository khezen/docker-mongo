FROM debian:stretch-slim
LABEL Descritpion="mongodb roccksdb mongo mongod mongos mongotools bsondump mongodump mongorestore mongoimport mongoexport mongostat mongofiles mongooplog mongotop"

COPY ./install/ /install/
RUN chmod +x -R /install
RUN sh /install/mongoserver.sh
RUN sh /install/mongotools.sh


COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY ./config.yml /.backup/mongo/config.yml
ENTRYPOINT  ["/entrypoint.sh"]
CMD ["mongod --config etc/mongo/config.yml"]
