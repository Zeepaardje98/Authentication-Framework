#!/bin/bash
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"

echo "CONTAINER STARTED"

echo "wait for KDC to run"
while ! nc -zv kerberos 88 >/dev/null 2>&1;
do
  echo "waiting..."
  sleep 5
done
echo "KDC running!"

/tmp/authenticate.sh

while sleep 60
do
  echo "RUNNING"
done

echo "CONTAINER STOPPED"