#!/bin/sh
#----------------------------------------------------------------------------
#  01/2023 - version 1.0
#  Hilery Taylor - https://github.com/htalor777/backup_script
#  OS: MAC, Linux
#  install script to /usr/local/bin or your bin PATH for global access
# ----------------------------------------------------------------------------
#  ***INSTRUCTIONS:
#  Configure your file backup server location(s):
#  Line 52: @DEFINE your external BACKUPDRIVE(S): BACKUPDRIVE=<pathToYourFileBackupDrive>[1] [2] [etc]
#  
#  ***Configure your directory backup location:
#  Line 70: @DEFINE your external BACKUPDRIVE: CLIENT=<pathToYourDirectoryBackupDrive>
#  move this script to your bin location, i.e. /usr/local/bin or your specific bin PATH
#  sym link it: ln -s /usr/local/bin/rsync_to_backup.sh backup
#  you should be able to call it anywhere on the system using keyword "backup"
#----------------------------------------------------------------------------

function proc_file_backup() {
fl=$1
clbackup=$2
dir=$3

if [[ ! -z "$3"  && ! -d $clbackup/$dir ]]; then 
echo "attempting to mkdir backup $fl to $clbackup/$dir"
mkdir -p $clbackup/"$dir"
rsync -az --progress --no-perms --no-group --no-owner --stats --human-readable "$fl" $clbackup/$dir 
exit 0

elif [[ ! -z "$3"  && -d $clbackup/"$dir" ]]; then
echo "$dir exists: attempting to backup $fl to $clbackup/$dir"
rsync -az --progress --no-perms --no-group --no-owner --stats --human-readable "$fl" $clbackup/$dir 
exit 0

elif [  -z "$3" ]; then
echo "attempting to direct volume backup $fl to $clbackup"
rsync -az --progress --no-perms --no-group --no-owner --stats --human-readable "$fl" $clbackup
exit 0
fi
}




function file_bkup_init() {
INFILE=$1
echo "your file is: $INFILE"
echo "Which Volume Name Drive would like as the destination for your backup: $INFILE?"
echo "Choose by number:"
echo "Client1->[1] or Client2->[2] or Quit->[-1]: "
read client

if [ $client -eq -1 ]; then
echo "...Quitting"
exit 0
fi

# @DEFINE your external BACKUPDRIVE(S) below: BACKUPDRIVE=<pathtoyourbackupdrive>
echo "If there is a backup sub-directory name in the backup $client enter it here: "
read dirext

  if [ $client == 1 ]; then
     BACKUPDRIVE="/Volumes/Client_1"
     proc_file_backup "$INFILE" $BACKUPDRIVE $dirext

 elif [ $client == 2 ]; then
     BACKUPDRIVE="/Volumes/client_2"
     proc_file_backup "$INFILE" $BACKUPDRIVE $dirext

 else echo "invalid choice, choose 1 or 2 for backup drives"    
fi
}


function dir_bkup_init() {
INDIR=$1
CLIENT="/Volumes/Backups-1"
ArcDate="$(date +%F)"

if [ ! -d "${CLIENT}/$ArcDate" ]; then
echo " Attempting to mkdir ${CLIENT}/$ArcDate"
mkdir -p "${CLIENT}/$ArcDate"
fi

echo "Attempting to backup your directory: $INDIR to ${CLIENT}/$ArcDate"
rsync -vrltD --progress --no-perms --no-group --no-owner --stats --human-readable "$INDIR" $CLIENT/$ArcDate --exclude=".*/" 
##rsync -vrltD --progress --no-perms --no-group --no-owner --stats --human-readable ${INDIR} ${CLIENT}/$ArcDate --exclude=".*/" |  pv -lep -s 42 >/dev/null
exit 0
}


function pathfile_backup() {
echo " What is your File Name to backup? "
read thispathfile

if [ -e "$(pwd)"/$thispathfile ]; then 
file_bkup_init "$(pwd)"/$thispathfile
else
echo "ERROR: your file: $(pwd)/$thispathfile does not exist"
echo "ABORTING BACKUP"
exit 1
fi
}



function directory_backup() {
echo " What is your Directory Name that you want to backup? "
read thisdirectory

if [ -e "$(pwd)"/$thisdirectory ]; then
dir_bkup_init "$(pwd)"/$thisdirectory
echo "ERROR: your directory: "$(pwd)"/$thisdirectory does not exist"
echo "ABORTING BACKUP"
exit 1
fi
}


function init() {

echo "||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "                                                      "
echo "	BACKUP DIRECTORY OR FILE TO BACKUP DRIVES:         "
echo "______________________________________________________"
echo "            Select number of backup type: "
echo "             Directory Backup->[0]"
echo "                  File Backup->[1]"
echo "                     or Quit->[-1]"
echo "____________________________________________________"
while read bktype
do
if [ $bktype -eq -1 ]; then
   echo "Quitting"
exit 0
elif [ $bktype -eq 0 ]; then
   directory_backup
elif [ $bktype -eq 1 ]; then
   pathfile_backup
else
clear
echo "Invalid choice, try again: " 
init
fi
done
}
clear
init
