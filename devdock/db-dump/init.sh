#!/bin/sh

stop() {
    mysqldump -h db -u root --databases ${MYSQL_DATABASE} > /dumps/$(date +"%FT%T")-${MYSQL_DATABASE}.sql
    exit 0
}
trap stop INT TERM

while true
do
    sleep 1
done
