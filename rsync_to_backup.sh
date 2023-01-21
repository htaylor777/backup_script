#!/bin/sh
#----------------------------------------------------------------------------
#  01/2023 - version 1.0
#  Hilery Taylor - https://github.com/htalor777/auto_backup
#  install script to /usr/local/bin 
#  sym link it: ln -s /usr/local/bin/rsync_to_backup.sh backup
#  you should be able to call it anywhere on the system using keyword "backup"
#----------------------------------------------------------------------------

export CURRENT=`pwd`

function procbackup() {
fl=$1
clbackup=$2
dir=$3

if [[ ! -z "$3"  && ! -d $clbackup/$dir ]]; then 
echo "attempting to mkdir backup $fl to $clbackup/$dir"

elif [[ ! -z "$3"  && -d $clbackup/$dir ]]; then
echo "$dir exists: attempting to backup $fl to $clbackup/$dir"

elif [  -z "$3" ]; then
echo "attempting to direct volume backup $fl to $clbackup"
fi

}




function file_bkup_init() {
INFILE=$1
echo "your file is: $INFILE"
echo "What is the volume name where you would like to backup $INFILE to?"
echo "Choose by number:"
echo "client1->[1] or client2->[2]"
read client

echo "If there is a backup directory name in the backup $client enter it here: "
read dirext

  if [ $client == 1 ]; then
     CLIENT="/Volumes/client_1"
     procbackup $INFILE $CLIENT $dirext

 elif [ $client == 2 ]; then
     CLIENT="/Volumes/client_2"
     procbackup $INFILE $CLIENT $dirext

 else echo "invalid choice, choose 1 or 2"    
fi
}


function dir_bkup_init() {
INDIR=$1
CLIENT="/Volumes/Backups"
ArcDate="$(date +%F)"

if [ ! -d "${CLIENT}/$ArcDate" ]; then
echo " Attempting to mkdir ${CLIENT}/$ArcDate"
mkdir -p "${CLIENT}/$ArcDate"
fi

echo "Attempting to backup your directory: $INDIR to ${CLIENT}/$ArcDate"
rsync -vrltD --progress --no-perms --no-group --no-owner --stats --human-readable ${INDIR} ${CLIENT}/$ArcDate --exclude=".*/" |  pv -lep -s 42 >/dev/null
exit 0
}


function pathfile_backup() {
echo " What is your File to backup? "
read thispathfile

if [ -e "${CURRENT}/$thispathfile" ]; then 
file_bkup_init ${CURRENT}/$thispathfile
else
echo "ERROR: your file: ${CURRENT}/$thispathfile does not exist"
echo "ABORTING BACKUP"
exit 1
fi
}



function directory_backup() {
echo " What is your Directory to backup? "
read thisdirectory

if [ -e "${CURRENT}/$thisdirectory" ]; then 
dir_bkup_init ${CURRENT}/$thisdirectory
else
echo "ERROR: your directory: ${CURRENT}/$thisdirectory does not exist"
echo "ABORTING BACKUP"
exit 1
fi
}


function init() {

echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "____________________________________________________"
echo "	RSYNC FILE TO BACKUP DRIVE:"
echo "____________________________________________________"
echo " Select number of backup type: "
echo " Directory Backup->[0] or File Backup->[1] Quit->[-1]"

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