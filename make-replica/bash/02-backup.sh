#!/bin/bash
set -e

SERVICE_NAME=$1
VOLUME_NAME=$2

docker stop pg-replica-${SERVICE_NAME#postgres-} 2>/dev/null || true
docker rm pg-replica-${SERVICE_NAME#postgres-} 2>/dev/null || true
docker volume rm $VOLUME_NAME 2>/dev/null || true
docker volume create $VOLUME_NAME

docker run --rm \
    --network dwh_tasks_dwh-network \
    -v $VOLUME_NAME:/var/lib/postgresql/data \
    postgres:17 \
    pg_basebackup -h $SERVICE_NAME -U replicator \
    -D /var/lib/postgresql/data -Fp -Xs -P -R -S replica_slot
