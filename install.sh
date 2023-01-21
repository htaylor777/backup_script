#!/bin/sh
#----------------------------------------------------------------------------
#  01/2023 - version 1.0
#  Hilery Taylor - https://github.com/htalor777/auto_backup
#  install script to /usr/local/bin 
#  sym link it: ln -s /usr/local/bin/rsync_to_backup.sh backup
#  you should be able to call it anywhere on the system using keyword "backup"
#----------------------------------------------------------------------------

CONF=$HOME/backup/backup.conf

if [ ! -f "$CONF" ]; then
   echo "$CONF does not exists - attempting to create"
   echo "mkdir -p $CONF"
fi

