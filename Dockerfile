FROM debian:testing

MAINTAINER Guillaume Simonneau <simonneaug@gmail.com>
LABEL Descritpion="mongodb roccksdb mongo mongod mongos mongotools bsondump mongodump mongorestore mongoimport mongoexport mongostat mongofiles mongooplog mongotop"

COPY ./install/ /install/
RUN chmod +x -R /install
RUN sh /install/install_mongoserver.sh
RUN sh /install/install_mongotools.sh

COPY ./default_config.yml /config.yml

CMD ["mongod --config /config.yml"]
