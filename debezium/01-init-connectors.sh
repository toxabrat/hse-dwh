#!/bin/sh

echo "Signing up to Kafka topics:"

while [ "$(curl -s -o /dev/null -w %{http_code} http://debezium:8083/)" -ne 200 ] ; do
  echo -e "Kafka is unavailable yet"
  sleep 5
done

echo "Kafka started. Connecting to the data sources:"
sleep 60

for f in /connectors/*.json; do
  echo "Signing up connectors to data source $f"
  curl -sf -X POST -H "Content-Type: application/json" --data @"$f" http://debezium:8083/connectors || true
  echo ""
done
