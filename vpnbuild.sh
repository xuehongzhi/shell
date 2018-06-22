#!/bin/sh
count=$(ls -1t vpngate* | wc -l)
if [ $count -gt 5 ];then
# retain the latest 5 items
count=`expr $count - 5`
echo $count
ls -1t *.ovpn | tail -$count  |xargs  rm -rf
fi
num=1
if [ $# -eq 1 ];then
 num=$1
fi
ls -1t *.ovpn | head -$num | tail -1  |xargs  sudo openvpn --config

