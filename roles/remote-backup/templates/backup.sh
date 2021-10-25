#!/bin/sh

if [ $USER != "backup" ]; then
   echo "only run as backup user"
   exit 1
fi

cd /var/backups/server/r3b
targets=$(ls config/targets)

for target in $targets; do
  bash bin/target.sh $target
  rc=$?
  if [ $rc = 0 ]; then
    echo "back up of $target complete"
  else
    echo "back up of $target incomplete"
  fi
done