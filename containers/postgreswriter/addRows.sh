#!/bin/bash
ctr=0;
cID=$(cat /proc/self/cgroup | grep 'docker' |  tail -n1 | sed 's/^.*\///');

while :
do
runSQL="insert into $POSTGRES_TABLE values (current_timestamp, '$cID', $ctr);"
ctr=$(( $ctr + 1 ));
#psql -h $POSTGRES_HOST -d $POSTGRES_DB -U $POSTGRES_USER -c "$runSQL"
psql postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}/${POSTGRES_DB} -c "$runSQL"
sleep 1;
done