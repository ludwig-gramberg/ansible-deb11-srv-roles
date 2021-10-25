#!/bin/sh

if [ $USER != "backup" ]; then
  echo "only run as backup user"
  exit 1
fi

cd /var/backups/server/r3b

# check if target exists

target=$1
config="targets/$target"

if [ ! -f $config ]; then
  echo "config for target $target not found"
  exit 1
fi

source defaults
source $config

if [ $active != 1 ]; then
  echo "skip backup: inactive target"
  exit
fi

# check vars

if [ "$server" == "" ]; then
  echo "var server must be configured"
  exit 1
fi
if [ "$path" == "" ]; then
  echo "var path must be configured"
  exit 1
fi
if [ "$exclude" != "" ] && [ ! -f exclude/$exclude ]; then
  echo "missing exclude-file exclude/$exclude"
  exit 1
fi

# run backup

echo "begin backup of target $target"

# prep mirror-dir

mkdir -p mirrors/$target

# build and run rsync cmd

cmd="rsync -trH --delete-after --no-links --info=skip0 --rsync-path='sudo rsync' -e 'ssh'"
if [ "$exclude" != "" ]; then
  cmd="$cmd --exclude-from exclude/$exclude"
fi
cmd="$cmd $server:$path mirrors/$target"

eval $cmd
rc=$?

if [ $rc != 0 ]; then
  echo "rsync of $target incomplete"
  exit 1
fi

# prep repo

if [ ! -d repos/$target ]; then
  mkdir -p repos/$target
  restic init -p restic_pass -r repos/$target
fi

# create snapshot and prune

restic -p restic_pass -r repos/$target backup mirrors/$target
restic -p restic_pass -r repos/$target forget --keep-hourly $keep_hours --keep-daily $keep_days --keep-monthly $keep_months
restic -p restic_pass -r repos/$target prune