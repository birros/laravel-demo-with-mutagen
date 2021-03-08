ARG MARIADB_VERSION=latest

FROM mariadb:${MARIADB_VERSION}

COPY ./init.sh /usr/local/bin/init

RUN chmod +x /usr/local/bin/*

ENTRYPOINT []

CMD ["/usr/local/bin/init"]

