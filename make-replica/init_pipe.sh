#!/bin/bash
set -e

./make-replica/bash/01-create-user.sh postgres-user
./make-replica/bash/02-backup.sh postgres-user dwh_tasks_pgdata-user-replica
./make-replica/bash/03-init.sh pg-replica-user dwh_tasks_pgdata-user-replica 5445

./make-replica/bash/01-create-user.sh postgres-order
./make-replica/bash/02-backup.sh postgres-order dwh_tasks_pgdata-order-replica
./make-replica/bash/03-init.sh pg-replica-order dwh_tasks_pgdata-order-replica 5446

./make-replica/bash/01-create-user.sh postgres-logistics
./make-replica/bash/02-backup.sh postgres-logistics dwh_tasks_pgdata-logistics-replica
./make-replica/bash/03-init.sh pg-replica-logistics dwh_tasks_pgdata-logistics-replica 5447
