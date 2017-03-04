#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 -d $POSTGRES_DB --username "$POSTGRES_USER" <<EOSQL
    \connect $POSTGRES_DB
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO "$POSTGRES_USER";
    create table flockertab(intime timestamp, container_id varchar(90) NOT NULL, counter INT NOT NULL, PRIMARY KEY (container_id,counter) );
EOSQL