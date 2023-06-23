#!/bin/bash

IP_ADDRESS=$(hostname -I | awk '{print $1}');

HOSTNAME="HOSTNAME = $(hostname)";
TIMEZONE="TIMEZONE = $(cat /etc/timezone)";
USER="USER = $(whoami)";
OS="OS = $(cat /etc/issue | awk '{ORS=" "; print $1, $2}')";
DATE="DATE = $(date '+%d %b %Y %H:%M:%S')";
UPTIME="UPTIME = $(uptime -s)";
UPTIME_SEC="UPTIME_SEC = $(cat /proc/uptime | awk '{print $1}')";
IP="IP = $IP_ADDRESS";
MASK="MASK = $(ifconfig | grep $IP_ADDRESS | awk '{ORS=" "; print $4}')";
GATEWAY="GATEWAY = $(ip r | grep default | awk '{print $3}')";
RAM_TOTAL="RAM_TOTAL = $(free -m | awk '/Mem:/ {printf "%.3f GB", $2/1024}')";
RAM_USED="RAM_USED = $(free -m | awk '/Mem:/ {printf "%.3f GB", $3/1024}')";
RAM_FREE="RAM_FREE = $(free -m | awk '/Mem:/ {printf "%.3f GB", $4/1024}')";
SPACE_ROOT="SPACE_ROOT = $(df /root/ | awk '/\/$/ {printf "%.2f MB", $2/1024}')";
SPACE_ROOT_USED="SPACE_ROOT_USED = $(df /root/ | awk '/\/$/ {printf "%.2f MB", $3/1024}')";
SPACE_ROOT_FREE="SPACE_ROOT_FREE = $(df /root/ | awk '/\/$/ {printf "%.2f MB", $4/1024}')";

echo $HOSTNAME;
echo $TIMEZONE;
echo $USER;
echo $OS;
echo $DATE;
echo $UPTIME;
echo $UPTIME_SEC;
echo $IP;
echo $MASK;
echo $GATEWAY;
echo $RAM_TOTAL;
echo $RAM_USED;
echo $RAM_FREE;
echo $SPACE_ROOT;
echo $SPACE_ROOT_USED;
echo $SPACE_ROOT_FREE;

read -p "Do you want to save the data? (Y/N) " OUTPUT;

if [[ $OUTPUT == 'y' || $OUTPUT == 'Y' ]]; then
    FILE=$(date +%d_%m_%Y_%H_%M_%S)'.status';

    echo $HOSTNAME >> $FILE;
    echo $TIMEZONE >> $FILE;
    echo $USER >> $FILE;
    echo $OS >> $FILE;
    echo $DATE >> $FILE;
    echo $UPTIME >> $FILE;
    echo $UPTIME_SEC >> $FILE;
    echo $IP >> $FILE;
    echo $MASK >> $FILE;
    echo $GATEWAY >> $FILE;
    echo $RAM_TOTAL >> $FILE;
    echo $RAM_USED >> $FILE;
    echo $RAM_FREE >> $FILE;
    echo $SPACE_ROOT >> $FILE;
    echo $SPACE_ROOT_USED >> $FILE;
    echo $SPACE_ROOT_FREE >> $FILE;
else
    echo "Exit..."
fi
