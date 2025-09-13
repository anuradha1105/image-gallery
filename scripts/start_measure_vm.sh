#!/bin/bash
# monitor_vm.sh

INTERVAL=2
DURATION=60
END=$((SECONDS+DURATION))

mkdir -p /home/vagrant/app/metrics
while [ $SECONDS -lt $END ]; do
  date +"%T" >> /home/vagrant/app/metrics/metrics.txt
  top -b -n1 | head -n5 >> /home/vagrant/app/metrics/metrics.txt
  echo "-------------------" >> /home/vagrant/app/metrics/metrics.txt
  sleep $INTERVAL
done