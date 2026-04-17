export PGPASSWORD=postgres
DWH_HOST="postgres-dwh"
DWH_USER="postgres"
DWH_DB="dwh_db"

TABLES="order_items order_status_history orders pickup_points products shipment_movements shipment_status_history shipments user_addresses user_status_history users warehouses"

echo "Waiting for JDBC to create raw stage in the dwh:"

for table in $TABLES; do
  until psql -h "$DWH_HOST" -U "$DWH_USER" -d "$DWH_DB" -c "SELECT 1 FROM raw_data.$table LIMIT 1;" > /dev/null 2>&1; do
    echo "Waiting for table raw_data.$table to be created by JDBC"
    sleep 20
  done
  echo "Table raw_data.$table is created"
done

echo "All raw_stage tables have been initialized by JDBC!"
echo "Exiting the init script"