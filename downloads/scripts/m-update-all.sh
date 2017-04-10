#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    sudo `readlink -f "$0"`
    exit
fi

LOGFILE=".update.log"
PAD="----------------------------------------"

echo "$PAD$PAD\nSYSTEM UPDATE STARTED @@ `date`\n$PAD$PAD" > $LOGFILE

echo "`date +%H:%M:%S` apt-get update"
apt-get update >> $LOGFILE 2>&1

echo "`date +%H:%M:%S` apt-get upgrade"
apt-get upgrade -y >> $LOGFILE 2>&1

echo "`date +%H:%M:%S` apt-get dist-upgrade"
apt-get dist-upgrade -y >> $LOGFILE 2>&1

echo "`date +%H:%M:%S` apt-get autoclean"
apt-get autoclean -y >> $LOGFILE 2>&1

echo "`date +%H:%M:%S` apt-get autoremove"
apt-get autoremove -y >> $LOGFILE 2>&1

echo "$PAD$PAD\nSYSTEM UPDATE FINISHED @@ `date`\n$PAD$PAD" >> $LOGFILE
