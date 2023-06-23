#!/bin/bash

set_color () {
    local color='';

    if [[ $1 == 1 ]]; then color='white';
    elif [[ $1 == 2 ]]; then color='red';
    elif [[ $1 == 3 ]]; then color='green';
    elif [[ $1 == 4 ]]; then color='blue';
    elif [[ $1 == 5 ]]; then color='purple';
    elif [[ $1 == 6 ]]; then color='black';
    fi

    echo $color;
}

source ./default.conf

COLOR[1]='\033[0;37m';  # white
COLOR[2]='\033[0;31m';  # red
COLOR[3]='\033[0;32m';  # green
COLOR[4]='\033[0;34m';  # blue
COLOR[5]='\033[0;35m';  # purple
COLOR[6]='\033[0;30m';  # black

BG_COLOR[1]='\033[47m';  # white
BG_COLOR[2]='\033[41m';  # red
BG_COLOR[3]='\033[42m';  # green
BG_COLOR[4]='\033[44m';  # blue
BG_COLOR[5]='\033[45m';  # purple
BG_COLOR[6]='\033[40m';  # black

RESET='\033[0m';           # Reset color

if (( $# > 4 )); then
    echo "Error: You must pass only 4 params and no more" >&2;
    exit 1;
fi

for param in $@; do
    if [[ ! $param =~ ^[0-9]+$ ]]; then
        echo "Error: The param must be a number" >&2;
        exit 1;
    elif (( $param < 1 )) | (( $param > 6 )); then
        echo "Error: The param must be in 1..6 integer range";
        exit 1;
    fi
done

bg_name_color=$1;
fr_name_color=$2;
bg_val_color=$3;
fr_val_color=$4;

if [[ -z $1 ]]; then bg_name_color=$column1_background; fi
if [[ -z $2 ]]; then fr_name_color=$column1_font_color; fi
if [[ -z $3 ]]; then bg_val_color=$column2_background; fi
if [[ -z $4 ]]; then fr_val_color=$column2_font_color; fi

if [[ $bg_name_color == $fr_name_color ]] || [[ $bg_val_color == $fr_val_color ]]; then
    echo "error: The colors of background and value are match" >&2;
    exit 1;
fi

BG_NAME=${BG_COLOR[$bg_name_color]};
FR_NAME=${COLOR[$fr_name_color]};
BG_VAL=${BG_COLOR[$bg_val_color]};
FR_VAL=${COLOR[$fr_val_color]};

IP_ADDRESS=$(hostname -I | awk '{print $1}');

HOSTNAME=$FR_NAME$BG_NAME"HOSTNAME$RESET = $FR_VAL$BG_VAL$(hostname)"$RESET;
TIMEZONE=$FR_NAME$BG_NAME"TIMEZONE$RESET = $FR_VAL$BG_VAL$(cat /etc/timezone)"$RESET;
USER=$FR_NAME$BG_NAME"USER$RESET = $FR_VAL$BG_VAL$(whoami)"$RESET;
OS=$FR_NAME$BG_NAME"OS$RESET = $FR_VAL$BG_VAL$(cat /etc/issue | awk '{ORS=" "; print $1, $2}')"$RESET;
DATE=$FR_NAME$BG_NAME"DATE$RESET = $FR_VAL$BG_VAL$(date '+%d %b %Y %H:%M:%S')"$RESET;
UPTIME=$FR_NAME$BG_NAME"UPTIME$RESET = $FR_VAL$BG_VAL$(uptime -s)"$RESET;
UPTIME_SEC=$FR_NAME$BG_NAME"UPTIME_SEC$RESET = $FR_VAL$BG_VAL$(cat /proc/uptime | awk '{print $1}')"$RESET;
IP=$FR_NAME$BG_NAME"IP$RESET = $FR_VAL$BG_VAL$IP_ADDRESS"$RESET;
MASK=$FR_NAME$BG_NAME"MASK$RESET = $FR_VAL$BG_VAL$(ifconfig | grep $IP_ADDRESS | awk '{ORS=" "; print $4}')"$RESET;
GATEWAY=$FR_NAME$BG_NAME"GATEWAY$RESET = $FR_VAL$BG_VAL$(ip r | grep default | awk '{print $3}')"$RESET;
RAM_TOTAL=$FR_NAME$BG_NAME"RAM_TOTAL$RESET = $FR_VAL$BG_VAL$(free -m | awk '/Mem:/ {printf "%.3f GB", $2/1024}')"$RESET;
RAM_USED=$FR_NAME$BG_NAME"RAM_USED$RESET = $FR_VAL$BG_VAL$(free -m | awk '/Mem:/ {printf "%.3f GB", $3/1024}')"$RESET;
RAM_FREE=$FR_NAME$BG_NAME"RAM_FREE$RESET = $FR_VAL$BG_VAL$(free -m | awk '/Mem:/ {printf "%.3f GB", $4/1024}')"$RESET;
SPACE_ROOT=$FR_NAME$BG_NAME"SPACE_ROOT$RESET = $FR_VAL$BG_VAL$(df /root/ | awk '/\/$/ {printf "%.2f MB", $2/1024}')"$RESET;
SPACE_ROOT_USED=$FR_NAME$BG_NAME"SPACE_ROOT_USED$RESET = $FR_VAL$BG_VAL$(df /root/ | awk '/\/$/ {printf "%.2f MB", $3/1024}')"$RESET;
SPACE_ROOT_FREE=$FR_NAME$BG_NAME"SPACE_ROOT_FREE$RESET = $FR_VAL$BG_VAL$(df /root/ | awk '/\/$/ {printf "%.2f MB", $4/1024}')"$RESET;

echo -e $HOSTNAME;
echo -e $TIMEZONE;
echo -e $USER;
echo -e $OS;
echo -e $DATE;
echo -e $UPTIME;
echo -e $UPTIME_SEC;
echo -e $IP;
echo -e $MASK;
echo -e $GATEWAY;
echo -e $RAM_TOTAL;
echo -e $RAM_USED;
echo -e $RAM_FREE;
echo -e $SPACE_ROOT;
echo -e $SPACE_ROOT_USED;
echo -e $SPACE_ROOT_FREE;

color_1=$(set_color $bg_name_color);
color_2=$(set_color $fr_name_color);
color_3=$(set_color $bg_val_color);
color_4=$(set_color $fr_val_color);

if [[ -z "$1" ]]; then bg_name_color='default'; fi
if [[ -z "$2" ]]; then fr_name_color='default'; fi
if [[ -z "$3" ]]; then bg_val_color='default'; fi
if [[ -z "$4" ]]; then fr_val_color='default'; fi

echo -en "\n"
echo "Column 1 background = $bg_name_color ($color_1)"
echo "Column 1 font color = $fr_name_color ($color_2)"
echo "Column 2 background = $bg_val_color ($color_3)"
echo "Column 2 font color = $fr_val_color ($color_4)"
