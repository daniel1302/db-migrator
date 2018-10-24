#!/usr/bin/env bash

if [ ! $# -eq 2 ]; then
    echo "USAGE: $0 DB_CONFIG.json OUTPUT_DIR";
    exit;
fi;

DB_NUM=$(cat $1 | jq '.databases | length');

for i in $(seq 1 $DB_NUM); do
    IDX=$(($i-1));
    DB_DETAILS=$(cat $1 | jq '.databases['$IDX']');

    
    NAME=$(echo $DB_DETAILS | jq '.name' | tr -d '"');
    USER=$(echo $DB_DETAILS | jq '.user' | tr -d '"');
    PASS=$(echo $DB_DETAILS | jq '.pass' | tr -d '"');
    HOST=$(echo $DB_DETAILS | jq '.host' | tr -d '"');


    OUT_DIR=$(dirname $0)'/'$2;
    mkdir -p $OUT_DIR;

    if (mysql --user=$USER --host=$HOST --password=$PASS $NAME -e "" 2>/dev/null) ; then

        echo "Exporting $NAME";
        mysqldump --user=$USER --host=$HOST --password=$PASS $NAME 2>/dev/null \
            | pv \
            | gzip \
            > $OUT_DIR'/'$NAME'.gz' ;

    else
        echo "Cannot connect to the $NAME database";

    fi;

done;