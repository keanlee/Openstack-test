#!/bin/bash
#Author by keanlee

# ansi colors for formatting heredoc
ESC=$(printf "\e")
GREEN="$ESC[0;32m"
NO_COLOR="$ESC[0;0m"
RED="$ESC[0;31m"
MAGENTA="$ESC[0;35m"
YELLOW="$ESC[0;33m"
BLUE="$ESC[0;34m"
WHITE="$ESC[0;37m"
#PURPLE="$ESC[0;35m"
CYAN="$ESC[0;36m"

function NET_NAME_IP(){
#This function can list your network card with it's ip address 

cat 1>&2 <<__EOF__
$MAGENTA=================================================================
     Network Cards on ${YELLOW}$(hostname)${NO_COLOR}${MAGENTA} list below: 
=================================================================
$NO_COLOR
__EOF__

which ifconfig 1>/dev/null 2>&1|| yum install net-tools -y 1>/dev/null

NET_DEV_NAME=$(cat /proc/net/dev | awk '{print $1}' | sed -n '3,$p' | awk -F ":" '{print $1}' | grep -v ^lo$ | grep -v ^macvtap* | grep -v ^tap* | grep -v ^q | grep -v ^virbr* | grep -v ^vnet )
#                                                                                              except the lo and   virtual cards:     macvtap      network name 
for i in $NET_DEV_NAME
    do
        NET_RUN_STATUS=$(ifconfig $i | sed -n '1p' | awk '{print $2}' | awk -F "," '{print $3}')

        if [[ $NET_RUN_STATUS != RUNNING ]];then
            continue
        else
            echo ${BLUE}The network card Name:${NO_COLOR}$YELLOW $i${NO_COLOR} ${BLUE},the network card status:$GREEN $NET_RUN_STATUS $NO_COLOR
        fi
        echo ${BLUE}The IP address is : $NO_COLOR
        IP_ADDR=$(ifconfig $i | grep 'inet[^6]' | sed -n '1p' | awk '{print $2}')
        echo $GREEN $IP_ADDR $NO_COLOR

            if [[ $IP_ADDR = "" ]];then
              echo $RED No IP Address with $i $NO_COLOR
           fi

done
}

function DISK_INFO(){
cat 1>&2 <<__EOF__
$MAGENTA=================================================================
     Disk info on ${YELLOW}$(hostname)${NO_COLOR}${MAGENTA} list below: 
=================================================================
$NO_COLOR
__EOF__

DEVICE=$(cat /proc/partitions | awk '{print $4}' | sed -n '3,$p' | grep "[a-z]$")

for DEVICE_ID in $DEVICE
    do 
        DISK_SIZE=$(lsblk /dev/${DEVICE_ID} | sed -n '2p' | awk '{print $4}')
        echo $BLUE Disk name : ${YELLOW}$DEVICE_ID${NO_COLOR} $BLUE the size is:$YELLOW $DISK_SIZE${NO_COLOR}
        
done
}

NET_NAME_IP
DISK_INFO

