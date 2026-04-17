#!/bin/bash
set -e

SERVICE_NAME=$1

docker exec ${SERVICE_NAME} psql -U postgres -c "CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_pass';" 2>/dev/null || true
docker exec ${SERVICE_NAME} psql -U postgres -c "SELECT pg_create_physical_replication_slot('replica_slot');" 2>/dev/null || true
