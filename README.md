# backup_script files and directory for MAC OS and Linux
+ 01/2023 - version 1.0 - written by Hilery Taylor - https://github.com/htaylor777/backup_script
  OS: MAC, Linux
  install script to /usr/local/bin or your bin PATH for global access
# ----------------------------------------------------------------------------
  ***INSTRUCTIONS:
  Configure your file backup server location(s):
-  Line 52: @DEFINE your external BACKUPDRIVE(S): BACKUPDRIVE=<pathToYourFileBackupDrive>[1] [2] [etc]
  
  ***Configure your directory backup location:
-  Line 70: @DEFINE your external BACKUPDRIVE: CLIENT=<pathToYourDirectoryBackupDrive>
-  move this script to your bin location, i.e. /usr/local/bin or your specific bin $PATH
-  sym link it: ln -s /usr/local/bin/rsync_to_backup.sh backup
-  you should be able to call it anywhere on the system using keyword "backup"