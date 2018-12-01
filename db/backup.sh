#!/bin/sh

DATE=$(date +%Y%m%d-%H%M%S)
mysqldump -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > /var/lib/sql/${MYSQL_DATABASE}_${DATE}.sql > /dev/null 2>&1