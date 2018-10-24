#!/usr/bin/env bash

if [ ! $# -eq 2 ]; then
    echo "USAGE: $0 DB_CONFIG.json INPUT_DIR";
    exit;
fi;

IS_LOCKED=$(cat $1 | jq '.options.lock_import');

if [ "$IS_LOCKED" == "true" ]; then
    echo "You cannot import with this file credential, this file is prevented to import new data";
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


    IN_DIR=$(dirname $0)'/'$2;

    if [ ! -e $IN_DIR'/'$NAME'.gz' ]; then 
        echo "File for $NAME database does not exists. Skipped...";
        continue;
    fi;

    if (mysql --user=$USER --host=$HOST --password=$PASS $NAME -e "" 2>/dev/null) ; then

        echo "Clearing DB before import";
        mysql --user=$USER --host=$HOST --password=$PASS $NAME \
            -e "DROP DATABASE IF EXISTS $NAME; CREATE DATABASE $NAME;" 2>/dev/null;

        
        gunzip -d -c $IN_DIR'/'$NAME'.gz' \
            | pv \
            | mysql --user=$USER --host=$HOST --password=$PASS $NAME  2>/dev/null;

    else

        echo "Cannot connect to the $NAME database";

    fi;

done;