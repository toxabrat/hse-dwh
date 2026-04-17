#!/bin/bash
set -e

REPLICA_NAME=$1
VOLUME_NAME=$2
PORT=$3
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMONS_DIR="$SCRIPT_DIR/../commons"

docker rm -f $REPLICA_NAME 2>/dev/null || true

docker run -d \
    --name $REPLICA_NAME \
    --network dwh_tasks_dwh-network \
    -p $PORT:5432 \
    -v $VOLUME_NAME:/var/lib/postgresql/data \
    -v "$COMMONS_DIR/postgresql.conf":/etc/postgresql/postgresql.conf \
    -v "$COMMONS_DIR/pg_hba.conf":/etc/postgresql/pg_hba.conf \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    postgres:17 \
    postgres -c hot_standby=on -c config_file=/etc/postgresql/postgresql.conf

sleep 10
